#!/bin/sh
set -eu

COPY=$(printf '%s' "${CLAUDE_PLUGIN_OPTION_WORKTREE_COPY_PATHS:-}" | tr ',' '\n')
LINK=$(printf '%s' "${CLAUDE_PLUGIN_OPTION_WORKTREE_LINK_PATHS:-}" | tr ',' '\n')

normalize() {
	while IFS= read -r rel; do
		rel=${rel# }
		rel=${rel% }
		[ -n "$rel" ] || continue
		case $rel in
		/* | *..* | \~* | *\"* | *\\*) continue ;;
		esac
		printf '%s\n' "$rel"
	done
}

relpath() {
	from=$1
	to=$2
	up=
	while :; do
		case $to in
		"$from"/*) break ;;
		esac
		[ "$from" = "/" ] && break
		from=$(dirname "$from")
		up="../$up"
	done
	rest=${to#"$from"}
	printf '%s%s' "$up" "${rest#/}"
}

input=$(cat)

worktree=
main=
while IFS= read -r cand; do
	[ -n "$cand" ] || continue
	if [ ! -d "$cand" ]; then
		continue
	fi
	root=$(git -C "$cand" worktree list --porcelain 2>/dev/null | sed -n '1s/^worktree //p')
	if [ -z "$root" ] || [ "$root" = "$cand" ]; then
		continue
	fi
	if ! git -C "$root" worktree list --porcelain | grep -qxF "worktree $cand"; then
		continue
	fi
	worktree=$cand
	main=$root
	break
done <<EOF
$(printf '%s' "$input" | grep -oE '"/[^"]+"' | tr -d '"' | sort -u)
EOF

if [ -z "$worktree" ]; then
	exit 0
fi

copy_list=$(printf '%s\n' "$COPY" | normalize)
link_list=$(printf '%s\n' "$LINK" | normalize)

conflicts=
while IFS= read -r rel; do
	[ -n "$rel" ] || continue
	if printf '%s\n' "$copy_list" | grep -qxF -- "$rel"; then
		conflicts="$conflicts $rel"
	fi
done <<EOF
$link_list
EOF

copied=
while IFS= read -r rel; do
	[ -n "$rel" ] || continue
	case " $conflicts " in
	*" $rel "*) continue ;;
	esac
	src="$main/$rel"
	dst="$worktree/$rel"
	if [ ! -e "$src" ] || [ -e "$dst" ] || [ -L "$dst" ]; then
		continue
	fi
	mkdir -p "$(dirname "$dst")"
	if cp -R "$src" "$dst" 2>/dev/null; then
		copied="$copied $rel"
	fi
done <<EOF
$copy_list
EOF

linked=
unignored=
while IFS= read -r rel; do
	[ -n "$rel" ] || continue
	case " $conflicts " in
	*" $rel "*) continue ;;
	esac
	src="$main/$rel"
	dst="$worktree/$rel"
	if [ ! -e "$src" ] || [ -e "$dst" ] || [ -L "$dst" ]; then
		continue
	fi
	dir=$(dirname "$dst")
	mkdir -p "$dir"
	if ln -s "$(relpath "$dir" "$src")" "$dst" 2>/dev/null; then
		linked="$linked $rel"
		if ! git -C "$worktree" check-ignore -q "$rel" 2>/dev/null; then
			unignored="$unignored $rel"
		fi
	fi
done <<EOF
$link_list
EOF

msg=
if [ -n "$copied" ]; then
	msg="${msg}copied$copied. "
fi
if [ -n "$linked" ]; then
	msg="${msg}linked$linked. "
fi
if [ -n "$conflicts" ]; then
	msg="${msg}skipped, listed as both copy and link:$conflicts. "
fi
if [ -n "$unignored" ]; then
	msg="${msg}not git-ignored here, so they show as untracked:$unignored. Ignore patterns match a symlink only without a trailing slash. "
fi

if [ -z "$msg" ]; then
	exit 0
fi

printf '{"systemMessage":"worktree-sync: %s","suppressOutput":true}\n' "${msg% }"
