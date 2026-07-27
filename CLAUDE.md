# cc-toys

Marketplace of Claude Code plugins. Each plugin lives in plugins/<name>/ with its manifest in .claude-plugin/plugin.json and the marketplace entry in .claude-plugin/marketplace.json at the repo root.

## Conventions

- A plugin's description string is character-identical in its plugin.json and in marketplace.json. Never let them drift.
- README plugin blurbs follow one template: sentence 1 is the manifest description verbatim; an optional sentence 2 adds the strongest concrete seller, phrased as reader outcome, not mechanism; then the trigger-prompt examples list. Every clause must be either a seller or a promise the shipped files back.
