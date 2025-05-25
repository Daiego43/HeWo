#!/usr/bin/env bash
set -euo pipefail

AP_IF="wlp1s0"
AP_SSID=$(hostname)
AP_PASS="lattepanda"
HOTSPOT_CONN="lattepanda"

# 1) Check if Wi-Fi is enabled
if nmcli -t -f WIFI g | grep -q "disabled"; then
  echo "⚠️ Wi-Fi is disabled"
  exit 1
fi

# 2) Check interface existence
if ! nmcli device show "$AP_IF" &>/dev/null; then
  echo "❌ Interface $AP_IF not found"
  exit 1
fi

# 3) Take down and delete any previous hotspot
if nmcli connection show --active | grep -q "$HOTSPOT_CONN"; then
  nmcli connection down "$HOTSPOT_CONN"
fi
if nmcli connection show | grep -q "$HOTSPOT_CONN"; then
  nmcli connection delete "$HOTSPOT_CONN"
fi

# 4) Create and launch hotspot
echo "🚀 Starting hotspot $HOTSPOT_CONN on $AP_IF..."
nmcli device wifi hotspot ifname "$AP_IF" con-name "$HOTSPOT_CONN" ssid "$AP_SSID" password "$AP_PASS" >/dev/null

echo "Hotspot up"
