FROM jlesage/baseimage-gui:ubuntu-24.04-v4

LABEL maintainer="Bjoern Gruening <bjoern.gruening@gmail.com>" \
      org.opencontainers.image.title="PretextView" \
      org.opencontainers.image.source="https://github.com/usegalaxy-eu/docker-pretextview"

ARG PTV_VERSION=1.0.3
ARG PTV_DEB=PretextViewAI-${PTV_VERSION}-Linux-x86_64.deb
ARG PTV_URL=https://github.com/sanger-tol/PretextView/releases/download/${PTV_VERSION}/${PTV_DEB}

RUN apt-get update -y && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
         ca-certificates \
         wget \
         libgl1 && \
     wget https://github.com/sanger-tol/PretextView/releases/download/1.0.3/PretextViewAI-1.0.3-Linux-x86_64.deb && \
     dpkg -i PretextViewAI-1.0.3-Linux-x86_64.deb && \
     rm PretextViewAI-1.0.3-Linux-x86_64.deb && \
     apt-get purge -y --auto-remove curl && \
     rm -rf /var/lib/apt/lists/*

COPY --chmod=0755 startapp.sh /startapp.sh

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/usegalaxy-eu/docker-pretextview/raw/main/logo.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Set the name of the application.
ENV APP_NAME="PretextView" \
    KEEP_APP_RUNNING=0 \
    TAKE_CONFIG_OWNERSHIP=1

WORKDIR /config
