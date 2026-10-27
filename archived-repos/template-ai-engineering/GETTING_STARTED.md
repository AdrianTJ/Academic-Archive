# Getting started

This guide is for someone who can code but is **new to agentic engineering**. By the end
you'll understand the mental model and have built your own agent running in your preferred
tool. Budget about fifteen minutes.

## 1. The idea in one paragraph

An **agent** is a persona you give a job to. It gets its abilities from **skills** —
reusable, plain-Markdown instructions for doing one thing well — and reaches live systems
through **connections**. The catch: every tool ("**harness**") wants these files in a
different place and format. So instead of writing your agent five times, you write it once
here, and `bin/generate.sh` **projects** it into each harness's layout. Author once, run
anywhere.

## 2. The four building blocks

- **Skill** (`skills/<name>/SKILL.md`) — one capability, written once, reusable by any
  agent. The frontmatter `description` is what makes an agent decide to use it, so it says
  *what* the skill does and *when* to reach for it. Example: `summarize-changes`.
- **Agent** (`agents/<name>/AGENT.md`) — **thin**: an identity plus a list of the skills and
  connections it composes. No skill text is copied into it. Example: `release-notes`.
- **Connection** (`connections/<name>.md`) — a declarative pointer to an MCP server or API.
  It names the **environment variable** that holds the credential; the secret never lives in
  the repo. Example: `issue-tracker`.
- **Harness** (`harnesses/<name>.conf`) — pure data describing where one tool wants those
  files. Supported today: `claude-code`, `codex`, `antigravity`, `hermes`, `generic`.

## 3. Build the example, point your tool at it

```sh
bin/generate.sh --list           # the harnesses you can target
bin/generate.sh claude-code      # build into dist/claude-code/  (use your own harness here)
```

Now load `dist/<your-harness>/` into your tool. The exact step differs per tool — see
**[harnesses/README.md](harnesses/README.md)**. (For Claude Code, for instance, the
generated `dist/claude-code/` contains a `.claude/` directory and `CLAUDE.md` you point the
tool at.)

Open your tool and you'll find the **`agent-builder`** agent and a labeled EXAMPLE agent,
**`release-notes`**. Try the example to feel the loop, then build your own.

## 4. Build your first agent (the guided path)

In your harness, talk to **`agent-builder`** and describe a real task you do by hand. For
example:

> "I want an agent that reviews our on-call runbooks and flags steps that are out of date."

It will:

1. **Interview** you — inputs, what "good" looks like, guardrails (read-only? sensitive data?).
2. **Reuse first** — survey `skills/` and tell you which existing skills already fit.
3. **Fill gaps** — author any genuinely new skill (via `create-skill`) or connection (via
   `add-connection`), keeping each one atomic and reusable.
4. **Write a thin `AGENT.md`** under `agents/<your-agent>/`, composing those skills.
5. **Stub an eval** so the behavior stays checked over time.
6. **Build** with `bin/generate.sh` and show you how to load the result.

Prefer to do it by hand? Copy `shared/templates/AGENT.template.md` to
`agents/<name>/AGENT.md`, fill in the frontmatter and a short Scope/Guardrails body, then
run `bin/generate.sh --all`. The "Extending this repo" section of
[AGENTS.md](AGENTS.md) has the full conventions.

## 5. After any change

```sh
bin/validate.sh                  # references resolve? frontmatter complete?
bin/generate.sh --all            # re-project into every harness
```

CI runs both on every pull request, so a broken reference can't reach `main`.

## 6. Clean up the example

Once your own agent works, delete the illustrative example so the repo reflects only your
team's real agents:

```sh
rm -rf agents/release-notes skills/summarize-changes connections/issue-tracker
bin/generate.sh --all && bin/validate.sh
```

## Troubleshooting

- **`warning: agent '<x>' references missing skill/connection '<y>'`** — a `skills:` or
  `connections:` entry in an `AGENT.md` doesn't match a real `skills/<y>/` folder or
  `connections/<y>.md` file. Fix the name or create the missing piece.
- **My tool can't follow the symlinks in `dist/`.** Build with `bin/generate.sh --copy <harness>`
  to materialize real files instead of symlinks.
- **Where do secrets go?** In your environment, under the variable named by the connection's
  `auth.token_env`. The harness brokers it; the model never sees it. Never paste a token into
  a file here.
- **I changed a skill's body but not its name.** No rebuild needed in symlink mode — the
  generated layouts point back at the source. Structural changes (new/renamed files, changed
  lists) do need `bin/generate.sh --all`.
