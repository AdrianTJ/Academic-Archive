---
name: add-connection
description: >
  Declare a connection to an MCP server or external API so agents can use live tools and
  data. Use when an agent needs to reach a real system — a database, a warehouse, an
  internal API — and there's no existing connections/<name>.md for it, or when someone
  asks to "connect to", "add an MCP server", "wire up an API", or "give the agent access
  to X". Handles the declarative pointer only; the credential always stays in the
  environment.
---

# Add a connection

A connection is a **declarative pointer**: it tells a harness how to wire up an MCP server
or API and which environment variable holds the credential. The secret itself never lives
in the repo — only the name of the env var that holds it.

## Workflow

1. **Check for an existing one.** Look in `connections/` first; reuse a pointer if the
   system is already declared.

2. **Gather the facts.** You need: the `kind` (`mcp`, `openapi`, or `api`), the `url`,
   the auth `type`, and the **name of the env var** holding the secret. For `openapi`,
   also the `spec` URL. Use least-privilege `scopes` — only what the agent actually needs.

3. **Write the file.** Copy `shared/templates/connection.template.md` to
   `connections/<name>.md` and fill in the frontmatter. Put one short paragraph in the
   body: what the connection exposes (which tables/endpoints) and which agents compose it.

4. **Never commit a secret.** `auth.token_env` is an env var NAME (e.g. `WAREHOUSE_TOKEN`),
   never a token. If you ever find yourself pasting a credential, stop — it belongs in the
   environment, and the harness brokers it so the model never sees it.

5. **Reference it.** Add the connection's `name` to the relevant agent's `connections:`
   list and run `bin/generate.sh --all`.

## Know how your harness handles connections

The generator only projects a `connections/` directory for harnesses whose `.conf` sets
`CONNECTIONS_DIR` (the `generic` layout does). Claude Code, Hermes, and Antigravity each
configure MCP servers through their own settings (`.mcp.json`, `~/.hermes/config.yaml`,
Antigravity's MCP config) rather than a markdown `connections/` dir — so for those, the
`connections/<name>.md` file stays the **source of truth** you transcribe into the tool's
own MCP settings. See `harnesses/README.md` for the per-tool specifics.

## Output

A new `connections/<name>.md` naming only an env var, referenced from at least one agent,
building cleanly — plus a note on where (if anywhere) the person must also register the
MCP server in their harness's own settings.
