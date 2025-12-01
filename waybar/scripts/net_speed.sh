#!/bin/bash

# Detect active interface (ignores loopback)
IFACE=$(ip route | grep '^default' | awk '{print $5}')

# If no interface, show no-internet icon
if [ -z "$IFACE" ]; then
    echo '{"text":"󰯡","tooltip":"No Internet"}'
    exit
fi

# Detect SSID (for Wi-Fi), fallback to "Ethernet" if not Wi-Fi
SSID=$(iwgetid -r 2>/dev/null)
if [ -z "$SSID" ]; then
    if [[ "$IFACE" == e* ]]; then
        SSID="Ethernet"
    else
        SSID="$IFACE"
    fi
fi

# Measure bytes
RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null)
TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null)
sleep 1
RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null)
TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null)

RXBPS=$((RX2 - RX1))
TXBPS=$((TX2 - TX1))

# Function to convert to human-readable format
human_readable() {
    local BYTES=$1
    local KB=$(echo "$BYTES / 1024" | bc)
    local MB=$(echo "scale=1; $BYTES / 1048576" | bc)

    if [ "$KB" -lt 1024 ]; then
        echo "${KB}KB/s"
    else
        echo "${MB}MB/s"
    fi
}

RX_HR=$(human_readable $RXBPS)
TX_HR=$(human_readable $TXBPS)

# Show speeds in bar, SSID in tooltip
echo "{\"text\":\" $TX_HR   $RX_HR\",\"tooltip\":\"Connected: $SSID\"}"
