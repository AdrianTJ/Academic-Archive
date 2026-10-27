# AI engineering template — agent & skill workspace

This repository is a **team template** for building AI agents and the skills they share,
in a way that is **harness-agnostic**: nothing here is specific to any one tool (Claude
Code, Codex, Antigravity, Hermes, …). You author each agent, skill, and connection **once**,
and a generator projects them into whatever layout each harness expects.

New here? Read **GETTING_STARTED.md** — it explains the mental model and walks you through
building your first agent in about fifteen minutes.

## How it's organized

- `skills/<name>/SKILL.md` — the shared skill library. Each skill is written **once** and
  may be composed by any number of agents. One skill does one well-defined thing (e.g.
  `summarize-changes`), with optional `scripts/`, `references/`, and `assets/` subfolders.
- `agents/<name>/AGENT.md` — a thin agent manifest. It declares the agent's identity and
  scope and lists which shared skills and connections it composes (in YAML frontmatter).
  It does **not** contain copies of skills.
- `connections/<name>.md` — a declarative pointer to an MCP server or API: its `url`,
  `kind`, and the **env var** that holds its credential (never the credential itself).
- `agents/<name>/eval/*.eval.yaml` — declarative behavior checks for that agent. See
  `shared/eval-spec.md` for the format.
- `harnesses/<name>.conf` — data describing where a given harness expects skills, agents,
  connections, and instructions to live. See `harnesses/README.md` for the per-tool details.
- `shared/templates/` — copy-me skeletons for new agents, skills, connections, and evals.
- `bin/generate.sh` — reads the above and materializes `dist/<harness>/`.
- `bin/validate.sh` — read-only checks that references resolve and frontmatter is complete.

## The two ways to add an agent

1. **Guided (recommended for newcomers).** Point your harness at the `agent-builder` agent
   and describe the workflow you want automated. It composes the `create-agent`,
   `create-skill`, and `add-connection` skills to interview you, reuse existing skills,
   write the files, and build. This is the path GETTING_STARTED.md walks through.
2. **By hand.** Follow the conventions in "Extending this repo" below.

## Conventions

- Default every skill to the shared library. Only localize a skill under an agent folder
  when it is both single-use and would be confusing to offer to other agents.
- Reuse before authoring. Most agents are pure compositions of skills that already exist;
  survey `skills/` before writing a new one.
- A skill's `description` is the entire basis on which an agent decides to load it — write
  it to say what the skill does AND when to use it.
- Secrets never live in the repo. A connection names only the env var that holds its token.
- Keep this file short — it is loaded on every turn. Directory-specific rules belong in a
  nested `AGENTS.md` next to the code they govern.
- `dist/` is generated output. Never edit it by hand; edit the sources and re-run the
  generator.

## Build

```sh
bin/generate.sh --list            # show available harnesses
bin/generate.sh claude-code       # build one, into dist/claude-code/ (symlinks)
bin/generate.sh --all             # build all harnesses
bin/generate.sh --copy --all      # build all as real files (no symlinks)
bin/validate.sh                   # check references resolve and frontmatter is complete
```

## Extending this repo (for coding agents)

If you are a coding agent working in this repo, follow these conventions. Each kind of
thing is a file (or directory) whose name and location ARE its definition; the generator
discovers it, no registration needed.

- **Add a skill:** create `skills/<name>/SKILL.md` from `shared/templates/SKILL.template.md`
  with YAML frontmatter (`name`, `description`) then a markdown body of instructions. The
  `description` must say what the skill does AND when to use it. Bundle `scripts/`,
  `references/`, `assets/` beside it as needed. Make it atomic and reusable.
- **Add an agent:** create `agents/<name>/AGENT.md` from `shared/templates/AGENT.template.md`.
  Frontmatter declares `name`, `role`, a `skills:` list, an optional `connections:` list,
  and optional `delegates_to:`. The body is the agent's identity, scope, and guardrails —
  keep it short; it becomes the system prompt. Reference existing shared skills by name.
- **Add a connection:** create `connections/<name>.md` from
  `shared/templates/connection.template.md` with frontmatter `name`, `kind`
  (`mcp` | `openapi` | `api`), `url`, and `auth.token_env` (the env var name — never a
  secret). Reference it from an agent's `connections:` list.
- **Add an eval:** create `agents/<agent>/eval/<name>.eval.yaml` per `shared/eval-spec.md`.
- **Add a harness:** drop in one `harnesses/<name>.conf`; the generator never changes.
- **After any structural change** (new/renamed skill, agent, connection, or harness, or a
  changed `skills:`/`connections:` list), run `bin/generate.sh --all` and `bin/validate.sh`.
- **Never** edit anything under `dist/`; it is generated. Edit the canonical sources.
