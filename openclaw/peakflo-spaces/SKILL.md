---
name: peakflo-spaces
description: Connect OpenClaw to Spaces by Peakflo, a hosted MCP server for finance and ops work. Hand off one-off or recurring tasks to cloud agents or people, and query workflows, data tables, reports, policy documents and approvals. Sign in with OAuth; no API keys.
homepage: https://spaces.peakflo.ai/docs/mcp/
metadata: {"openclaw":{"emoji":"🗂️"}}
---

# Spaces by Peakflo

Spaces by Peakflo is a hosted (remote) MCP server for finance and operations teams. Use it to:

- **Hand off work** to a cloud agent or a person, one-off or on a schedule (`task_create`).
- **Answer questions about the user's workspace**: workflows and their runs, data tables, aggregated reports, Business Context documents such as policies, and pending approvals.

Server facts:

- URL: `https://api.peakflo.ai/mcp`
- Transport: Streamable HTTP. Set it explicitly; OpenClaw uses SSE when `transport` is omitted.
- Auth: OAuth 2.1 with PKCE (S256) and dynamic client registration. The user signs up or signs in in the browser. There are no API keys or tokens to paste.

## Connect (one time)

If no `peakflo` server is configured yet (`openclaw mcp show peakflo` fails), give the user these commands. They run them on the Gateway host:

```bash
openclaw mcp add peakflo \
  --url https://api.peakflo.ai/mcp \
  --transport streamable-http \
  --auth oauth

# Sign-in runs offline: stop the Gateway first and start it again afterwards.
openclaw gateway stop
openclaw mcp login peakflo
openclaw gateway start

openclaw mcp doctor peakflo --probe
```

The same definition as config (`mcp.servers` in `openclaw.json`):

```json5
{
  mcp: {
    servers: {
      peakflo: {
        url: "https://api.peakflo.ai/mcp",
        transport: "streamable-http",
        auth: "oauth"
      }
    }
  }
}
```

- `openclaw mcp login peakflo` prints an authorization URL. The user opens it, signs up or signs in, picks a workspace and clicks **Allow access**. OpenClaw catches the loopback redirect and saves the credentials. If the browser cannot reach the callback, use the printed `openclaw mcp login peakflo --code <code>` command.
- In the Control UI, a person with admin access can instead use **+ → Plugins → Add MCP server…** with the same URL, Streamable HTTP and OAuth.
- `doctor --probe` should report the server as ok and list its tools. A warning such as "OAuth credentials are not authorized" means the login step has not finished yet.
- OpenClaw exposes the tools as `peakflo__<tool>`, for example `peakflo__task_create`.

Never ask the user for a password, API key, token or authorization code in chat. Sign-in always happens in the browser.

## Hand off work: `task_create`

Use it when the user wants something done rather than answered: "have someone…", "every Monday…", "hand this off…", "collect…", "follow up with…".

- `title`: short and specific.
- `description`: clear instructions, with everything the assignee needs to do the work.
- `schedule` (optional): `{ "cron": "0 9 * * 1", "timezone": "Asia/Singapore" }`. The timezone is an IANA name and defaults to UTC.
- `assignee` (optional): `{ "kind": "agent" | "user", "id": "<uuid>" }`. Use only an ID returned by a Spaces tool (for example `users_list`). Never guess an ID.
- `clientRequestId`: generate one per intended task and reuse it if you retry, so a retry does not create a duplicate.

Routing:

- A one-off task with no assignee goes through triage to a suitable agent or person.
- A recurring task runs with the assignee you set. Without one, it is assigned to the user who created it. Recurring tasks are not triaged automatically.

After the call, give the user the task link from the result. Say the task is **queued** or **scheduled**. Never say the work is done.

Examples:

- "Every Monday at 9am Singapore time, have someone in finance send me the AR ageing summary." → `task_create` with `schedule: { cron: "0 9 * * 1", timezone: "Asia/Singapore" }`.
- "Hand off this vendor onboarding: collect the W-9 and bank details from Acme Ltd." → one-off `task_create`, no assignee.

## Answer from the workspace (read-only)

Look up the answer before you reply. Don't answer from memory.

| Question | Tools |
|---|---|
| Workflows, automations and their runs | `workflow_list`, `workflow_get`, `workflow_execution_list`, `workflow_execution_get_steps` |
| Bills, invoices, payables, receivables, spend | `report_schema` → `report_schema_detail` → `report_query` |
| Custom data | `table_list` → `table_schema` → `table_query` or `table_sql` (read-only SQL) |
| Policies and reference documents | `datastore_list` → `datastore_query` |
| Pending approvals and human tasks | `task_list` |
| Connected apps (accounting, ERP, email) | `integrations_list` → `integration_mcp_tools_list` |

- If a report returns no rows, check the data tables (`table_list`) before you say there is no data.
- An empty result is a valid answer. Report it as empty.
- A missing tool or a permission error means the user has no access. Say so. It does not mean the data doesn't exist.
- The available tools follow the user's workspace role and permissions.

Examples: "Which of my workflows failed last week?", "Show unpaid and overdue bills by vendor.", "What does our expense policy say about client dinners?"

## Safety

- **Confirm before any write.** Before you run a workflow (`workflow_execute`), complete an approval (`task_complete`), call a connected-app tool that changes data (`integration_mcp_tool_call`), or change or delete table data, show the user exactly what you will do and wait for a yes. Completing an approval can resume a workflow that posts entries or releases payments.
- Every Spaces tool is annotated read-only, destructive or open-world. Treat anything not read-only as a write.
- **No money movement.** Spaces does not transfer money, make payments or trade securities. If asked, say so, and offer to create a task for a person instead. Never claim that a payment or trade happened.
- Report results exactly as the tools return them, including failures.
- To disconnect, the user can run `openclaw mcp logout peakflo`, or revoke access in app.peakflo.ai → **Settings → MCP → Connected apps**.

## Links

- Docs: https://spaces.peakflo.ai/docs/mcp/
- Source and other client configs: https://github.com/peakflo/spaces-mcp
- Privacy: https://help.peakflo.co/peakflo-privacy-policy · Terms: https://help.peakflo.co/terms-and-conditions
- Support: https://help.peakflo.co · support@peakflo.co
