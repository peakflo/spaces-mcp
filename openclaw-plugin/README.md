<p align="center"><img src="https://raw.githubusercontent.com/peakflo/spaces-mcp/main/assets/logo-512.png" width="96" height="96" alt="Spaces by Peakflo logo"></p>

# Spaces by Peakflo: OpenClaw plugin

Adds the hosted Spaces by Peakflo MCP server to OpenClaw:

- URL: `https://api.peakflo.ai/mcp`
- Transport: Streamable HTTP
- Auth: OAuth 2.1 with PKCE. You sign up or sign in in the browser. There are no API keys.

The package declares the remote MCP server in `openclaw.plugin.json` (`mcpServers.peakflo`) and ships the icon. `dist/index.js` is an empty entry that OpenClaw's package format requires; it registers nothing and makes no network calls.

## Install and connect

```bash
openclaw plugins install @peakflo/spaces
```

OpenClaw asks you to approve the plugin's capabilities (it adds one MCP server). Then connect your account from the plugin's page in the Control UI: **Settings → Plugins → Spaces by Peakflo → Accounts → peakflo → Connect**. Pick your workspace and click **Allow access**. The tools appear as `peakflo__<tool>`, for example `peakflo__task_create`.

The terminal `openclaw mcp login` only sees servers under `mcp.servers`. To sign in from the terminal instead, add the same server as an explicit entry (it replaces the plugin's default), then log in:

```bash
openclaw mcp add peakflo --url https://api.peakflo.ai/mcp --transport streamable-http --auth oauth
openclaw gateway stop; openclaw mcp login peakflo; openclaw gateway start
openclaw mcp doctor peakflo --probe
```

## What you can do

- Hand off one-off or recurring (cron) work to a cloud agent or a person (`task_create`). Queued work is never reported as done.
- Ask about your workspace: workflows and runs, data tables (read-only SQL), reports, Business Context documents such as policies, and pending approvals.

Access follows your workspace role. Spaces does not start payments on its own; approvals and workflows that can move money need your explicit confirmation. Revoke access any time in app.peakflo.ai → **Settings → MCP → Connected apps**.

Docs: https://spaces.peakflo.ai/docs/mcp/ · Support: https://help.peakflo.co · [Privacy](https://help.peakflo.co/peakflo-privacy-policy) · [Terms](https://help.peakflo.co/terms-and-conditions)

The icon is the Spaces logo, © Peakflo Pte. Ltd. The package files are MIT licensed.
