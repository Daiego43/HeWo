# Network
**In case you are using a wifi adapter.**


HeWo's lattepanda uses a wifi adapter and uses [RTL8821AU driver](https://github.com/morrownr/8821au-20210708.git).

## Install driver
Install the driver with the provided script if you need a wifi adapter.
```bash
sudo bash install_RTL8821AU_drivers.sh
```

## wifi_hotspot.service
This service installed will spawn a hotspot in case you don't have wifi connection.
The service makes use of the script `wifi_manager.sh` in this folder