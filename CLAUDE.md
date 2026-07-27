# cc-toys

Marketplace of Claude Code plugins. Each plugin lives in plugins/<name>/ with its manifest in .claude-plugin/plugin.json and the marketplace entry in .claude-plugin/marketplace.json at the repo root.

## Conventions

- A plugin's description string is character-identical in its plugin.json and in marketplace.json. Never let them drift.
- README plugin blurbs are 1-3 lines total: the manifest description verbatim, optionally followed by a one-line Try: with one or two example prompts, then a collapsed example-output details block. No mechanism talk; every clause is either a seller or a promise the shipped files back.
