#!/usr/bin/env bash
# Build the OpenAI plugin ZIP (ChatGPT + Codex directory).
# Usage: ./build.sh "https://www.youtube.com/watch?v=..." [--discovery-auth]
#   --discovery-auth  omit the OpenAI auth block from mcp.json (strict Agent
#                     Plugins schema); ChatGPT then finds DCR via OAuth discovery.
set -euo pipefail
cd "$(dirname "$0")"
url="${1:?usage: ./build.sh <demo-video-url>}"
case "$url" in https://*) ;; *) echo "demo URL must be https" >&2; exit 1;; esac
out="$(pwd)/../dist"; rm -rf "$out/pkg"; mkdir -p "$out/pkg/assets"
python3 - "$url" "$out/pkg/plugin.json" <<'PY'
import json, sys
url, dest = sys.argv[1], sys.argv[2]
d = json.load(open('plugin.json'))
d['extensions']['com.openai']['review']['demo_recording_url'] = url
json.dump(d, open(dest, 'w'), indent=2, ensure_ascii=False)
PY
if [ "${2:-}" = "--discovery-auth" ]; then
  python3 - "$out/pkg/mcp.json" <<'PY'
import json, sys
d = json.load(open('mcp.json'))
for server in d['mcpServers'].values():
    server.pop('extensions', None)
json.dump(d, open(sys.argv[1], 'w'), indent=2)
PY
else
  cp mcp.json "$out/pkg/"
fi
cp assets/*.png "$out/pkg/assets/"
(cd "$out/pkg" && rm -f ../peakflo-spaces-openai-plugin.zip && zip -qr ../peakflo-spaces-openai-plugin.zip .)
echo "Built $out/peakflo-spaces-openai-plugin.zip"; unzip -l "$out/peakflo-spaces-openai-plugin.zip"
