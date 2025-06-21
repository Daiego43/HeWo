#!/bin/bash

set -e

echo "[+] Actualizando sistema..."
sudo apt update && sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "[+] Añadiendo clave GPG oficial de Docker..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "[+] Añadiendo repositorio de Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[+] Instalando Docker Engine..."
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[+] Añadiendo el usuario actual al grupo docker..."
sudo usermod -aG docker $USER

echo "[+] Docker instalado. Reinicia la sesión para usar Docker sin sudo."
