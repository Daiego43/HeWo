#!/usr/bin/env bash
# install_user_units.sh  (run without sudo)

set -euo pipefail
[[ $EUID -ne 0 ]] || { echo "Do not run this script as root"; exit 1; }

unit_dir="$HOME/.config/systemd/user"
mkdir -p "$unit_dir"

install_unit () {
  local template=$1 target=$2
  sed "s|__USER__|$USER|g" "$template" > "$unit_dir/$target"
  echo "· Copied $target"
}

echo "Installing user units for $USER…"

install_unit xhost.service.template      xhost.service
# install_unit hewo_face.service.template  hewo_face.service

systemctl --user daemon-reload
systemctl --user enable --now xhost.service # hewo_face.service

echo "✅  User units enabled."
