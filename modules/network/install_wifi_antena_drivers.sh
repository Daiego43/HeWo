#!/bin/bash
set -e

echo "🔍 Checking for required packages..."
sudo apt update
sudo apt install -y dkms git build-essential

echo "📥 Cloning RTL8821AU driver..."
git clone https://github.com/morrownr/8821au-20210708 /tmp/rtl8821au-driver

echo "🛠️ Installing driver via DKMS..."
cd /tmp/rtl8821au-driver
sudo ./install-driver.sh

echo "📦 Forcing module load..."
sudo modprobe 8821au

echo "✅ Driver installed. Checking for new interfaces..."
ip link show | grep wl

echo "🧹 Cleaning up..."
rm -rf /tmp/rtl8821au-driver

echo "🚀 Done! Your adapter should now be ready."
