---
name: improve
description: Diagnose a Claude Code mistake or a request you keep repeating, and propose a concrete harness fix - a CLAUDE.md rule, a task-scoped skill edit, a hook, or a fix to the offending plugin/skill itself - then delegate the approved fix to a subagent. Invoke right after a mistake or repeated ask ("fix the workflow for that", "add a rule for this", "that's the second time"), or pointed at a past incident you describe.
allowed-tools: Read, Grep, Glob, Bash, Agent, AskUserQuestion
user_invocable: true
---

# Improve

Turn a Claude Code mistake, or a request you find yourself repeating, into a fix for the harness that produced it - not a one-off correction, a change to the rule, hook, skill, or plugin that keeps the same friction from happening again.

This skill never edits a file itself. It diagnoses, proposes, and on approval hands the edit to a subagent - see [5. Implement only through a subagent](#5-implement-only-through-a-subagent).

## 1. Pin down the friction

- **Same conversation**: find the actual offending turn(s) in the recent transcript - the exact assistant message, tool call, or generated text that caused it. Quote it precisely; don't paraphrase from memory.
- **Pointed at a past incident**: work from the user's description alone, no transcript needed.
- **A repeated request**: name what makes it recurring - the same instruction reworded, or a clear match to something asked earlier in this session or a past one.

## 2. Classify the remediation

Four destinations, in the order to consider them:

- **Soft, always-relevant** -> a CLAUDE.md rule. A personal habit that follows the user across repos goes to user-level `~/.claude/CLAUDE.md`; a convention specific to this codebase goes to the project's own CLAUDE.md, matching whatever placement convention that repo already documents (check for one before defaulting).
- **Soft, task-scoped** -> an edit inside an existing skill's own instructions, when the knowledge only matters while performing one specific kind of task, not on every turn. If no skill owns that task yet, say so instead of inventing a rule that will never get read outside that task.
- **Hard, mechanical** -> a hook. Pick the event that matches when the check needs to run (`UserPromptSubmit` to reshape or validate before acting, `PostToolUse` to catch something after a tool ran, etc.), and if the fix lands inside a plugin repo, match the `hooks.json` pattern already used there.
- **Existing harness bug** -> something already shipped mis-fired. Locate the actual file at fault - check the current repo's `.claude/` first, then installed plugin sources under `~/.claude/plugins/cache/<marketplace>/<plugin>/`. Read enough of it to name the specific line or logic responsible before proposing anything.

If two destinations plausibly apply, ask one multiple-choice question before proceeding. Don't guess silently.

## 3. Locate the target repo

- Fix is local to the project in front of you (its CLAUDE.md, its hooks) -> the target is the current working directory.
- Fix belongs to a plugin or skill shipped from elsewhere, and the current session isn't sitting in its source repo -> ask the user for that repo's local path before going further. Never guess or search the filesystem for it.

## 4. Propose a recommendation, not a question

State which surface to change, why that surface over the alternatives considered, and the concrete text or diff. End with a stated recommendation and a yes/no gate to implement - never "what do you think?"

## 5. Implement only through a subagent

- Never edit files in this session, regardless of how small the change looks.
- Ask explicitly: "spawn a subagent to make this edit?"
- On yes, launch a fresh subagent (not a context-inheriting fork - the diagnosis is already done, so the task is fully self-contained) with: the target repo's absolute path, the exact file, the exact change, and the one-line reason.
- Tell the subagent to smoke-test any hook script it touches (run it with representative input) before reporting done. A prose-only edit (CLAUDE.md, skill text) needs no test.
- Relay the subagent's own report back in a short summary - don't re-describe a file that wasn't read directly.
- If the answer is no, the proposal from step 4 is the final output. Nothing else happens.

## Worked examples

- Claude keeps emitting file references like `:11` or a bare basename instead of a clickable path -> hard/mechanical: a `UserPromptSubmit` or response-shaping hook that validates the reference format.
- The user asks Claude to rewrite a test the same way for the second time -> soft/task-scoped: an edit to whatever skill already owns "writing tests" in this repo, or a note that none exists yet.
- A hook shipped by a plugin (say, `worktree-sync`) missed a file it should have carried -> existing harness bug: find the plugin's source repo, read the hook script, and propose the fix there.
