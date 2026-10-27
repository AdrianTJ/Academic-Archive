---
name: create-skill
description: >
  Author a new shared skill in this repo correctly. Use when building or revising a
  reusable capability that one or more agents will compose — i.e. whenever the
  create-agent workflow hits a gap no existing skill covers, or when someone asks to
  "add a skill", "teach the agents how to do X", or capture a procedure as a reusable
  skill. Covers naming, the all-important what/when description, and the body shape.
---

# Create a skill

A skill is a single, reusable capability written **once** and composed by any number of
agents. Getting a skill right is mostly about discipline: one responsibility, and a
description that makes agents reach for it at the right moment.

## Workflow

1. **Make it atomic.** A skill does ONE well-defined thing (e.g. `write-sql`,
   `scrub-data`). If your description needs the word "and", consider splitting it. Atomic
   skills are the ones multiple agents can reuse.

2. **Check it doesn't already exist.** Skim `skills/` first. Extending or sharpening an
   existing skill beats adding a near-duplicate.

3. **Write the description like an API for attention.** The `description` is the ONLY
   thing an agent sees when deciding whether to load the skill. It must say **what** the
   skill does AND **when** to use it — including the words a user might actually type even
   if they never name the skill. This single field determines whether the skill ever fires.

4. **Keep the body a workflow, not an essay.** Copy `shared/templates/SKILL.template.md`
   to `skills/<name>/SKILL.md`. Structure the body as numbered steps and/or principles,
   then an **Output** section saying what to hand back. Write for an agent executing it,
   not a human reading about it.

5. **Bundle resources beside it.** Put helper scripts in `scripts/`, longer docs in
   `references/`, and templates/fixtures in `assets/` — loaded on demand, not inlined.

6. **Make it harness-agnostic and reusable.** No tool-specific assumptions in the skill
   body; the generator projects the same `SKILL.md` into every harness. Write it for *any*
   future agent, not the one that happened to need it first.

7. **Wire it up.** Add the skill's name to the relevant agent's `skills:` list, then run
   `bin/generate.sh --all` and confirm there are no "missing skill" warnings.

## A note on meta/infra skills

Skills like `create-agent` or `add-connection` are *authoring* tools, not end-user work.
Keep that kind of meta-skill composed only by the `agent-builder` agent — don't add it to
a task agent's `skills:` list, or you'll offer build tooling to an agent that should be
doing the user's actual work.

## Output

A new `skills/<name>/SKILL.md` (plus any `scripts/`/`references/`/`assets/`), referenced
from at least one agent, building cleanly. Confirm the description names the trigger
situations explicitly — that is the part most likely to be wrong.
