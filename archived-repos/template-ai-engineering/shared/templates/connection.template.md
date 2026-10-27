---
# Copy this file to connections/<your-connection-name>.md and fill it in.
# A connection is a DECLARATIVE pointer to an MCP server or API. It names the
# env var that holds the credential — NEVER the credential itself.
name: <connection-name>       # kebab-case; must match the file name (without .md)
kind: <mcp | openapi | api>   # how the harness should wire it up
url: https://<host>/<path>    # the server/API endpoint
# spec: https://<host>/openapi.json   # OPTIONAL: only for kind: openapi
auth:
  type: <bearer | api_key | oauth | none>
  token_env: <ENV_VAR_NAME>   # the env var holding the secret — NEVER the secret
scopes:                       # OPTIONAL: least-privilege scopes you actually need
  - <read:something>
---

<One short paragraph: what this connection is, which tables/endpoints it exposes,
and which agents compose it. Note that the harness brokers auth from the named env
var; the model never sees the URL or the credential.>
