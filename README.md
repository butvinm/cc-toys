# cc-toys

Collection of the Claude Code tools I use every day.

## Install

Add the marketplace once:

```
/plugin marketplace add butvinm/cc-toys
```

Then install any plugin from it:

```
/plugin install user-story@cc-toys
```

## Plugins

### user-story

Roleplay invented personas exploring your repo, docs, API, or UI and narrate their lived experience as present-tense stories, surfacing the friction a plain AI review slips past. Each persona arrives with a real goal and a real knowledge ceiling, and every complaint is fact-checked against the actual artifact - so you learn where people get confused, what delights them, and where they give up.

Trigger it with prompts like:

- "Walk through this repo as a user story"
- "How does this README read to a newcomer?"
- "Is the onramp any good?"
- "Review these docs from the point of view of a time-pressed senior engineer"

<details>
<summary>Example output: user-story run on this very repo</summary>

_Real output of a run against this repo (2026-07-27), grounding pass included, verbatim except the bold highlights. The sample story both personas go hunting for is this section._

> Yusuf, a backend engineer, Wednesday 7pm, still at the office.
>
> His team's internal service README generates the same three Slack questions from every new joiner, and he is done answering them. A colleague dropped github.com/butvinm/cc-toys in a thread this afternoon — "this thing reviews your docs through fake users' eyes." He gives it five minutes: worth running on his README tomorrow morning, yes or no. He clicks the link and lands on the repo root.
>
> Small tree: `.claude-plugin`, `plugins`, LICENSE, README.md — four entries. First line of the README: "Collection of the Claude Code tools I use every day." The repo is named _toys_ and his problem is not a toy — a flicker of the usual suspicion, the kind he's earned from AI repos that promise magic and ship a prompt. He scrolls.
>
> "## Install" is the second heading and it's already the thing he came for: two fenced lines, `/plugin marketplace add butvinm/cc-toys`, then `/plugin install user-story@cc-toys`. He lives in slash commands, so the shape reads instantly — but he's never touched `/plugin`, and "marketplace" makes him stop for half a beat. "Add a marketplace… is that a curated Anthropic thing, or am I wiring some stranger's GitHub repo straight into my Claude Code?" **The README doesn't say, and the `.claude-plugin` folder up in the tree is just a name to him.** Two lines, though. He can paste two lines. He keeps scrolling.
>
> "### user-story." One dense paragraph — his eyes want to bounce off it, but the right phrases snag on the way down: "invents 1-3 believable people with concrete goals," "fact-checks every complaint against the actual artifact," and then "where they got confused, what delighted them, where they gave up." That last one is literally his Slack problem — new joiners get confused in the same three places and he wants to know _why_ before they ask. The trigger prompts underneath seal it: "How does this README read to a newcomer?" is, word for word, the question he'd type. "Okay. That's aimed at me."
>
> **But the paragraph _describes_ stories and shows him none.** "Present-tense stories of their lived experience" — fine, show me one. He's been burned by exactly this gap before: great pitch, and under the hood a 40-line prompt that hallucinates complaints about files that don't exist. Before this touches his Claude Code, he wants to see the output. So he digs: `plugins/` → `user-story/` → two folders, `.claude-plugin` and `skills`, no prose → `skills/user-story/` → SKILL.md. **Four clicks, every folder repeating the same name, at 7pm.** "This better be good."
>
> SKILL.md opens and his suspicion half-confirms itself: it _is_ a prompt — 160-odd lines of instructions. But right under "## The reference" sits a full worked story: Dana, a backend engineer, 11pm, fighting Mermaid — she googles her pain, hits an unexplained folder, hunts for a screenshot that isn't there, and leaves with "the idea sold her; the onramp lost her." Yusuf reads the whole blockquote and feels the click. "If it writes _that_ about our README — 'four clicks and a guess' — I know exactly which paragraph to fix before the next joiner starts." He skims a little further and catches "The grounding pass," a whole section about fact-checking each complaint against the real files. That's the part that separates this from the prompt-in-a-trenchcoat repos: it at least knows AI reviewers make things up, and built a step against it. He doesn't care how the machinery works beyond that — it promised his outcome and showed a specimen.
>
> Seven minutes, not five. He pastes both install commands into a Slack DM to himself, adds one line — "tomorrow AM: /plugin these, then 'walk through our service README as a new joiner'" — and closes the tab. **The install was two lines from the start; it was the proof he had to go four clicks deep to find.**

> Ingrid, a staff platform engineer, Monday morning, second coffee, working the plugin-allowlist queue.
>
> Request #3 in the channel: a product team wants github.com/butvinm/cc-toys allowlisted for company-wide Claude Code. After a year of vetting "awesome-claude-code" grab-bags — forty untested commands, rocket emoji, a marketplace.json that doesn't parse — her default is reject, and she opens the link expecting to earn it by the second sip.
>
> The landing page is four entries: `.claude-plugin/`, `plugins/`, `LICENSE`, `README.md`. All four she'd expect, and nothing on the tree gives her a strike before she's read a word of prose — which alone puts it ahead of most of her queue.
>
> Manifests before prose, always. `.claude-plugin/marketplace.json`: name `cc-toys` matches the repo, owner is a real human name, one plugin entry, `"source": "./plugins/user-story"` — she checks — the directory exists. Then `plugins/user-story/.claude-plugin/plugin.json`: name matches its directory, `"license": "MIT"` matches the LICENSE file (same author name in the copyright line), homepage and repository both point back here. And **the description string in plugin.json is character-for-character the description string in marketplace.json** — the same sentence, not a paraphrase two releases from drifting apart. "Fine. Better than fine." She's rejected repos where those two strings described different products.
>
> One field she circles: plugin.json says `"version": "1.1.0"`. Commits tab: **eight commits, zero tags, no changelog.** A minor version implies a 1.0.0 existed and something was added since, and nothing in the repo anchors either state. "Semver theater." First strike — soft, but she wants it acknowledged. The commit messages themselves she grudgingly likes: "Replace generic marketing copy with plain descriptions," "Trim descriptions to non-drifting one-liners," "Drop packaging claim from README opener." A history of sanding marketing _out_ of a README is the inverse of every grab-bag she's bounced.
>
> The payload: `plugins/user-story/skills/user-story/` holds exactly one file, SKILL.md. No hooks, no scripts, no MCP servers, no commands directory — the entire installable surface is one prose skill and a manifest. For an allowlist review that's the whole ballgame, and she notes it before anything else. She reads all 161 lines against the README's blurb: "invents 1-3 believable people" — Workflow step 4, verbatim range. "Explore the real thing in parallel" — step 5, one subagent per persona. "Fact-checks every complaint against the actual artifact" — an entire section, "The grounding pass," with TRUE/MISATTRIBUTED/FALSE verdicts per charged claim. **Every capability the README sells has a section that ships it.** She keeps hunting for the vaporware clause and doesn't find one, which irritates her on principle. The frontmatter description differs from the manifest string — longer, trigger-phrased, "Invoke for 'user story'…" — and she waves it through: skill descriptions are routing text, they're _supposed_ to differ. Then, under "Two extremes worth keeping in your back pocket," she hits: "the staff engineer vetting the repo for a company allowlist." She rereads it. Not a mandate — a casting call: bring in the domain expert, it says, when a gatekeeper decides the repo's fate, and the example it reaches for is her job description. "…Fair."
>
> Back to the README for the prose pass. Line one: "Collection of the Claude Code tools I use every day." She snorts — plural noun, singular inventory, one plugin under "## Plugins" — though "I use every day" is at least a claim an author can personally back. Smaller grumble: a repo named _toys_ describing _tools_; toys you excuse, tools you allowlist. The install section is two correct commands in correct `plugin@marketplace` form and nothing else — no curl-pipe-bash, no clone-and-symlink escape hatch. The blurb describes "present-tense stories" and shows none on the page; for her decision it's cosmetic, but she'd have led with a sample.
>
> She posts in the channel: "Allowlisted. One plugin, prose-only skill — no hooks, no scripts, zero executable surface — manifests internally consistent, every README claim resolves to a shipped section. Ask the author to tag releases so that version number means something." She closes the tab and opens request #4, mildly annoyed that the repo she couldn't reject is the one that ships a description of her.

</details>

## License

MIT
