#!/bin/sh
set -eu

CARRY='CLAUDE.md
.env
.mcp.json
.claude/skills
.claude/settings.json
.claude/settings.local.json'

extra=$(printf '%s' "${CLAUDE_PLUGIN_OPTION_EXTRA_PATHS:-}" | tr -d '[]"' | tr ',' '\n')
if [ -n "$extra" ]; then
	CARRY="$CARRY
$extra"
fi

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

carried=
while IFS= read -r rel; do
	rel=${rel# }
	rel=${rel% }
	[ -n "$rel" ] || continue
	case $rel in
	/* | *..* | \~*) continue ;;
	esac
	src="$main/$rel"
	dst="$worktree/$rel"
	if [ ! -e "$src" ] || [ -e "$dst" ]; then
		continue
	fi
	mkdir -p "$(dirname "$dst")"
	if cp -R "$src" "$dst" 2>/dev/null; then
		carried="$carried $rel"
	fi
done <<EOF
$CARRY
EOF

if [ -z "$carried" ]; then
	exit 0
fi

printf '{"systemMessage":"worktree-setup: copied%s","suppressOutput":true}\n' "$carried"
