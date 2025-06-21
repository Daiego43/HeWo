# Install Wifi hotspot service
user=$1
echo $user
sed "s|__USER__|$user|g" wifi_hotspot.service.template |
  sudo tee /etc/systemd/system/wifi_hotspot.service >/dev/null
sudo systemctl daemon-reload
sudo systemctl start wifi_hotspot.service
sudo systemctl enable wifi_hotspot.service