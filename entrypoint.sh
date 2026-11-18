#!/bin/sh
# Generate Xray config from environment variables and start xray.
#   UUID (required) - VLESS client id, set as a secret in Cloady
#   PORT (default 3000) - port Cloady routes the app's HTTPS endpoint to
#   WS_PATH (default /ray) - WebSocket path
set -eu

PORT="${PORT:-3000}"
WS_PATH="${WS_PATH:-/ray}"

if [ -z "${UUID:-}" ]; then
  echo "error: UUID environment variable is not set" >&2
  exit 1
fi

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF

echo "starting xray on port ${PORT} (ws path ${WS_PATH})"
exec /usr/local/bin/xray run -config /etc/xray/config.json
