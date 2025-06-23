FROM ros:jazzy
LABEL maintainer="daiego43"
ARG user=hewo
# ── Paquetes base del sistema ─────────────────────────────────
RUN apt-get update && apt-get install -y \
    python3-pip \
    libgl1 libglib2.0-0 \
    x11-utils x11-xserver-utils libxrandr-dev \
    ffmpeg terminator \
    ros-jazzy-cv-bridge

# ── Crea un usuario normal para usar pip --user ───────────────
RUN useradd -m $user
USER $user
ENV PATH="/home/hewo/.local/bin:${PATH}"
ENV PYTHONPATH="/home/hewo/.local/lib/python3.12/site-packages:${PYTHONPATH}"
RUN python3 -m pip install --user --break-system-packages -U hewo-face

