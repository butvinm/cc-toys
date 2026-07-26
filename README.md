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

Evaluates an artifact - a repo, API, UI, docs site, code module, onboarding flow - through the eyes of invented personas. Instead of a checklist audit, it invents 1-3 believable people with concrete goals and knowledge ceilings, has each explore the real thing in parallel, fact-checks every complaint against the actual artifact, and returns present-tense stories of their lived experience: where they got confused, what delighted them, where they gave up.

Trigger it with prompts like:

- "Walk through this repo as a user story"
- "How does this README read to a newcomer?"
- "Is the onramp any good?"
- "Review these docs from the point of view of a time-pressed senior engineer"

<details>
<summary>Example output: user-story run on this very repo</summary>

_Real output of a run against this repo at commit `cbc50ce`, grounding pass included, verbatim except the bold highlights. The missing example Marta complains about below is this section._

> Marta, a frontend developer, Friday afternoon, twenty minutes before her last meeting.
>
> Her team's onboarding docs keep losing new hires in the same three places, and a colleague just dropped github.com/butvinm/cc-toys in Slack: "this user-story thing reviews your docs through fake users' eyes, looked neat." She has five minutes to decide whether it's real, and if so, to grab the install commands. She clicks.
>
> The landing page is small: `.claude-plugin`, `plugins`, LICENSE, README.md — four entries, then the README rendered below. First line: "Collection of the Claude Code tools I use every day." A flicker of doubt — the repo is called cc-toys, the Slack pitch was about one specific thing, and "toys" is not a word that sells a tool to her team lead. She scrolls past it.
>
> "## Install" is the second heading, and it's exactly what she hunts for: two fenced blocks, `/plugin marketplace add butvinm/cc-toys` then `/plugin install user-story@cc-toys`. She runs slash commands all day, so the shape is instantly familiar — but she's never touched `/plugin` before, and "marketplace" makes her pause half a beat: "add a marketplace… is that an official Claude thing, or am I wiring some guy's repo into my Claude Code?" **The README doesn't say what the command does; the `.claude-plugin` folder up in the tree means nothing to her either.** Still — two copyable lines, "add the marketplace once," then install. Low enough risk. She keeps them in view.
>
> "### user-story." The description paragraph is dense but the right phrases snag: "invents 1-3 believable people with concrete goals and knowledge ceilings," "fact-checks every complaint against the actual artifact," "where they got confused, what delighted them, where they gave up." That last clause is literally her problem statement. Then the trigger prompts — "How does this README read to a newcomer?" and "Review these docs from the point of view of a time-pressed senior engineer." She mentally rewrites the second one as "review our onboarding docs from the point of view of a new frontend hire" and it fits without forcing. "Okay. This is the thing."
>
> But she still hasn't seen one. **The README describes the output — "present-tense stories of their lived experience" — and shows zero of it. No sample story, no screenshot, no link.** Before she pastes commands into her Claude Code, she wants to see what a "story" actually looks like. She goes digging: `plugins/` → `user-story/` → just two folders, `.claude-plugin` and `skills`, no prose → `skills/user-story/` → SKILL.md. **Four clicks into nested folders that all repeat the same name.** GitHub renders it, and under "## The reference" there it is: Dana, a backend engineer, 11pm, fighting Mermaid — a full worked story, ending "The idea sold her; the onramp lost her." Marta reads the whole blockquote. "Oh. If it writes _that_ about our onboarding doc, I know exactly what to fix." That one quote closes the sale — and it's buried four clicks deep where the colleague's Slack pitch had to do the selling instead.
>
> Six minutes gone, meeting looming. She copies both install commands into her notes, DMs the colleague "trying it on our onboarding docs Monday," and closes the tab. **Decision made — but it was Dana who made it, not the README that hides her.**

> Grigory, a staff engineer, Tuesday morning, first coffee, third tab. Someone on his team dropped github.com/butvinm/cc-toys into the plugins channel with "can we allowlist this?" — and Grigory has vetted enough "awesome-claude-code" grab-bags to know how this usually goes: forty half-tested commands, a README full of rocket emoji, and a marketplace.json that doesn't parse. He opens the repo expecting to reject it by the second sip.
>
> The landing page throws him off script immediately. Four entries. README.md, LICENSE, .claude-plugin/, plugins/user-story/. That's it. No `scripts/`, no `assets/logo.png`, no CONTRIBUTING.md for a repo with one author. "Huh. Either abandoned or disciplined." He reads the README — all thirty-four lines of it. "Collection of the Claude Code tools I use every day." He scrolls to the Plugins section: one plugin. A collection of one. He snorts — "plural noun, singular inventory" — and files it, though he concedes the framing "I use every day" is at least a claim the author can personally back, unlike "supercharge your workflow." Second grumble, smaller: **the repo is named _toys_ and the description says _tools_. Toys you excuse; tools you allowlist. Pick one.**
>
> The install section: `/plugin marketplace add butvinm/cc-toys`, then `/plugin install user-story@cc-toys`. Correct shorthand, correct `plugin@marketplace` form, nothing else — no curl-pipe-bash, no "or clone and symlink" escape hatch that rots in six months. Fine.
>
> Now the part he actually came for. He opens `.claude-plugin/marketplace.json`: name matches the repo, owner is a real name, one plugin entry, `"source": "./plugins/user-story"` — he checks the tree — the directory exists. Then `plugins/user-story/.claude-plugin/plugin.json`: name matches the directory, `license: "MIT"` matches the LICENSE file, homepage and repository both point back at this repo. And then he notices the thing he'll steal: the description string in plugin.json is _character-for-character identical_ to the one in marketplace.json. Not a paraphrase that will drift apart by release three — the same sentence. He's spent actual meetings arguing about exactly this in his own marketplace. **"One string, two files, zero drift. Somebody thought about it."**
>
> The README's plugin blurb says "invents 1-3 believable people," "explores in parallel," "fact-checks every complaint against the actual artifact." He's been burned by exactly this kind of sentence before, so he opens the full SKILL.md — 167 lines — and reads it, all of it, against each claim. "1–3 personas": line for line in the workflow, step 4. Parallel exploration: step 5, one subagent per persona. The fact-checking: an entire section, "The grounding pass," with TRUE/MISATTRIBUTED/FALSE verdicts per claim. **Every capability the README advertises has a section of the skill that ships it.** No "coming soon," no roadmap, no second plugin promised and absent. He keeps hunting for the broken promise and doesn't find one, which is mildly annoying in itself.
>
> Then, mid-file, he hits the section titled "The very smart domain expert (always cast one)": _"He is grumpy, pedantic, and meticulous... every element must justify its own existence."_ Grigory reads a two-paragraph specification of himself, mandated as a feature. He sits with that for a moment. "...Fair."
>
> Commits tab, because he always checks: six commits, and four of them are deletions of prose — "Replace generic marketing copy with plain descriptions," "Trim descriptions to non-drifting one-liners," "Drop packaging claim from README opener," "Remove manual install section." The history is someone iteratively sanding overreach out of their own README. That's the exact opposite failure mode of every grab-bag he's rejected.
>
> One real strike survives his coffee: **plugin.json declares `"version": "1.0.0"`, but the repo has zero tags and no changelog — nothing anchors that number to a state of the code**, and when SKILL.md changes next month, nothing forces the version to move with it. Declared semver with no visible discipline behind it is a promise waiting to quietly break, and for a company allowlist that tracks repo head, he wants that fixed or at least acknowledged.
>
> He replies in the channel: "Allowlisted. One plugin, five files, six commits, zero contradictions — the README's claims all resolve to shipped sections of the skill. Ask him to tag releases." Then he opens his own marketplace repo and starts a branch to make his plugin descriptions match their marketplace entries character-for-character, grumbling that he had to learn that from a repo named _toys_.

</details>

## License

MIT
