# OpenClaw / ClawHub

`peakflo-spaces/` is an [OpenClaw skill](https://docs.openclaw.ai/tools/skills) to publish on [ClawHub](https://clawhub.ai). It tells an OpenClaw agent how to connect the hosted Spaces MCP server (`https://api.peakflo.ai/mcp`, Streamable HTTP and OAuth) and how to use it safely.

Only `SKILL.md` is published. This README stays out of the skill folder so it is not uploaded.

## Why a skill and not a plugin

ClawHub has no MCP-server item type, only skills and code or bundle plugins. Bundle plugins can declare MCP servers, but the [bundle docs](https://docs.openclaw.ai/plugins/bundles) describe only static `headers` for HTTP servers, not `auth: "oauth"`. For Claude bundles, `.mcp.json` exposes stdio servers only. A skill plus `openclaw mcp add … --auth oauth` is the path that is documented and that we tested.

## Install (users)

```bash
# 1. Install the skill. Run this from your OpenClaw workspace; it installs into ./skills.
clawhub install peakflo-spaces
#    or, natively: openclaw skills install @OWNER/peakflo-spaces
#    (replace OWNER with the ClawHub publisher handle shown on the skill page)

# 2. Add the Spaces MCP server and sign in. Stop the Gateway during sign-in.
#    The ";" makes sure the Gateway starts again even if sign-in fails or is cancelled.
openclaw mcp add peakflo --url https://api.peakflo.ai/mcp --transport streamable-http --auth oauth
openclaw gateway stop; openclaw mcp login peakflo; openclaw gateway start
openclaw mcp doctor peakflo --probe
```

## Publish (owner)

You need `clawhub login` with a GitHub account that is old enough to pass the ClawHub upload gate. ClawHub scans every release automatically.

```bash
npm i -g clawhub            # CLI 0.25.1 was tested
clawhub login
clawhub whoami

# from the repo root, on the merged commit
clawhub skill publish ./openclaw/peakflo-spaces \
  --slug peakflo-spaces \
  --name "Spaces by Peakflo" \
  --version 1.0.0 \
  --tags latest \
  --changelog "First release: connect OpenClaw to the hosted Spaces MCP server (Streamable HTTP, OAuth 2.1), hand off one-off or recurring work with task_create, read-only workspace queries, and safety rules (confirm writes and approvals; never start payments on its own)." \
  --source-repo peakflo/spaces-mcp \
  --source-commit "$(git rev-parse HEAD)" \
  --source-path openclaw/peakflo-spaces

# add --owner <org-handle> to publish under a ClawHub publisher org instead of your user
# afterwards:
clawhub inspect peakflo-spaces
clawhub skill verify peakflo-spaces
```

Add `--dry-run` to any publish command to preview it without uploading. The dry run works without logging in.

For a new release, bump `--version` (semver) and give a new `--changelog`.
