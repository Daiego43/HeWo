#!/usr/bin/env bash
set -e
# Load conda into this shell manually
source ~/miniconda3/etc/profile.d/conda.sh
conda activate hewo-ros
rm -rf build install log
conda deactivate
colcon build --symlink-install
conda activate hewo-ros
python3 postbuild.py
