# Spaces by Peakflo: MCP server

**Hand off repetitive work to the cloud. An agent or a human gets it done.**

Spaces by Peakflo is a hosted (remote) [Model Context Protocol](https://modelcontextprotocol.io) server for finance and operations teams. Connect it to Claude, ChatGPT, Gemini, Cursor, VS Code or any MCP client, describe the job, and hand it off.

- **Server URL:** `https://api.peakflo.ai/mcp`
- **Transport:** Streamable HTTP
- **Auth:** OAuth 2.1 with PKCE (S256). Clients can register through dynamic client registration or a client ID metadata document. You sign up or sign in in the browser, so there are no API keys to paste.
- **Website:** https://spaces.peakflo.ai · **Docs:** https://spaces.peakflo.ai/docs/mcp/

This repository contains no server code. It only holds the connection configs for each client and the directory metadata.

## Connect

| Client | How |
|---|---|
| Claude (claude.ai / Desktop) | Settings → Connectors → **Add custom connector** → `https://api.peakflo.ai/mcp` |
| Claude Code | `claude mcp add --transport http peakflo https://api.peakflo.ai/mcp` — or as a plugin: `/plugin install peakflo-spaces --marketplace peakflo/spaces-mcp` |
| ChatGPT | Settings → Apps → Developer mode → **Create app** → `https://api.peakflo.ai/mcp` |
| Gemini app | gemini.google.com → Settings → Connected Apps → Custom apps → **Add a custom app** (US, personal accounts) |
| Gemini CLI | `gemini extensions install https://github.com/peakflo/spaces-mcp` |
| Hermes Agent | `hermes plugins install peakflo/spaces-mcp/hermes` (see [`hermes/`](hermes/README.md)) |
| Cursor | Install the plugin from this repo, or add [`mcp.json`](mcp.json) to `~/.cursor/mcp.json` |
| VS Code | `code --add-mcp '{"name":"peakflo","type":"http","url":"https://api.peakflo.ai/mcp"}'` |
| OpenClaw | `openclaw mcp add peakflo --url https://api.peakflo.ai/mcp --transport streamable-http --auth oauth`, then `openclaw gateway stop; openclaw mcp login peakflo; openclaw gateway start` (sign-in needs the Gateway stopped). Skill on [ClawHub](https://clawhub.ai/dimavedenyapin/skills/peakflo-spaces): `openclaw skills install @dimavedenyapin/peakflo-spaces` |
| Other | Any MCP client that supports Streamable HTTP and OAuth: use the URL above |

The first time you connect, a browser window opens. Sign up or sign in, pick your workspace and click **Allow access**.

## What your assistant can do

| Tool | What it does | Kind |
|---|---|---|
| `task_create` | Hand off a one-off or recurring (cron) task to a cloud agent or a person. Returns a link. Queued work is never shown as done. | write |
| `workflow_list`, `workflow_get`, `workflow_execution_list` | See your automations and their runs | read-only |
| `workflow_execute` | Run a workflow | write, destructive |
| `table_list`, `table_query`, `table_sql` | Query data tables (read-only SQL) | read-only |
| `report_schema`, `report_query` | Aggregated analytics | read-only |
| `datastore_list`, `datastore_query` | Search Business Context documents | read-only |
| `integrations_list`, `integration_mcp_tool_call` | Use connected apps (accounting, ERP, email) | read-only / write |
| `task_list`, `task_complete` | Approvals and human tasks | read-only / write |

Every tool has a title and read-only, destructive and open-world hints, so your assistant can ask before it changes anything. The tools you see follow your workspace role and permissions.

## Example prompts

- "Every Monday at 9am Singapore time, have someone in finance send me the AR ageing summary."
- "Hand off this vendor onboarding: collect the W-9 and bank details from Acme Ltd."
- "Which of my workflows failed last week?"
- "Show unpaid bills by vendor this quarter."
- "What does our expense policy say about client dinners?"

## Privacy, security and disconnecting

- We store only hashes of tokens. Access tokens last 1 hour, and connections last 30 days.
- To revoke access at any time, go to app.peakflo.ai → **Settings → MCP → Connected apps**.
- [Privacy policy](https://help.peakflo.co/peakflo-privacy-policy) · [Terms](https://help.peakflo.co/terms-and-conditions) · [Disconnect and delete your data](https://spaces.peakflo.ai/docs/mcp/#disconnect)

## Support

https://help.peakflo.co · support@peakflo.co

## Licence

The configuration files and docs in this repository are MIT licensed. The hosted service is covered by the [Terms](https://help.peakflo.co/terms-and-conditions).
