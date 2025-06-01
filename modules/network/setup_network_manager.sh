# Install ROS services
mkdir -p ~/.config/systemd/user/
cp wifi_hotspot.service ~/.config/systemd/user
systemctl --user enable wifi_hotspot.service