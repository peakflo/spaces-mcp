# OpenAI plugin package (ChatGPT + Codex directory)

This folder is the source for the ZIP uploaded at https://platform.openai.com/plugins (Upload → **With MCP**). It uses the Agent Plugins format: root `plugin.json` and `mcp.json`, plus `assets/`.

```bash
./build.sh "https://<demo-video-url>"                    # dist/peakflo-spaces-openai-plugin.zip
./build.sh "https://<demo-video-url>" --discovery-auth   # fallback if the uploader rejects mcp.json's auth block
```

- **Sign-in:** OAuth with dynamic client registration (`client.mode: "dcr"`), so there are no credentials in the package.
- **Reviewer login:** never in the ZIP. Enter it in the dashboard under **Review information → Review details**.
- **Review data:** the 5 positive and 3 negative test cases, release notes and `commerce: false` sit in `plugin.json` under `extensions.com.openai.review`. The demo video URL is inserted at build time.
- **ChatGPT tool set:** ChatGPT sessions don't get the generic executors (`integration_mcp_tools_list`, `integration_mcp_tool_call`, `table_sql_execute`), per OpenAI's plugin guidelines.
