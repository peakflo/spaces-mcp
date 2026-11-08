# Spaces by Peakflo for Hermes Agent

**Hand off repetitive work to the cloud. An agent or a human gets it done.**

This is a [Portable Agent Plugin](https://agent-plugins.org) package for [Hermes Agent](https://hermes-agent.nousresearch.com). It connects Hermes to Spaces by Peakflo, a hosted MCP server for finance and operations teams, and adds the `peakflo-spaces:spaces` skill.

With it, Hermes can:

- hand off a one-off or recurring (cron) task to a cloud agent or a person, and return a link to follow it;
- list your workflows and their recent runs;
- query your data tables with read-only SQL;
- pull aggregated reports on bills, invoices, payables and receivables;
- search your Business Context documents, such as policies;
- show your pending approvals.

## Install

You need Hermes Agent 0.21.6 or newer, and Node.js 20.18.1 or newer with `npx` on your `PATH`.

From the Hermes plugin catalog:

```bash
hermes plugins install peakflo-spaces
hermes plugins enable peakflo-spaces
```

Or straight from GitHub:

```bash
hermes plugins install peakflo/spaces-mcp/hermes --no-enable
hermes plugins enable peakflo-spaces
```

Start a new session. The first time the server starts, your browser opens app.peakflo.ai. Sign up or sign in, pick your workspace and click **Allow access**. There are no API keys. The token is kept and refreshed, so you sign in once. If the tools don't show up after you sign in, run `/reload-mcp`.

## Before you install

The package is `plugin.json`, `mcp.json` and the skill in `skills/spaces/`. It ships no code of its own.

- `mcp.json` runs the pinned `mcp-remote@0.1.49` through `npx`, which downloads it from npm on first use. It opens a local callback port for the sign-in and stores the OAuth tokens in `~/.mcp-auth`.
- Every tool call goes to `api.peakflo.ai` and acts on your Spaces workspace with your own role and permissions. The server decides the tool set at runtime, so the pinned commit doesn't cover it.
- `plugin.json` marks the server `untrusted`. Hermes asks before every tool the server doesn't mark read-only (creating tasks, running workflows, completing approvals, writing data, calling connected apps), and refuses those tools in cron and other unattended runs.
- Spaces doesn't move money, make payments or trade. Creating a task queues work; it doesn't mean the work is done.
- The package sends no telemetry.

## Disconnect

Revoke access at any time in app.peakflo.ai → **Settings → MCP → Connected apps**, then run `hermes plugins disable peakflo-spaces` and delete the matching entry in `~/.mcp-auth`.

## Links

- Website: https://spaces.peakflo.ai · Docs: https://spaces.peakflo.ai/docs/mcp/
- [Privacy policy](https://help.peakflo.co/peakflo-privacy-policy) · [Terms](https://help.peakflo.co/terms-and-conditions)
- Support: https://help.peakflo.co · support@peakflo.co
