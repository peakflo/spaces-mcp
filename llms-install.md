# Installing the Spaces by Peakflo MCP server

This is a hosted remote server, so there is nothing to build or run locally.

1. Add this server to the MCP settings (Streamable HTTP):
   ```json
   { "mcpServers": { "peakflo": { "type": "streamableHttp", "url": "https://api.peakflo.ai/mcp" } } }
   ```
2. On first use, the client opens a browser for OAuth. The user signs up or signs in at app.peakflo.ai, picks a workspace and clicks **Allow access**. There are no API keys.
3. Check that it works by calling `workflow_list`, which is read-only.

If the client does not support OAuth for remote servers, use a client that does (Claude, ChatGPT, Cursor, VS Code, Cline 3.x and later).
