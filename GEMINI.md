# Spaces by Peakflo

Use the `peakflo` MCP server to hand off repetitive finance and operations work to the cloud.

- To hand off work, use `task_create`. Give it a clear title and instructions. For recurring work, add a cron schedule and a timezone. Return the task link it gives you to the user. Creating a task only queues the work; never say it is done.
- To answer questions about the user's workspace, use the read-only tools: workflows, data tables, reports and Business Context.
- Ask before you call tools marked destructive, for example `workflow_execute`, `table_delete` or `integration_mcp_tool_call`.
- Never ask for credentials in chat. Sign-in happens in the browser through OAuth.
