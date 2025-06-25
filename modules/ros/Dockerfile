FROM ros:jazzy
LABEL maintainer="daiego43"
# ── Paquetes base del sistema ─────────────────────────────────
RUN apt-get update && apt-get install -y \
    python3-pip \
    libgl1 libglib2.0-0 \
    x11-utils x11-xserver-utils libxrandr-dev \
    ffmpeg terminator \
    ros-jazzy-cv-bridge

# ── Using ubuntu user to pip install --user ───────────────
USER ubuntu
ENV PATH="/home/ubuntu/.local/bin:${PATH}"
ENV PYTHONPATH="/home/ubuntu/.local/lib/python3.12/site-packages:${PYTHONPATH}"

RUN echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc
RUN python3 -m pip install --break-system-packages hewo-face
