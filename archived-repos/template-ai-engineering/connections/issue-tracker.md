---
name: issue-tracker
kind: mcp                 # mcp | openapi | api
url: https://mcp.example.com/issue-tracker/sse
auth:
  type: bearer           # bearer | api_key | oauth | none
  token_env: ISSUE_TRACKER_TOKEN   # env var holding the secret — NEVER the secret itself
scopes:
  - read:issues
  - read:pull_requests
---

EXAMPLE CONNECTION — a placeholder pointer to an issue tracker over MCP, included so
newcomers can see the connection shape. Read-only access to issues and merged pull
requests. Composed by the example `release-notes` agent. Replace the `url` and
`token_env` with your real tracker, or delete this file along with the example agent.

The harness brokers auth from `$ISSUE_TRACKER_TOKEN`; the model is handed the remote
tools and never sees the URL or the credential.
