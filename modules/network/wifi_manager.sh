#!/usr/bin/env bash
set -euo pipefail

# --- Hotspot parameters ------------------------------------------------------
AP_IF="wlx5091e31c4790"           # Wi-Fi interface for the AP
AP_SSID=$(hostname)               # SSID (default: system hostname)
AP_PASS="lattepanda"              # hotspot password
HOTSPOT_CONN="lattepanda"         # NetworkManager connection name
# ---------------------------------------------------------------------------

# How long we give NetworkManager to auto-connect to a known network
WAIT_SECS=15          # total seconds
CHECK_INTERVAL=3      # polling interval

# --- Helper functions --------------------------------------------------------
have_nmcli()        { command -v nmcli &>/dev/null; }
interface_connected() {
  # Returns 0 if $AP_IF is already connected as a client
  nmcli -t -f DEVICE,STATE device status | grep -q "^${AP_IF}:connected$"
}
# ---------------------------------------------------------------------------

# 1) nmcli available?
if ! have_nmcli; then
  echo "❌ 'nmcli' is not installed. Install it with: sudo apt install network-manager"
  exit 1
fi

# 2) Ensure NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
  echo "⚠️  NetworkManager is not running. Starting it..."
  sudo systemctl start NetworkManager
fi

# 3) Ensure Wi-Fi is enabled
if nmcli -t -f WIFI g | grep -q "disabled"; then
  echo "⚠️  Wi-Fi is disabled. Enabling it..."
  nmcli radio wifi on
fi

# 4) Check that the interface exists
if ! nmcli device show "$AP_IF" &>/dev/null; then
  echo "❌ Interface $AP_IF not found"
  exit 1
fi

# 5) Give NM a few seconds to join a known network
echo "⏳ Waiting up to $WAIT_SECS s for NetworkManager to connect to a known Wi-Fi…"
for ((t=0; t<WAIT_SECS; t+=CHECK_INTERVAL)); do
  if interface_connected; then
    echo "✅ ${AP_IF} is already connected to Wi-Fi. Hotspot will not be started."
    exit 0
  fi
  sleep "$CHECK_INTERVAL"
done
echo "🚫 No known Wi-Fi found. A hotspot will be created."

# 6) Tear down any previous hotspot
if nmcli connection show --active | grep -q "$HOTSPOT_CONN"; then
  nmcli connection down   "$HOTSPOT_CONN" || true
fi
if nmcli connection show | grep -q "$HOTSPOT_CONN"; then
  nmcli connection delete "$HOTSPOT_CONN" || true
fi

# 7) Create and launch the hotspot
echo "🚀 Launching hotspot '$HOTSPOT_CONN' on $AP_IF..."
nmcli device wifi hotspot \
      ifname   "$AP_IF" \
      con-name "$HOTSPOT_CONN" \
      ssid     "$AP_SSID" \
      password "$AP_PASS"  >/dev/null

echo "✅ Hotspot active: SSID = $AP_SSID | PASS = $AP_PASS"
