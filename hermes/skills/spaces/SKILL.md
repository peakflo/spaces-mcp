---
name: spaces
description: >
  Hand off finance and operations work to cloud agents or people in Spaces by Peakflo, and answer questions
  from the user's Spaces workspace through the `peakflo` MCP server. Use it when the user wants to delegate
  a task (one-off or on a schedule), check workflows and their runs, query data tables, pull reports on
  bills, invoices, payables or receivables, search company policy documents, or review pending approvals.
  Trigger it for short asks too: "hand this off", "every Monday send me the AR ageing", "which bills are
  overdue", "what does our expense policy say about client dinners", "did the vendor sync fail".
---

# Spaces by Peakflo

You reach the user's Spaces workspace through the `peakflo` MCP server that this plugin connects
(`https://api.peakflo.ai/mcp`, OAuth sign-in). Each tool has its own parameter descriptions and
read-only / destructive hints; read them. This skill is the operating logic on top.

## Sign-in

- The first time the server starts, a browser opens at app.peakflo.ai. The user signs up or signs in,
  picks a workspace and clicks **Allow access**. There are no API keys.
- Never ask the user for a password, API key or token in chat.
- If the tools do not appear after sign-in, ask the user to run `/reload-mcp`.
- Access follows the user's workspace role. The user can revoke it at any time in app.peakflo.ai →
  **Settings → MCP → Connected apps**.

## Which tools for which job

| Job | Tools |
|-----|-------|
| Hand off work (one-off or recurring) | `task_create` |
| Pending approvals and human tasks | `task_list`, then `task_complete` to submit a decision |
| Workflows and their runs | `workflow_list`, `workflow_get`, `workflow_execution_list`, `workflow_execution_get_steps` |
| Custom data | `table_list`, `table_schema`, then `table_query` or `table_sql` (read-only SQL) |
| Bills, invoices, vendors, customers, payments | `report_schema`, `report_schema_detail`, `report_query` |
| Policies and other reference documents | `datastore_list`, `datastore_query` |
| Connected apps (accounting, ERP, email) | `integrations_list`, `integration_mcp_tools_list`, `integration_mcp_tool_call` |

## Rules

1. **Look before you answer.** When a question depends on the user's own data, call the relevant read-only
   tools first and answer from what they return. If a report returns no rows, check `table_list` before
   saying there is no data. An empty result is a valid answer; say so.
2. **A missing tool or a permission error means no access**, not that the data does not exist. Tell the
   user which access is missing.
3. **Confirm before real effects.** Ask the user before running a workflow, activating a version,
   completing an approval, or changing or deleting data. Hermes also asks before every tool the server does
   not mark read-only, and refuses those tools in cron and other unattended runs.
4. **Queued is not done.** `task_create` queues work. Say the task is queued or scheduled, share the link
   it returns, and never say the work is finished.
5. **Recurring tasks** take a cron expression and a timezone. Restate the schedule in plain words
   ("every Monday at 9:00 Singapore time") so the user can check it.
6. **Out of scope:** Spaces does not move money, make payments or trade. For such a request, say so; you
   may offer to create a task for a person instead.
7. Report results as returned, including failures.
