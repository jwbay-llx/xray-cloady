# Xray-core (VLESS + WebSocket) for Cloady free tier.
# The container generates /etc/xray/config.json at start from env vars:
#   UUID (required, set as a secret in the Cloady dashboard)
#   PORT (default 3000; Cloady serves the app on this port)
#   WS_PATH (default /ray)
FROM alpine:3.21

RUN apk add --no-cache ca-certificates curl unzip \
 && curl -fsSL -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
 && unzip -o /tmp/xray.zip -d /usr/local/bin/ \
 && chmod +x /usr/local/bin/xray \
 && rm -f /tmp/xray.zip \
 && mkdir -p /etc/xray

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
