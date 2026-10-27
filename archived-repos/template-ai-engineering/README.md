# AI engineering template

A **team template** for building AI agents and the skills they share, once, and running
them in **whatever harness you prefer** — Claude Code, Codex, Google Antigravity, Hermes,
or a generic Agent-Skills layout. You author neutral source files; a small generator
projects them into each tool's expected layout.

> **Using this for the first time?** Click **"Use this template"** on GitHub to create your
> team's own repo, clone it, then read **[GETTING_STARTED.md](GETTING_STARTED.md)**.

## Why this exists

Teams end up rewriting the same agent for every tool, with the prompt and "skills" copied
into each one's bespoke format. This repo keeps a single source of truth and **projects** it
per-harness, so switching or supporting a new tool is a layout change, not a rewrite.

## The mental model (four nouns)

| Thing | Is | Lives in |
|-------|----|----------|
| **Skill** | one reusable capability, written once | `skills/<name>/SKILL.md` |
| **Agent** | a thin persona that *composes* skills + connections | `agents/<name>/AGENT.md` |
| **Connection** | a declarative pointer to an MCP server / API (names an env var, never a secret) | `connections/<name>.md` |
| **Harness** | the tool you actually run the agent in | `harnesses/<name>.conf` |

The generator reads the first three and writes them into the layout each **harness** wants.

## Five-minute quickstart

```sh
# 1. See which harnesses are supported
bin/generate.sh --list

# 2. Build the sources into your harness's layout (e.g. Claude Code)
bin/generate.sh claude-code        # → dist/claude-code/

# 3. Point your tool at the result (see harnesses/README.md for the exact step per tool)

# 4. In your tool, talk to the `agent-builder` agent:
#    "I want an agent that turns our merged PRs into release notes."
#    It will interview you, reuse existing skills, write the files, and rebuild.
```

That's it — you now have a working agent in your tool. The bundled **`release-notes`** agent
is a labeled EXAMPLE; delete it once you've built your own.

## What's in here

```
.
├── README.md                 # you are here
├── GETTING_STARTED.md        # onboarding + build-your-first-agent walkthrough
├── AGENTS.md                 # always-on project context + conventions
├── agents/                   # thin agent manifests (+ their evals)
│   ├── agent-builder/        #   the meta-agent that helps you create agents
│   └── release-notes/        #   a labeled EXAMPLE agent — learn from it, then delete
├── skills/                   # the shared skill library (written once, composed by agents)
│   ├── create-agent/  create-skill/  add-connection/   # the authoring layer
│   └── summarize-changes/                              # EXAMPLE skill
├── connections/              # declarative MCP/API pointers (env var names, never secrets)
├── harnesses/                # one .conf per harness + README on installing each
├── shared/                   # eval spec + copy-me templates
└── bin/                      # generate.sh (project sources) + validate.sh (lint sources)
```

## Daily commands

```sh
bin/generate.sh --all          # rebuild every harness after a change
bin/validate.sh                # check references resolve and frontmatter is complete
```

See **[AGENTS.md](AGENTS.md)** for the full conventions and **[GETTING_STARTED.md](GETTING_STARTED.md)**
for the guided path.
