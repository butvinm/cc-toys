# cc-toys

Marketplace of Claude Code plugins. Each plugin lives in plugins/<name>/ with its manifest in .claude-plugin/plugin.json and the marketplace entry in .claude-plugin/marketplace.json at the repo root.

scripts/ holds standalone tools that run from a terminal rather than from inside a Claude Code session, so they belong to no plugin and have no marketplace entry.

## Conventions

- A plugin's description string is character-identical in its plugin.json and in marketplace.json. Never let them drift.
- A description of a growing collection stays open-set ("such as X, Y, Z"), never a closed enumeration that the next added tool would invalidate.
- README describes tools, not plugins: one H2 per plugin titled `name (plugin)` opening with the manifest description verbatim, then one H3 per tool titled `name (skill|command|hook)`. Every tool opens with its 1-3 line value-first description; invocation comes after - skills close with one "Invoke with `/plugin:skill` or prompts like ..." line, hooks close with their event and requirements. optionally a one-line Try: and a collapsed example-output details block. Every clause is either a seller or a promise the shipped files back.
- A standalone script gets its own H2 titled `name (script)` in the same value-first shape, closing with its invocation line instead of a plugin install command.
- Scripts are POSIX sh (`#!/bin/sh`, no bashisms), carry their own `-h` usage text, and are executable in git.
