FROM ros:jazzy
LABEL authors="daiego43"

# ── Base dependencies ─────────────────────────────
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    libgl1 \
    libglib2.0-0 \
    x11-utils \
    x11-xserver-utils \
    libxrandr-dev \
    ffmpeg \
    terminator

# ROS
RUN apt update && \
    apt install -y ros-jazzy-cv-bridge

# Python
# RUN pip install hewo-face --break-system-packages # ROS2 is problematic

COPY ros2_ws /ros2_ws