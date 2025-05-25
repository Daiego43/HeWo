FROM ubuntu:latest
LABEL authors="daiego"
LABEL description="A Dockerfile and Compose configuration tu run this image with apropriate container settings"

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    libgl1 \
    libglib2.0-0

RUN apt-get update && apt-get install -y \
    x11-utils \
    x11-xserver-utils \
    libxrandr-dev

RUN apt-get update && apt-get install ffmpeg -y

# Install dependencies
COPY ./HeWo /app/HeWo

WORKDIR /app
RUN python3 -m venv venv && . venv/bin/activate && \
    cd HeWo && pip install .

WORKDIR /app