FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app/data

RUN apt update && apt install -y zip unzip wget curl libcurl4 openssl libssl3 ca-certificates && \
    cd /app/data && \
    RANDVERSION=$((1 + RANDOM % 4000)) && \
    if [ -z "${BEDROCK_VERSION}" ] || [ "${BEDROCK_VERSION}" = "latest" ]; then \
      echo "Downloading latest Bedrock server..." && \
      curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" \
        -H "Accept-Language: en" -H "Accept-Encoding: gzip, deflate" \
        -o versions.html.gz https://net-secondary.web.minecraft-services.net/api/v1.0/download/links && \
      DOWNLOAD_URL=$(zgrep -o 'https://www.minecraft.net/bedrockdedicatedserver/bin-linux/[^"]*' versions.html.gz); \
    else \
      echo "Downloading version ${BEDROCK_VERSION}..." && \
      DOWNLOAD_URL="https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-${BEDROCK_VERSION}.zip"; \
    fi && \
    DOWNLOAD_FILE=$(basename "$DOWNLOAD_URL") && \
    rm -f *.bak versions.html.gz 2>/dev/null || true && \
    cp server.properties server.properties.bak 2>/dev/null || true && \
    cp permissions.json permissions.json.bak 2>/dev/null || true && \
    cp allowlist.json allowlist.json.bak 2>/dev/null || true && \
    curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" \
      -H "Accept-Language: en" -o "$DOWNLOAD_FILE" "$DOWNLOAD_URL" && \
    unzip -o "$DOWNLOAD_FILE" && \
    rm -f "$DOWNLOAD_FILE" && \
    cp -rf server.properties.bak server.properties 2>/dev/null || true && \
    cp -rf permissions.json.bak permissions.json 2>/dev/null || true && \
    cp -rf allowlist.json.bak allowlist.json 2>/dev/null || true && \
    chmod +x bedrock_server && \
    echo "✅ Install Completed"

CMD sh -c "$START"
