FROM jlesage/baseimage-gui:ubuntu-24.04-v4 AS build

MAINTAINER Bjoern Gruening, bjoern.gruening@gmail.com

RUN apt-get update -y && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
         ca-certificates \
         wget \
         libgl1 \
         qt5dxcb-plugin && \
     rm -rf /var/lib/apt/lists/*

COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh && \
    mkdir -p /app/odv

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/usegalaxy-eu/docker-pretextview/raw/main/logo.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Set the name of the application.
ENV APP_NAME="PretextView"

ENV KEEP_APP_RUNNING=0

ENV TAKE_CONFIG_OWNERSHIP=1

# Set environment

WORKDIR /app/
RUN wget https://github.com/sanger-tol/PretextView/releases/download/1.0.3/PretextViewAI-1.0.3-Linux-x86_64.deb && \
    dpkg -i PretextViewAI-1.0.3-Linux-x86_64.deb && \
    rm PretextViewAI-1.0.3-Linux-x86_64.deb

WORKDIR /config
