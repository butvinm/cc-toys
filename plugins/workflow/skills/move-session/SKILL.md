---
name: move-session
description: Move, copy, or symlink Claude Code session data between project directories in ~/.claude/projects. Invoke when the user wants sessions from one project available in another - after moving a repo, for worktrees, or in multirepo setups.
user_invocable: true
---

# Move session

Claude Code keeps each project's sessions in ~/.claude/projects/<encoded-path>/, where the encoded name is the project's absolute path with every `/` and `.` replaced by `-`. When a repo moves or a worktree gets its own path, its history is stranded in the old directory. This skill relocates or shares it.

1. Identify the source and target project paths (absolute). Compute each encoded directory name, then verify against reality: `ls ~/.claude/projects/` and confirm the source directory actually exists. If the computed name is not there, find the real one by matching the path components - never operate on a guessed name.
2. Pick the mode with the user if the request does not make it obvious:
   - **move** - the repo was relocated; history should follow. Default for a one-way move.
   - **copy** - both projects need independent copies of the sessions.
   - **symlink** - worktree or multirepo case: link the target name to the source directory so both paths share one live session store; sessions started under either path land in the same place. Limitation: the resume picker's default view still hides sessions recorded under the other path (see step 4) - the user needs Ctrl+A (show all projects) to reach them.
3. Safety checks before touching anything:
   - No Claude Code session may be running in either project - ask the user to close them first.
   - move into an existing target: move contents file by file and stop on any name collision instead of overwriting.
   - symlink: the target name must not exist (remove it first only if it is an empty directory).
   - single-session transfer: move or copy only the files whose names start with that session's id.
4. After a move or copy, rewrite the recorded working directory inside each transferred .jsonl - the resume picker filters sessions by the `cwd` field recorded in the file, not by which project directory the file sits in, so without this step the sessions stay invisible in the picker:
   `sed -i 's|"cwd":"<old-project-path>"|"cwd":"<new-project-path>"|g' <target-dir>/*.jsonl`
   Match the full `"cwd":"..."` field as shown, never the bare path - message content may legitimately mention the old path and must stay untouched. Skip this for symlink mode: both paths stay live and each session correctly records the path it ran under.
5. Note that the project directory also holds per-project state beyond sessions (e.g. memory/); whole-directory modes carry all of it, which is usually what you want - mention it in the report.
6. Verify with `ls -l` on the result and report exactly what was moved, copied, or linked, source and destination. For move/copy, also confirm no old-path `"cwd"` fields remain: `grep -c '"cwd":"<old-project-path>"' <target-dir>/*.jsonl` should report 0.
