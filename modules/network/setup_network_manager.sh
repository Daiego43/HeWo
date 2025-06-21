# Install ROS services
mkdir -p ~/.config/systemd/user/
sudo cp wifi_hotspot.service /etc/systemd/system/wifi_hotspot.service
sudo systemctl enable wifi_hotspot.service