# cc-toys

Personal collection of Claude Code skills, packaged as plugins.

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

**Manual install** (without the marketplace): copy the skill into your user skills directory.

```bash
cp -r plugins/user-story/skills/user-story ~/.claude/skills/
```

The skill is self-contained (no bundled scripts or references), so no path fixups are needed after copying.

## License

MIT
