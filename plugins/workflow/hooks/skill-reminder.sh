#!/bin/sh
cat <<'JSONEOF'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "INSTRUCTION: MANDATORY SKILL ACTIVATION\n\nCheck available skills for relevance before proceeding.\n\nIF any skills are relevant:\n  1. State which skills and why (can be multiple)\n  2. Immediately activate ALL relevant skills with Skill(skill-name) tool calls\n  3. Then proceed with task\n\nIF no skills are relevant:\n  - Proceed directly\n\nExample of multiple skills:\n  User asks \"check mongo on server 192.168.1.111 for yesterday's data and report any issues\"\n  → Activate: datetime (for \"yesterday\"), mongo (for query), ssh (for server access)\n\nCRITICAL: Activate ALL relevant skills via Skill() tool before implementation.\nMultiple skills can and should be activated when applicable.\nMentioning a skill without activating it is worthless."
  },
  "suppressOutput": true
}
JSONEOF
