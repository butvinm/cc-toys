# cc-toys

Marketplace of Claude Code plugins. Each plugin lives in plugins/<name>/ with its manifest in .claude-plugin/plugin.json and the marketplace entry in .claude-plugin/marketplace.json at the repo root.

## Conventions

- A plugin's description string is character-identical in its plugin.json and in marketplace.json. Never let them drift.
- A description of a growing collection stays open-set ("such as X, Y, Z"), never a closed enumeration that the next added tool would invalidate.
- README describes tools, not plugins: one H2 per plugin titled `name (plugin)` opening with the manifest description verbatim, then one H3 per tool titled `name (skill|command|hook)` with its trigger on the first line and a 1-3 line value-first description, optionally a one-line Try: and a collapsed example-output details block. Every clause is either a seller or a promise the shipped files back.
