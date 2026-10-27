---
# Copy this file to agents/<your-agent-name>/AGENT.md and fill it in.
# The agent is THIN: it declares an identity and lists the shared skills and
# connections it composes. It never copies skill instructions inline.
name: <agent-name>            # kebab-case; must match the folder name
role: <one or two lines: what this agent is for, in plain language>
skills:                       # names of shared skills/<name>/ this agent composes
  - <existing-skill-name>     # reuse an existing skill whenever one fits
  # - <another-skill>
connections:                  # OPTIONAL: names of connections/<name>.md it uses; omit if none
  # - <connection-name>
delegates_to:                 # OPTIONAL: names of OTHER agents it may call as subagents
  # - <other-agent-name>
---

# <Agent name>

## Scope
<What this agent does and, just as importantly, what it does NOT do. Keep it to a
few sentences — this becomes the agent's system prompt.>

## Guardrails
- <A hard rule the agent must always follow, e.g. "Read-only by default.">
- <Another, e.g. "Show the commands/queries it ran so the work is reproducible.">
