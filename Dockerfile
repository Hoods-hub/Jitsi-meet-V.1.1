FROM debian:bullseye

LABEL maintainer="you@example.com"
ARG DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt-get update && apt-get install -y \
    nginx \
    openjdk-11-jre-headless \
    prosody \
    supervisor \
    curl \
    net-tools \
    gnupg2 \
    ca-certificates \
    git \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Jitsi services (adjust folders)
COPY ./web /usr/share/jitsi-meet
COPY ./jicofo /srv/jicofo
COPY ./jvb /srv/jvb
COPY ./prosody /srv/prosody

# NGINX and supervisor configs
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443 5347 5222 10000/udp

# Environment setup
ENV CONFIG=/config \
    HTTP_PORT=8000 \
    HTTPS_PORT=8443 \
    TZ=UTC \
    PUBLIC_URL=https://jitsi-meet-v-1-1.onrender.com \
    ENABLE_LETSENCRYPT=0 \
    DISABLE_HTTPS=1 \
    ENABLE_AUTH=0 \
    JITSI_IMAGE_VERSION=stable-9387 \
    XMPP_DOMAIN=meet.jitsi

CMD ["/usr/bin/supervisord", "-n"]
