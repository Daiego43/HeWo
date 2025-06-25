#!/usr/bin/env bash
# Install SYSTEMD *system* units into /etc/systemd/system
# Usage: sudo ./install_system_units.sh <user>

set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "Run this script with sudo"; exit 1; }
user=${1:? "Missing <user> argument"}

install_unit () {
  local template=$1 target=$2
  sed "s|__USER__|$user|g" "$template" > "/etc/systemd/system/$target"
  echo "· Installed $target"
}

echo "Installing system units for $user…"

install_unit wifi_hotspot.service.template  wifi_hotspot.service
# add more install_unit lines here if you need additional units

systemctl daemon-reload
systemctl enable --now wifi_hotspot.service
systemctl restart avahi_daemon.service

echo "✅  System units enabled."
