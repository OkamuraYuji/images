FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app/data

# Update and install basic dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        unzip \
        zip \
        tar \
        jq \
        wget && \
    rm -rf /var/lib/apt/lists/*

# Enable 32-bit support & install required 32-bit libraries (only for x86_64)
RUN if [ "$(dpkg --print-architecture)" = "amd64" ]; then \
        dpkg --add-architecture i386 && \
        apt update && \
        apt install -y --no-install-recommends \
            lib32gcc-s1 \
            libsdl2-2.0-0:i386 && \
        rm -rf /var/lib/apt/lists/*; \
    fi

CMD sh -c "$START"
