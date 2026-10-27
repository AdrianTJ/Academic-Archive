# Harnesses — what each build produces and how to install it

A **harness** is the tool you actually run agents in. Each `harnesses/<name>.conf` is pure
data describing where that tool expects skills, agents, connections, and instructions to
live. `bin/generate.sh <name>` reads it and writes `dist/<name>/` in exactly that shape.

```sh
bin/generate.sh --list           # list harnesses
bin/generate.sh <name>           # build one  → dist/<name>/   (symlinks to the sources)
bin/generate.sh --copy <name>    # build one with real files (if your tool can't follow symlinks)
bin/generate.sh --all            # build them all
```

The generated tree **mirrors the sources** (symlink mode), so editing a `SKILL.md` updates
every build instantly. Below: what each `dist/<name>/` contains and how to point the tool at
it. In every case you install by copying or symlinking the build's contents into the
location the tool reads (a project root, or the tool's config dir).

> **Adding a new harness?** Drop in one `harnesses/<name>.conf` setting any of `SKILLS_DIR`,
> `AGENTS_DIR`, `CONNECTIONS_DIR`, `INSTRUCTIONS_FILE`, `ALSO_AGENTS_MD`, `AGENT_FILE_EXT`.
> The generator never changes. Use the existing `.conf` files as worked examples.

## Claude Code  →  `dist/claude-code/`

```
CLAUDE.md                     # project context (also emitted as AGENTS.md)
.claude/skills/<name>/        # one SKILL.md per skill
.claude/agents/<name>.md      # one subagent per agent
```

Install: copy or symlink `CLAUDE.md` and `.claude/` into your project root. Claude Code reads
skills from `.claude/skills/` and subagents from `.claude/agents/` automatically.

Connections: Claude Code configures MCP servers in its own settings (`.mcp.json` / project
config), so the build intentionally does **not** emit a connections dir. Transcribe each
`connections/<name>.md` into your `.mcp.json`, putting the real token in the env var the file
names (e.g. `ISSUE_TRACKER_TOKEN`).

## Codex  →  `dist/codex/`

```
AGENTS.md                     # project context Codex reads at the repo root
.codex/skills/<name>/         # one SKILL.md per skill
.codex/agents/<name>.md       # one agent per file
```

Install: place `AGENTS.md` and `.codex/` at your project root. **Caveat:** confirm the skills
path against your Codex version's current docs and adjust `SKILLS_DIR` in `codex.conf` if it
differs. MCP/connection config follows Codex's own settings.

## Google Antigravity  →  `dist/antigravity/`

```
AGENTS.md                     # standing instructions at the project root
.agents/skills/<name>/        # SKILL.md skills (Antigravity is SKILL.md-compatible)
.agents/agents/<name>.md      # per-agent manifests (see caveat)
```

Install: place `AGENTS.md` and `.agents/` at your project root. Skills drop in natively.
**Caveat:** Antigravity natively centralizes personas in a single `.agents/agents.md`; this
generator emits one file per agent under `.agents/agents/`, which it treats as reference
manifests. Fold them into `.agents/agents.md` if you want Antigravity to act on them as
first-class personas. MCP is configured in Antigravity's own settings.

## Hermes  →  `dist/hermes/`

```
AGENTS.md                     # Hermes auto-loads this (also .hermes.md, CLAUDE.md)
.hermes/skills/<name>/        # SKILL.md skills (auto-discovered)
.hermes/agents/<name>.md      # per-agent manifests (reference; see caveat)
```

Install: place `AGENTS.md` and `.hermes/` at your project root. Hermes auto-discovers
SKILL.md skills. **Caveat:** Hermes has no file-based subagent registry — it spawns subagents
dynamically via `delegate_task`. The per-agent files are reference/context; cite them from
`AGENTS.md` so the delegator knows the roster. MCP servers are configured in
`~/.hermes/config.yaml` (`mcp_servers:`); transcribe each `connections/<name>.md` there.

## Generic (Agent-Skills baseline)  →  `dist/generic/`

```
AGENTS.md
skills/<name>/                # SKILL.md skills
agents/<name>.md              # per-agent manifests
connections/<name>.md         # connection pointers (the only harness that projects these)
```

Install: a safe baseline for any tool that reads a top-level `skills/` directory and an
`AGENTS.md`. This is the only harness whose `.conf` sets `CONNECTIONS_DIR`, so the connection
pointers are projected as-is. Adjust to your tool's specifics.

---

### A note on connections and secrets

Most harnesses wire up MCP servers through their **own** settings, so the generator only
projects a `connections/` directory for harnesses whose `.conf` sets `CONNECTIONS_DIR` (just
`generic` today). For everything else, the canonical `connections/<name>.md` remains the
**source of truth** you transcribe into the tool's MCP config. Either way, the file names only
an **environment variable**; the secret lives in your environment, never in the repo.
