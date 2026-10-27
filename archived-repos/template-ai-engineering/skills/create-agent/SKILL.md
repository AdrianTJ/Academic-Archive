---
name: create-agent
description: >
  Turn a workflow someone does by hand into a new, harness-agnostic agent in this
  repo. Use whenever a person says they want to "create / build / set up an agent",
  "automate this workflow", "make an assistant that does X", or describes a recurring
  task they'd like an agent to own — even if they don't say the word "agent". This is
  the guided authoring path: it interviews for intent, reuses existing shared skills,
  writes a thin AGENT.md, stubs evals, runs the generator, and shows how to load the
  result into the person's harness.
---

# Create an agent

A disciplined workflow for authoring a new agent from a plain-language description of
what someone wants automated. The output is real files in this repo (an `AGENT.md`,
maybe new skills/connections, an eval or two) plus a working build the person can run.

The guiding principle: **agents are thin.** An agent is an identity plus a list of the
shared skills and connections it composes. Almost all the real capability lives in
reusable skills — so your first instinct is always to *reuse*, not to write new code.

## Workflow

1. **Interview for intent.** Before touching files, get crisp on:
   - The job to be done, in one sentence ("draft release notes from a merged-PR list").
   - Inputs and tools: what data, files, APIs, or systems does it touch?
   - What "good" looks like: the shape of a great result, and a bad one to avoid.
   - Guardrails: read-only vs. write, anything it must never do, sensitive data.
   - The person's harness (Claude Code, Codex, Antigravity, Hermes, …) — you'll need
     it for the final build and install step.

2. **Reuse first — survey existing skills.** Read the `description` of every skill in
   `skills/` and list the ones that already cover parts of this workflow. Most agents
   are *entirely* a composition of skills that already exist. Name the matches back to
   the person and confirm the fit before writing anything.

3. **Fill genuine gaps with new skills.** Only for capabilities no existing skill
   covers, author a new one using the `create-skill` skill. Keep each new skill atomic
   and reusable — written for *any* future agent, not just this one.

4. **Identify connections.** If the agent needs a live MCP server or API, check
   `connections/` for an existing pointer; if it's new, use the `add-connection` skill.
   Never invent credentials — connections name an env var only.

5. **Draft the AGENT.md.** Copy `shared/templates/AGENT.template.md` to
   `agents/<name>/AGENT.md` and fill it in:
   - `name` matches the folder (kebab-case); `role` is one or two plain-language lines.
   - `skills:` lists the reused + new skill names from steps 2–3.
   - `connections:` lists any from step 4 (omit if none).
   - `delegates_to:` names other agents it may call as subagents (omit if none).
   - The body is a short **Scope** (what it does and does *not* do) and **Guardrails**.
     Keep it tight — it becomes the system prompt.

6. **Stub evals.** Add one or two checks under `agents/<name>/eval/` from
   `shared/templates/eval.template.yaml`, per `shared/eval-spec.md`. A good first eval
   asserts the agent loads the skill you expect and that its reply does/does not contain
   a tell-tale phrase. Evals are how the team keeps agents honest over time.

7. **Build and resolve warnings.** Run `bin/generate.sh <their-harness>` (or `--all`).
   Fix any `warning: agent '<name>' references missing skill/connection` — those mean a
   `skills:`/`connections:` entry doesn't match a real folder/file. A clean run is the
   bar.

8. **Show the last mile.** Point the person to `harnesses/README.md` for exactly how to
   load `dist/<their-harness>/` into their tool, then suggest they try the agent on a
   real example from step 1 and iterate.

## Output

A new `agents/<name>/` with a thin `AGENT.md` and at least one eval; any new skills or
connections it required; a clean generator build; and a one-paragraph hand-off telling
the person how to run their agent and what to try first. If you had to assume anything
(a guardrail, a data source, a definition), state it plainly rather than guessing silently.
