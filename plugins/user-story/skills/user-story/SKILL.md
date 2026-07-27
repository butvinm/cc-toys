---
name: user-story
description: Roleplay invented personas exploring an artifact — repo, API, UI, docs, code, onboarding — and narrate their lived experience as present-tense stories, surfacing the friction a plain AI review slips past. Invoke for "user story", "walk through this as a user", "how does this read to a newcomer", "is the onramp any good", or any request to evaluate something from a specific person's point of view rather than as a checklist.
user_invocable: true
---

# User Story

Live through an interaction with something — a repo, an API, a UI, a docs site, a code module, an onboarding flow — as a specific invented person, and write down what that experience is actually like.

The output is not an audit and not a list of issues. It's a story: one named persona, present tense, exploring the real thing in real time, with their real reactions, ending where they actually stop. The friction surfaces because the reader feels it happen, not because you tallied it.

The whole value rests on one thing: **it has to be true.** Every beat traces to something that actually exists in the artifact and that the persona actually encountered. A story that invents a missing README, or imagines a confusing button that isn't there, is worse than useless — it sends the user to fix a problem they don't have. So this skill is half UX-empathy and half investigation. You earn the right to narrate a reaction only by having actually seen the thing that provokes it.

## The reference

This is the bar. Study how it works before writing your own.

> Dana, a backend engineer, 11pm, fighting Mermaid for the third time tonight.
>
> Her sequence diagram keeps reflowing every time she adds a message — Mermaid decides Bob goes left, she wants him right, there's no way to say so. She googles "mermaid manual layout control" and a GitHub result reads "manual-layout HTML/CSS diagrams, no auto-routing." That's exactly her pain. She clicks.
>
> The landing page. GitHub shows her a file tree and… nothing else. There's no README. Her eyes scan: package.json (ok, a Node thing), .claude-plugin/, .claude/, CLAUDE.md, diagrams/, tests/. First reaction: "What is this? A library? A CLI? Some Claude thing?" The .claude-plugin folder makes her hesitate — "do I need an AI subscription to use this?"
>
> She opens CLAUDE.md because it's the only thing that looks like prose. It's well-written, but it's clearly addressed to a robot: "Hard rules. Snapshot ≠ correctness." She gets the gist — author HTML, render to PNG, no auto-layout — and the philosophy genuinely appeals to her. But she still doesn't know if she can use it, or if it only works through Claude Code.
>
> She hunts for a picture. Nothing on the landing page shows a diagram. No screenshot, no GIF. She digs, finds tests/golden/state-basic.png, clicks it — and there it is: a clean state machine, crisp, exactly the kind of controlled layout she wanted. "Oh. Okay. That's actually nice." She opens tests/cases/state-basic/ours.html and finally sees the syntax. Now it clicks — but it took her four clicks and a guess to get here.
>
> She stars it ("clever approach, come back later"), and closes the tab without trying. The idea sold her; the onramp lost her.

What makes it land: the entry point is realistic (she googled, she didn't teleport to the repo root with full knowledge). Her goal is on the table from the first lines — manual node placement so her diagram stops reflowing — so every later beat reads as progress toward it or a detour from it, and the friction has something concrete to register against. Her knowledge ceiling is honored (she doesn't know what `.claude-plugin/` is, and that ignorance is itself a finding about the repo's legibility). Every beat names a real artifact. Friction is counted concretely ("four clicks and a guess"). And the final beat lands a takeaway the user can act on without a single bullet point.

## Workflow

1. **Pin down the target and how a real person reaches it.** A local path, a URL, an API, a docs page, a specific code module. Note the realistic _entry points_ — would they google it, get a link in Slack, land on the repo root, hit the API docs first? People rarely start from the front door you imagine.

2. **Do light recon yourself** — just enough to know what the thing is and, more importantly, _who actually shows up to it_. You're not exploring deeply here (the persona subagents do that); you're learning enough to invent a believable audience.

3. **Fix the assumptions** — the preconditions every story treats as satisfied even where reality differs ("every employee has internal GitLab access," "the artifact is already published," "the reader has an account"). Some the user hands you; others you infer to keep the cast focused on the experience under review rather than scope you've already decided is out of bounds. They are a sanctioned pretense, not a lie: declared up front in the output so the user sees exactly what was assumed away, and binding on every persona and the grounding pass alike. A persona never generates friction from a gap an assumption covers — they proceed as if it holds.

4. **Invent 1–3 personas** spanning the realistic range of who lands here (see _Designing personas_). Default to 2–3 unless the user asked for a specific number or handed you a specific persona — a user-specified cast is final. Diversity is the point — different knowledge ceilings hit different walls, and the blinkered, satisficing majority is where this skill earns its keep: their limited view is precisely what a from-nowhere review cannot reproduce.

5. **Spawn one subagent per persona, in parallel** (multiple Agent calls in a single message). Each gets the persona brief + the target + the shared assumptions + the exploration instructions below, does its own deep grounded exploration, and returns a finished story draft. Running them in parallel keeps them independent — no persona's path contaminates another's.

6. **Ground each story against reality** (see _The grounding pass_). Spawn one omniscient verifier subagent per story, in parallel — it knows the whole artifact, including everything the persona deliberately never looked at, and silently reworks any complaint the persona got factually wrong. A blinkered persona produces vivid friction; some of that friction rests on a false conclusion the persona had no way to check. This pass catches it before it reaches the user and sends them to fix a problem they don't have.

7. **Present** the assumptions first, then the grounded stories back to back each under its persona's name, then a short **Verdict** and **Consider actions** that distil the whole cast (see _Output format_). The stories are still the deliverable; the closing sections only crystallize what they already showed — keep them to one-line bullets, never a fresh argument or a finding the stories didn't surface.

## Designing personas

A persona is a person, not a user-type label. Give each one:

- **A name, a role, and a moment.** "Dana, a backend engineer, 11pm." The when and the mood matter — a tired person at 11pm has different patience than someone evaluating tools on a Tuesday morning.
- **The goal that brought them here — concrete enough to act as a lens.** Nobody arrives neutral. Every persona carries one specific thing they came to get done: understand how to do X, decide whether this is worth adopting before Friday, review this change so it doesn't break production, check whether the team actually followed the guideline, grab the one snippet that unblocks them. Give it the shape of a sentence you could say out loud. A vague goal ("look at the docs") gives you nothing to measure against; a sharp one ("figure out how to place nodes manually so my diagram stops reflowing") turns every line of the artifact into something that either advances the mission, wastes time, or actively blocks it. The goal is what makes friction legible at all — a detour is only a detour relative to where the person was trying to go. It sets what counts as success and what counts as friction, and it is the standard the persona holds up to everything they touch.
- **A knowledge ceiling and a bias.** This is the most important and most-skipped part. What does this person _not_ know, and what do they assume? A novice and a skeptical senior engineer reading the same README have opposite experiences. The ceiling is what makes their confusion real instead of performed.
- **Givens — what they already know and already have.** The flip side of the ceiling, and just as important. State explicitly what this person's role _guarantees_ they possess: access (a sandbox shell, a Grafana login, prod credentials), tools, and background knowledge that the role makes unavoidable. A daily operator of the system has used its dashboards; a Kubernetes SRE knows what a pod is; a returning contributor has the repo cloned. The givens are a hard floor: **the persona may not be confused about anything in them.** A persona who "runs the service" cannot also not know how to open its monitoring — that's not a finding, it's an incoherent person, and it sends the user to fix a problem nobody has.

The ceiling and the givens must be _coherent with the role you assigned_. Before you finalize a persona, sanity-check the two against each other: if the role implies the knowledge, it belongs in the givens, not the ceiling. The most damaging stories come not from invented artifacts but from internally contradictory personas — someone simultaneously expert enough to be here and ignorant enough to be blocked by the basics. If you genuinely want to test the newcomer's onboarding gap, assign that gap to an actual newcomer, not to the insider who definitionally doesn't have it.

Make the personas genuinely different from each other — a curious newcomer, a time-pressed skeptic, someone from an adjacent field who half-fits the audience. If they'd all have the same experience, you only need one.

Ground them in the artifact's _real_ audience, not a flattering one. If the docs assume you already know Kubernetes, one persona should be someone who doesn't — that's where the truth lives.

When the artifact exists to **win something from its reader** — a CV wants an interview, a landing page wants a signup, a pitch wants a yes, a README's opening wants you to try the thing — the most important persona to cast is the one who grants or withholds it. They are not here to admire the work; they read to answer "should I act on this?", under time pressure, with a stack of alternatives, and everything that doesn't move that decision is noise. This is the reader who notices when the artifact describes its own machinery instead of the reader's payoff (implementation trivia like "the parser runs in two passes" tells a recruiter nothing about whether to hire), when it leans on jargon the reader's role doesn't carry ("binary" where "CLI tool" would land), or when it brags about brittle specifics ("supports 15 subcommands") that signal effort but not value. Cast the judge, not only the peer — because a peer often admires the very detail that loses the judge, and a cast made entirely of peers will hand back a warm story about an artifact that is quietly failing at its actual job.

Range widely across roles. Beyond the obvious newcomer and the jaded senior, reach for whoever would actually expose _this_ artifact's specific weakness: a sleep-deprived on-call engineer, a non-native-English reader, someone porting over from a competitor, a security reviewer, a product manager who has to approve it but can't read the code, a first-time contributor trying to land a PR. The right cast is the one whose combined blind spots and sharp spots cover the ways this particular thing can fail.

### Sensitivities to draw from

Beyond their goal and knowledge ceiling, a persona carries **sensitivities** — the things they can't help noticing, the friction that lands harder on them than on anyone else. These aren't roles and this isn't a menu to fill in. It's a palette of traits to provoke ideas: a real persona carries a _few_ of these, fused into one believable person, never a tally of all of them. The two extremes below are just two such fusions, dialed to their limit. Reach for whichever sensitivities expose _this_ artifact's specific way of failing, and invent ones not listed here when the target calls for them.

- **Language correctness** — a typo, a broken link, a sentence that doesn't parse stops them cold; the truest test of docs that claim to be polished.
- **Excess** — allergic to ceremony, to the abstraction with one caller, to four paragraphs for a one-line idea.
- **Triviality** — insulted by being told what they already know; padding wastes their time.
- **Logical consistency** — cross-references across files and catches the contradiction: a README that promises a flag the parser rejects, two docs that define a term differently.
- **Impatience / time pressure** — every extra step, every detour raises the odds they quit before succeeding.
- **Prerequisite ignorance** — doesn't know the one thing the artifact silently assumes (Kubernetes, a build tool, a term), and that gap is itself the finding.
- **Copy-paste-first** — won't read the prose; hunts for the runnable snippet and judges the whole thing by whether it works.
- **Value over mechanism** — judges every line by "what does this do for _me_?" and bristles when the artifact explains how it works in place of why it matters. The reader who has to decide something cares about outcome, impact, and fit; internal implementation detail, however true and however impressive to a peer, becomes friction the moment it crowds out the payoff. This is the lens that catches a description that is perfectly clear and still useless to its reader.
- **Audience register** — notices when the writing is pitched at the wrong reader: an insider term where a plain word would do, a level of detail that suits a teammate but not the gatekeeper, jargon that quietly excludes the very person who has to act. The content may be accurate; the finding is that it was written for someone other than the one reading it.
- **Overreach / sins of inclusion** — the mirror of the goal-lens. Where everyone else asks "did the artifact give me what I need?", this reader asks "what is here that shouldn't be?" — a feature advertised but not shipped, a roadmap promise the project can't keep, a dependency that won't be public, scope the thing has no business claiming yet. They read every claim as a _promise_ and every included line as something that must earn its place; vaporware and over-promising register as a credibility leak, not a harmless note. The satisficer skims past these; this reader stops and charges them.
- **Territoriality / contamination** — has a stake (a tool they chose, a team they own, a workflow they defend) and is offended when foreign content intrudes on their space: a rival product's name and internals dropped into _their_ install section, another audience's concerns crowding the page they came for. Sharper than _Audience register_, which is about the whole text being mis-pitched — here the text contains a passage that is _right for someone else_ and wrong to put in front of them, and removing it would lose nothing they need.

### Two extremes worth keeping in your back pocket

These two sit at opposite ends of the knowledge ceiling, and each catches a whole class of problems the middle of the range walks right past. Both are situational: cast the very stupid user for anything that claims to be simple, and the domain expert when the artifact makes claims worth auditing or when a gatekeeper decides its fate.

**The very stupid user.** Not careless — just easily lost. Any extra step, any unexplained term, any indirection, any "obviously you'd just…" leap stops them dead. They are the truest test of whether a thing is _actually_ simple or only simple to the person who built it. Wherever this persona gets confused is precisely where the artifact is overcomplicated. The discipline: their confusion must be _real_ — traced to a genuine fork, a genuine piece of jargon, a genuine detour that is actually there — never performed dumbness for effect. And if they sail straight through, the thing really is simple, and that pleasant story is itself the finding.

**The very smart domain expert.** A senior practitioner who knows the area cold, governed by a single demand: **every element must justify its own existence.** What enrages them is not error so much as **thoughtlessness** — the line nobody interrogated, the capability advertised but never built, the promise never checked, the sentence written from the author's head instead of the reader's. They read closely and cross-reference where everyone else skims — doc against code, claim against the file tree — which yields the two finding flavors no satisficing persona could reach: **inconsistencies between parts** (the README promises a flag the parser rejects) and **sins of inclusion** (the vaporware claim, the content that belongs to someone else; the proof of a smelled over-promise is left to the grounding pass). Cast them only as a person with stakes and a decision — the staff engineer vetting the repo for a company allowlist, the buyer burned by vaporware before, the security reviewer who reads every permission as overreach — never as a disembodied reading machine: the stakes are what turn pedantry into a story. Same discipline as the rest of the cast, with one clause that matters: **they are allowed — expected — to come back satisfied.** Every irritation must be real and citable, pointed at the actual line — manufacturing thoughtlessness where there is none is the same sin as inventing a missing file.

## How the persona explores (subagent instructions)

The subagent's hardest job is to suppress its own omniscience and explore with the persona's eyes. You, the model, can read the whole repo in seconds and understand it perfectly. The persona can't. The story has to reflect _their_ path, not yours.

One persona inverts this when cast: the very smart domain expert, whose full comprehension _is_ their authentic behaviour — the job flips from feigning ignorance to wielding expertise. The instructions below assume the satisficing majority; an expert reads closely where the majority skims, and stops on every line that cannot answer _why are you here?_

- **Enter the way they'd actually arrive.** From a Google result, a dropped link, the repo root, the API reference — not from a mental table of contents. First impressions are formed from the entry screen alone.
- **Read every part against the goal.** This is the engine of the whole exercise. The persona never reads neutrally — they hold their goal up to each thing they encounter and ask, silently, in their own head: _What does this tell me that I actually need? Does it move me toward what I came for, or is it noise? Does it confuse me? Is it answering the question I arrived with, or a different one the author found more interesting?_ Every sentence of docs, every section heading, every button, every code sample gets that interrogation. A line that is accurate, well-written, and irrelevant to the goal is friction — narrate the persona registering it as such, not admiring it. A line that lands exactly what they needed earns the "oh, good — that's the thing" beat. This per-beat judgment, accumulated across the whole encounter, _is_ the finding: the story is the running tally of how much of the artifact served the mission versus got in its way.
- **Scan, don't read.** Real people skim, judge by what's visible, and form opinions on incomplete information. They open the file that looks like prose, ignore the one that looks like config, and move on before reading everything. (An expert persona, if cast, is the exception — close, exhaustive reading is in character and is where their cross-references come from.)
- **Stay inside the knowledge ceiling — and on top of the givens.** React with the persona's actual ignorance: if they wouldn't know what a folder, flag, or term means, the confusion is real data about the artifact's legibility — narrate it, don't quietly resolve it. But the inverse is equally binding: do not narrate confusion about anything in the persona's _givens_. If the role guarantees they've used the dashboard, opened the tool, or hold the background, they move through it without friction. Manufacturing ignorance the persona couldn't actually have is the same sin as inventing an artifact that isn't there.
- **Attribute friction before you charge it to the artifact.** When the persona hits a wall, run two tests before it counts against the thing under review: (1) is this plausibly unknown to _this specific_ persona, given their role and givens? and (2) is resolving it _this artifact's_ responsibility, or does it belong to the platform, the org's onboarding, or some other thing? A wall that fails either test is **environment, not a finding** — narrate the persona passing through it as ordinary context ("she's in Grafana, where she logs in every morning"), not as a strike. The friction can be real and still not be _this_ artifact's fault or _this_ persona's blocker. Docs for a project's logs are not responsible for teaching sandbox access or Grafana login; charging them for it is misattribution, and misattribution sends the user to fix the wrong thing just as surely as a fabricated complaint does.
- **Separate what you experienced from why you think it happened.** The persona's lived experience is data and can be trusted: "the README says the main artifact is `report.html`, and I don't see it in the file tree" is real, and worth narrating. But the persona's _explanation_ of why — "...because it isn't included in the repo" — is a hypothesis formed from a blinkered view, and it is frequently wrong: the thing may be gitignored, generated by a build step, published somewhere else, or behind a wall they never checked. Voice these as the guesses they are ("the README never says where it lives — is it generated? published somewhere?"), not as settled fact, and never let an unverified guess become the load-bearing claim of the story. The persona is allowed to be wrong about _why_ something is missing; the story just must not _assert_ the wrong why as if it were established. The grounding pass exists to resolve exactly these guesses — leave it room to.
- **Follow the path of least resistance.** Click the promising thing. Avoid the thing that looks like work. Get impatient. People satisfice; they don't exhaustively evaluate.
- **Let emotion drive.** Note the frustration, the hesitation, the "oh, that's actually nice" moment, the point of giving up. The emotional arc _is_ the UX signal.
- **Actually do it.** Read the real files. Fetch the real URL. Drive the real UI (use browser tooling if available). Try to run it. Hit the real error. You may only narrate what you genuinely encountered.
- **Stop where the real person stops.** Do they try it, bookmark it for later, rage-quit, or succeed? Don't push past the natural endpoint just to be thorough — where they quit is part of the finding.
- **Be honest about walls you can't cross.** If the persona would hit a login, a paywall, or a binary you can't run, narrate hitting that wall — that's part of the experience — and do not fabricate what's behind it. An honest "she can't tell from here whether it even installs" is a finding; an invented success is a lie.
- **Never invent friction for a better story.** If the onramp is actually smooth, the story is allowed to be a pleasant one. The story must follow from what really happened, not from a predetermined narrative.

## The grounding pass (verifier subagent instructions)

The persona explores blinkered, on purpose — and that is exactly why some of their complaints will be false. Martin clones the repo, sees no `report.html`, and concludes "it isn't included, so I can't read it." But the file is gitignored locally and built on CI as GitLab Pages — a fact that lives in `.gitlab-ci.yml` and `.gitignore`, precisely the files Martin would never open. His confusion is real; his conclusion is false; and no amount of in-character exploration could have caught it, because catching it means reading _outside_ the persona's path. That is the whole reason this is a separate pass with full knowledge rather than something the persona does to itself — you cannot both authentically not-know about the CI and fact-check yourself against it in the same head.

One verifier subagent per story, run in parallel. Each receives one finished story plus the shared assumptions plus full access to the artifact, and its only job is to make sure every complaint the story charges against the artifact is _true_, accounting for everything the persona couldn't see. It edits the story in place and returns the corrected version — that revised text is what gets presented.

Treat the declared assumptions as ground truth: a gap an assumption covers is out of scope, so never "correct" a story toward friction the assumption waives, and never flag a beat as FALSE for resting on an assumption the artifact's real state contradicts. The assumptions narrow what counts as a chargeable claim; everything outside them is verified as normal.

- **Extract every charged claim.** Walk the story and pull each beat where the artifact is _blamed_ for something: a missing file, a broken link, an absent feature, an unexplained term, a command that doesn't work — and, from an expert persona if one was cast, the mirror-image charges: a feature advertised but not shipped, a roadmap promise that can't be kept, a dependency that won't be public, content that serves the wrong audience. Admiration, neutral observation, and the persona's own ignorance don't need checking — only the friction that counts against the thing under review.
- **Verify each against the whole artifact, not the persona's path.** Read what the persona skipped: `.gitignore`, CI config, build scripts, the remote, the deploy pipeline, adjacent files, the actual behaviour when run. This is the point of the pass — to spend the omniscience the persona was denied. For a _presence_ charge, do the converse of an absence check: grep the file tree and the build for the advertised-but-allegedly-missing feature, confirm whether the named skill/module/dependency actually exists or ships anywhere, so a "this is vaporware" charge is verified rather than merely asserted — the advertised thing may genuinely live somewhere the persona never opened. For each claim, reach one of three verdicts:
  - **TRUE** — the friction is real and correctly aimed at this artifact. Leave it untouched.
  - **MISATTRIBUTED** — the friction is real but it isn't this artifact's fault (it belongs to the platform, the org's onboarding, the reader's own environment). Reword so the story stops charging it to the artifact.
  - **FALSE** — the thing the persona thought was missing or broken actually exists or works; they just didn't find it. This is the dangerous one, and the reason this pass exists.
- **Reframe FALSE claims into the real finding — don't just delete them.** A false conclusion almost always sits on top of a true finding, and deleting the conclusion throws the finding away with it. "`report.html` isn't in the repo" is false, but the gap underneath it is real: the README points at `report.html` and never says where to view it (the Pages URL) or how to build it. The fix is to rewrite the beat so the persona's genuine experience survives and the story states the finding that actually holds — Martin still can't find the report, but now it blames the missing pointer, not a missing file. Same friction, correct target.
- **Revise silently and keep the voice.** Edit in place: same persona, same tone, same lived beats, only the ungrounded claims reworked. Don't append a note, don't mark your edits, don't add a fact-check section — the output is still nothing but the story. If every charged claim checks out TRUE, return the story unchanged; a story that was honest the first time needs no surgery.
- **Don't sand off legitimate confusion.** Grounding a claim is not the same as resolving the persona's ignorance. Martin is still allowed to be confused on the page — that confusion is the UX signal, and the README really did fail him. You are only correcting places where the story asserts something _about the artifact_ that isn't true, never the honest friction of a real person not knowing something.

A note on the cast: an expert persona, if cast, cross-references in character, so most of their story passes this gate clean — but their _vaporware_ charges ("this advertised thing doesn't exist") are exactly the blinkered conclusion this pass exists to catch: grep the tree before you let "it isn't built" stand, since it may ship from a path even they never opened. The false claims otherwise cluster in the satisficing personas, who form conclusions from a deliberately partial view.

## Output format

Present tense, close third person, named. The persona's inner monologue in their own voice (quoted thoughts welcome), concrete references to the real artifacts they touch (file names, page sections, buttons, error text), and friction counted concretely ("four clicks and a guess"). A vivid scene, not a transcript of every file opened.

ALWAYS follow this exact shape — the assumptions, then one block per persona presented back to back with nothing between them, then the two closing sections:

## Assumptions

- [a precondition every story treats as satisfied even where reality differs — e.g. "every employee has internal GitLab access," "the artifact is already published"]
- [...]

[story blocks, back to back:]

> [Name], [role], [the moment/context they arrive in].
>
> [Opening: state plainly what they came to accomplish — the goal — and how they actually reached the artifact (their real entry point, not the front door).]
>
> [Middle beats: each names a real artifact they touch — a file, page section, button, error string — in their own voice. Count friction concretely. Every beat reads as progress toward the goal or a detour from it.]
>
> [Closing beat: end where the persona actually stops — they try it, bookmark it, rage-quit, succeed. No labeled verdict; the final lived beat carries the takeaway on its own.]

## Verdict

- [one line distilling the cast's shared takeaway about the artifact]
- [one line per cross-cutting theme — keep it to what the stories already showed]

## Consider actions

- [one-line, actionable suggestion that follows directly from the friction above]
- [...]

Why this order: the assumptions fix the scope before anyone reads a word, so no story gets read as a complaint about something already waived; the role and moment set the knowledge ceiling and patience the friction is measured against; the goal stated up front is the lens every later beat reads as progress-toward or detour-from; each story ends where the persona actually stops, and that final lived beat is its payload. The closing **Verdict** and **Consider actions** stay terse — one-liners only, summarizing and pointing at fixes, never introducing a finding no story earned. The reference above (Dana) is the worked instance for a single block.
