#!/bin/bash

set -e

RULES_PATH="/etc/udev/rules.d/network-link-name.rules"

if [[ ! -f "$RULES_PATH" ]]; then
    echo "❌ La regla $RULES_PATH no existe. Asegúrate de haberla creado correctamente."
    exit 1
fi

echo "📦 Recargando reglas de udev..."
sudo udevadm control --reload

echo "⚡ Aplicando reglas de red..."
sudo udevadm trigger --subsystem-match=net

echo "✅ Regla udev aplicada. Si no ves el nuevo nombre, prueba a reiniciar: sudo reboot"
