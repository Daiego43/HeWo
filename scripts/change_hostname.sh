#!/usr/bin/env bash
#
#  change-hostname.sh  ─ Changes the hostname on Linux systems using systemd
#
#  Usage:   sudo ./change-hostname.sh  NEW_HOSTNAME
#
set -euo pipefail

# ─────────────── 1) Basic checks ────────────────────────────────
if [[ $EUID -ne 0 ]]; then
  echo "❌  You must run this script as root (use sudo)." >&2
  exit 1
fi

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 NEW_HOSTNAME" >&2
  exit 1
fi

NEW_HOST="$1"

# Validate name: letters, numbers, dashes and ≤ 63 characters
if ! [[ $NEW_HOST =~ ^[a-zA-Z0-9-]{1,63}$ ]]; then
  echo "❌  Invalid hostname: «$NEW_HOST»" >&2
  exit 1
fi

CURRENT_HOST=$(hostnamectl --static status | awk '{print $1}')

if [[ $NEW_HOST == "$CURRENT_HOST" ]]; then
  echo "✅  Hostname is already «$NEW_HOST». Nothing to do."
  exit 0
fi

echo "🔄  Changing hostname from «$CURRENT_HOST» to «$NEW_HOST»…"

# ─────────────── 2) Set with hostnamectl ─────────────────────────
hostnamectl set-hostname "$NEW_HOST"

# ─────────────── 3) Update /etc/hosts ────────────────────────────
#  Replace the line with the old hostname in 127.0.1.1
if grep -qE "^127\.0\.1\.1\s+" /etc/hosts; then
  sed -Ei "s/^127\.0\.1\.1\s+.*/127.0.1.1\t$NEW_HOST/" /etc/hosts
else
  echo -e "127.0.1.1\t$NEW_HOST" >> /etc/hosts
fi

# ─────────────── 4) Show result ──────────────────────────────────
echo "✔️  Hostname changed. Result:"
hostnamectl
echo
echo "ℹ️  The new name will be visible in all new terminals. Please restart your system to apply it everywhere."
