#!/usr/bin/env bash

# Use rofi to pick a Wi-Fi network and connect with nmcli

# Get list of available Wi-Fi networks
wifi_list=$(nmcli -t -f SSID,SIGNAL dev wifi list | awk -F: '!seen[$1]++ {printf "%-30s %s%%\n", $1, $2}')

# Show in rofi
chosen=$(echo "$wifi_list" | rofi -dmenu -p "WiFi SSID" | awk '{print $1}')

# Exit if nothing chosen
[ -z "$chosen" ] && exit 0

# Try to connect
nmcli dev wifi connect "$chosen" || {
    # If connection needs password
    pass=$(rofi -dmenu -password -p "Password for $chosen")
    nmcli dev wifi connect "$chosen" password "$pass"
}
