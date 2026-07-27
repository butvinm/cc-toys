# cc-toys

Collection of the Claude Code tools I use every day.

## Install

Add the marketplace once:

```
/plugin marketplace add butvinm/cc-toys
```

Then install the plugins you want:

```
/plugin install user-story@cc-toys
/plugin install workflow@cc-toys
```

### Updating

- `/plugin` -> Marketplaces -> **Update marketplace** pulls the latest catalog from this repo immediately - the reliable path.
- `/plugin` -> Installed -> **Update now** uses a local cache that can lag behind; use it as a fallback after updating the marketplace.
- `/plugin` -> Marketplaces -> **Enable auto-update** refreshes the catalog on each session start.

## user-story (plugin)

Helps you see your repo, docs, API, or UI from your users' perspective.

### user-story (skill)

Invents personas - a rushed newcomer, a skeptical senior, a gatekeeper deciding your fate - has them explore the real thing, and narrates their experience as present-tense stories, surfacing the friction a plain AI review slips past.

Invoke with `/user-story:user-story <target>` or prompts like "How does this README read to a newcomer?" and "Review these docs as a time-pressed senior engineer".

<details>
<summary>Example output: a real user-story run</summary>

_Real output of a run against [cc-grammar-coach](https://github.com/butvinm/cc-grammar-coach) (July 2026), grounding pass included, verbatim. One story of the three the run produced._

> Tomoko, junior frontend developer in Osaka, lunch break at her desk. Her goal is simple: get the same red-and-green corrections her senpai's statusline showed yesterday, and know by the end of onigiri whether she can set it up herself this week. She opens the link he sent, github.com/butvinm/cc-grammar-coach, and starts at the README.
>
> The first line is kind to her: "An English grammar coach for Claude Code, in two parts". Two parts, a list — good. But inside the first bullet she hits "reviews every English message you send, out of band" — _out of band?_ She reads the sentence twice, decides it means "in the background", and moves on. The first screenshot, docs/img/statusline.png, stops her cold: a prompt reading "yesterday I fix bug in login flow, now all tests passes", and below, line by line, `fix → fixed (rule: past tense needed)`, `bug → a bug (rule: singular count noun needs article)`. "Uwa, that's my English," she thinks. Articles and past tense — her exact mistakes. This is exactly what senpai's terminal did.
>
> The quiz screenshots are even friendlier: a green "Nice!" card explaining why "I need advice" takes no article, a red "Not quite" card about "discuss about". The red one explains using "'govorit o'" — Russian? Then she spots `native_language` in the table below: "explain English by contrast with your first language". So hers would say Japanese things. She wants this.
>
> Then "Requirements". Three bullets, and the second one is a wall: "An OpenAI-compatible chat-completions endpoint for the grammar model." She reads it three times. She knows what an API key is — she used one for a weather app — but _endpoint for the grammar model_? Does her Claude subscription count as one? The plugin is FOR Claude Code, so... maybe it uses Claude automatically? The Install section almost convinces her it's fine: two commands in a code block, `/plugin marketplace add butvinm/cc-grammar-coach`, `/plugin install cc-grammar-coach@cc-grammar-coach`. She can paste those. Easy.
>
> But the Configuration table pulls the wall back up. `llm_base_url`: "OpenAI-compatible endpoint base URL including the version segment, e.g. `https://your-host/v1`; required, the checker is inactive without it." _Your-host._ Which host? The example is a placeholder pointing at nothing. `llm_model` defaults to `openai/gpt-oss-120b` — so it IS OpenAI? Do I make an OpenAI account and pay? `llm_api_key` is "Bearer key for the endpoint" — she doesn't know what Bearer means, only that she doesn't have one. She scans "How it works" hoping for an answer; it says the hook "sends each English message to the configured model in the background" — configured _where from_, it never says. She clicks docs/statusline.md — of the two linked docs, the only one that sounds like it could touch her problem — it's all about wiring scripts and `render_grammar` and a bash snippet; nothing about where the model comes from. She closes the tab.
>
> She sits back. The install itself — two paste commands, one configure command — she is sure she can do alone; the README is honest about the steps. The thing she cannot do is _have_ the thing it needs, and nowhere in the repo does anyone say where people get it. "Shikata nai." She bookmarks the page and types into her notes app: "Senpai — cc-grammar-coach, what do you put in llm_base_url? Did you pay OpenAI, or does our Claude work?" Lunch is over. The plugin waits on one question the README never answers.

</details>

## workflow (plugin)

Small helpers for the Claude Code workflow itself, such as session management and skill-activation reminders.

### move-session (skill)

Moves, copies, or symlinks Claude Code sessions between project directories in `~/.claude/projects` - for worktrees, relocated repos, and multirepo setups.

Invoke with `/workflow:move-session` or prompts like "Move my sessions from the old repo path" and "Share sessions between this worktree and the main checkout".

### skill-reminder (hook)

Makes skill activation reliable: Claude often knows a relevant skill exists and still answers without invoking it, so this hook reminds it before every prompt to actually activate what applies.

Runs on UserPromptSubmit; needs `jq`.

## License

MIT
