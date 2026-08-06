#!/bin/sh
set -eu

PROG=$(basename "$0")

EXCLUDE_MARKER='# new-worktree.sh: linked as symlinks, so directory patterns do not match them'

DEFAULT_LINKS='CLAUDE.md
.env
.mcp.json
.claude/skills
.claude/settings.json
.claude/settings.local.json'

usage() {
	cat <<EOF
Usage: $PROG [-b BASE] [-C REPO] [-n] BRANCH

Create a git worktree on BRANCH, link the repository's untracked local-only files into it, and open it in a new editor window.

A fresh worktree checks out tracked files only, so anything git-ignored - CLAUDE.md, .claude/skills, .env - is missing, and a Claude Code session started there sees none of the project's skills or instructions. This script symlinks them back.

Options:
  -b BASE   base ref for the new branch (default: origin/HEAD, falling back to HEAD)
  -C REPO   repository to branch from (default: the repository containing the current directory)
  -n        do not open an editor; print the worktree path instead
  -h        show this help

Environment:
  WORKTREE_EDITOR   command that opens a directory in a NEW window (default: "zed -n")

The worktree is created at REPO/.claude/worktrees/BRANCH, the same location Claude Code's own worktree tool uses.

Linked when present in REPO:
$(printf '  %s\n' $DEFAULT_LINKS)

List extra paths, one per line, in REPO/.claude/worktree-link. Blank lines and lines starting with # are ignored. Paths are relative to REPO.

A linked directory becomes a symlink, which git's directory patterns ("personal/") no longer match, so it would show up as untracked. For each such link the script appends a slash-free entry to REPO's .git/info/exclude, which is local-only and never committed.
EOF
}

die() {
	printf '%s: %s\n' "$PROG" "$1" >&2
	exit 1
}

BASE=
REPO=
OPEN=1

while getopts b:C:nh opt; do
	case $opt in
	b) BASE=$OPTARG ;;
	C) REPO=$OPTARG ;;
	n) OPEN=0 ;;
	h)
		usage
		exit 0
		;;
	*)
		usage >&2
		exit 2
		;;
	esac
done
shift $((OPTIND - 1))

[ $# -eq 1 ] || {
	usage >&2
	exit 2
}
BRANCH=$1

case $BRANCH in
-* | */ | */../* | *..*)
	die "refusing branch name '$BRANCH'"
	;;
esac

if [ -n "$REPO" ]; then
	[ -d "$REPO" ] || die "no such directory: $REPO"
	REPO=$(cd "$REPO" && git rev-parse --show-toplevel) || die "not a git repository: $REPO"
else
	REPO=$(git rev-parse --show-toplevel 2>/dev/null) || die "not inside a git repository; pass -C REPO"
fi

WT="$REPO/.claude/worktrees/$BRANCH"
[ -e "$WT" ] && die "worktree path already exists: $WT"

if git -C "$REPO" show-ref --verify --quiet "refs/heads/$BRANCH"; then
	printf '%s: branch %s already exists, checking it out\n' "$PROG" "$BRANCH"
	git -C "$REPO" worktree add "$WT" "$BRANCH"
else
	if [ -z "$BASE" ]; then
		BASE=$(git -C "$REPO" symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null | sed 's|^refs/remotes/||') || true
		[ -n "$BASE" ] || BASE=HEAD
	fi
	case $BASE in
	origin/*) git -C "$REPO" fetch --quiet origin "${BASE#origin/}" || printf '%s: fetch failed, using the local copy of %s\n' "$PROG" "$BASE" >&2 ;;
	esac
	git -C "$REPO" worktree add -b "$BRANCH" "$WT" "$BASE"
fi

links=$DEFAULT_LINKS
extra="$REPO/.claude/worktree-link"
if [ -f "$extra" ]; then
	links="$links
$(sed -e 's/#.*//' -e 's/[[:space:]]*$//' "$extra" | grep -v '^$' || true)"
fi

excludes=$(git -C "$REPO" rev-parse --git-path info/exclude)
mkdir -p "$(dirname "$excludes")"
[ -f "$excludes" ] || : >"$excludes"

linked=
excluded=
while IFS= read -r rel; do
	[ -n "$rel" ] || continue
	src="$REPO/$rel"
	dst="$WT/$rel"
	[ -e "$src" ] || continue
	[ -e "$dst" ] && continue
	case "$WT/" in
	"$src"/*)
		printf '%s: skipping %s, the worktree lives inside it\n' "$PROG" "$rel" >&2
		continue
		;;
	esac
	mkdir -p "$(dirname "$dst")"
	ln -s "$src" "$dst"
	linked="$linked $rel"

	if [ -d "$src" ] && ! git -C "$WT" check-ignore -q "$rel"; then
		grep -qxF "$EXCLUDE_MARKER" "$excludes" || printf '%s\n' "$EXCLUDE_MARKER" >>"$excludes"
		printf '%s\n' "$rel" >>"$excludes"
		excluded="$excluded $rel"
	fi
done <<EOF
$links
EOF

[ -n "$linked" ] && printf '%s: linked%s\n' "$PROG" "$linked"
[ -n "$excluded" ] && printf '%s: added%s to %s\n' "$PROG" "$excluded" "$excludes"

if [ "$OPEN" -eq 0 ]; then
	printf '%s\n' "$WT"
	exit 0
fi

editor=${WORKTREE_EDITOR:-zed -n}
editor_bin=${editor%% *}
if command -v "$editor_bin" >/dev/null 2>&1; then
	# shellcheck disable=SC2086
	exec $editor "$WT"
else
	printf '%s: %s not found, set WORKTREE_EDITOR to override\n' "$PROG" "$editor_bin" >&2
	printf '%s\n' "$WT"
fi
