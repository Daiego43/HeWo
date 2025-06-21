#!/usr/bin/env bash
set -euo pipefail

# --- Parámetros del hotspot --------------------------------------------------
AP_IF="wlx5091e31c4790"           # interfaz Wi-Fi dedicada al AP
AP_SSID=$(hostname)               # SSID (usa el hostname)
AP_PASS="lattepanda"              # contraseña
HOTSPOT_CONN="lattepanda"         # nombre de la conexión NM para el hotspot
# ---------------------------------------------------------------------------

# Cuánto tiempo damos a NetworkManager para autoconectarse a redes conocidas
WAIT_SECS=15          # total
CHECK_INTERVAL=3      # cada cuánto comprobamos

# --- Funciones auxiliares ----------------------------------------------------
have_nmcli()        { command -v nmcli &>/dev/null; }
interface_connected() {
  # Sale con 0 si $AP_IF ya está asociado como cliente
  nmcli -t -f DEVICE,STATE device status | grep -q "^${AP_IF}:connected$"
}

# ---------------------------------------------------------------------------

# 1) nmcli disponible
if ! have_nmcli; then
  echo "❌ 'nmcli' no está instalado. Instálalo con: sudo apt install network-manager"
  exit 1
fi

# 2) NetworkManager corriendo
if ! systemctl is-active --quiet NetworkManager; then
  echo "⚠️  NetworkManager no está activo. Iniciándolo..."
  sudo systemctl start NetworkManager
fi

# 3) Wi-Fi habilitado
if nmcli -t -f WIFI g | grep -q "disabled"; then
  echo "⚠️  Wi-Fi está deshabilitado. Habilitándolo..."
  nmcli radio wifi on
fi

# 4) Interfaz existe
if ! nmcli device show "$AP_IF" &>/dev/null; then
  echo "❌ Interfaz $AP_IF no encontrada"
  exit 1
fi

# 5) Damos unos segundos a NM para que se asocie a redes conocidas
echo "⏳ Esperando a que NetworkManager se conecte a Wi-Fi conocido ($WAIT_SECS s máx.)…"
for ((t=0; t<WAIT_SECS; t+=CHECK_INTERVAL)); do
  if interface_connected; then
    echo "✅ ${AP_IF} ya está conectado a Wi-Fi. No se lanza hotspot."
    exit 0
  fi
  sleep "$CHECK_INTERVAL"
done
echo "🚫 No se encontró Wi-Fi conocido. Se creará hotspot."

# 6) Eliminamos hotspot previo, si existe
if nmcli connection show --active | grep -q "$HOTSPOT_CONN"; then
  nmcli connection down   "$HOTSPOT_CONN" || true
fi
if nmcli connection show | grep -q "$HOTSPOT_CONN"; then
  nmcli connection delete "$HOTSPOT_CONN" || true
fi

# 7) Creamos y arrancamos el hotspot
echo "🚀 Lanzando hotspot '$HOTSPOT_CONN' en $AP_IF..."
nmcli device wifi hotspot \
      ifname   "$AP_IF" \
      con-name "$HOTSPOT_CONN" \
      ssid     "$AP_SSID" \
      password "$AP_PASS"  >/dev/null

echo "✅ Hotspot activo: SSID = $AP_SSID | PASS = $AP_PASS"
