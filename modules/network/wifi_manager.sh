#!/usr/bin/env bash
set -euo pipefail

AP_IF="wlx5091e31c4790"
AP_SSID=$(hostname)
AP_PASS="lattepanda"
HOTSPOT_CONN="lattepanda"

# 1) Check if nmcli is available
if ! command -v nmcli &>/dev/null; then
  echo "❌ 'nmcli' no está instalado. Instálalo con: sudo apt install network-manager"
  exit 1
fi

# 2) Ensure NetworkManager is running
if ! systemctl is-active --quiet NetworkManager; then
  echo "⚠️ NetworkManager no está activo. Iniciándolo..."
  sudo systemctl start NetworkManager
fi

# 3) Check if Wi-Fi is enabled
if nmcli -t -f WIFI g | grep -q "disabled"; then
  echo "⚠️ Wi-Fi está deshabilitado. Habilitándolo..."
  nmcli radio wifi on
fi

# 4) Check interface existence
if ! nmcli device show "$AP_IF" &>/dev/null; then
  echo "❌ Interfaz $AP_IF no encontrada"
  exit 1
fi

# 5) Take down and delete any previous hotspot
if nmcli connection show --active | grep -q "$HOTSPOT_CONN"; then
  nmcli connection down "$HOTSPOT_CONN" || true
fi
if nmcli connection show | grep -q "$HOTSPOT_CONN"; then
  nmcli connection delete "$HOTSPOT_CONN" || true
fi

# 6) Create and launch hotspot
echo "🚀 Lanzando hotspot '$HOTSPOT_CONN' en $AP_IF..."
nmcli device wifi hotspot ifname "$AP_IF" con-name "$HOTSPOT_CONN" ssid "$AP_SSID" password "$AP_PASS" >/dev/null

echo "✅ Hotspot activo: SSID = $AP_SSID | PASS = $AP_PASS"
