#!/usr/bin/env bash
# Installs user-level units first, then system-wide units.
set -e        # abort on the first error

BASE_DIR="$(cd -- "$(dirname "$0")" && pwd)"   # directory containing this script
USER_NAME="$(id -un)"                         # the current shell user

echo "→ Installing USER services for ${USER_NAME}"
(
  cd "$BASE_DIR/user"
  bash install_user_units.sh "$USER_NAME"
)

echo "→ Installing SYSTEM services (sudo will be requested)"
(
  cd "$BASE_DIR/system"
  sudo bash install_system_units.sh "$USER_NAME"
)

echo "✓ All done"
