#!/usr/bin/env bash
# Install SYSTEMD user units under ~/.config/systemd/user
# Usage: ./install_user_units.sh   (run *without* sudo)

set -euo pipefail
[[ $EUID -ne 0 ]] || { echo "Do not run this script as root"; exit 1; }

user_unit_dir="$HOME/.config/systemd/user"
mkdir -p "$user_unit_dir"

install_unit () {
  local template=$1 target=$2
  sed "s|__USER__|$USER|g" "$template" > "$user_unit_dir/$target"
  echo "· Copied $target"
}

echo "Installing user units for $USER…"

install_unit hewo_face.service.template  hewo_face.service
# add more install_unit lines here if you need additional units

systemctl --user daemon-reload
systemctl --user enable --now hewo_face.service   # starts immediately if a session is active
echo "✅  User units enabled."
