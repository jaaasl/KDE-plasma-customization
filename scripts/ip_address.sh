#!/bin/bash

# Detect active interface
IFACE=$(ip route | grep '^default' | awk '{print $5}')

if [ -z "$IFACE" ]; then
    echo '{"text":"No IP","tooltip":"No active connection"}'
    exit
fi

# Get IPv4 address
IP=$(ip -4 addr show "$IFACE" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)

if [ -z "$IP" ]; then
    echo "{\"text\":\"No IP\",\"tooltip\":\"Interface: $IFACE (No address)\"}"
else
    echo "{\"text\":\"$IP\",\"tooltip\":\"Interface: $IFACE\nAddress: $IP\"}"
fi
