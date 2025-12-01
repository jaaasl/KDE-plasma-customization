#!/bin/bash

# Get current desktop number (1-based)
current=$(qdbus org.kde.KWin /KWin currentDesktop)

# Total number of desktops
total=$(qdbus org.kde.KWin /KWin numberOfDesktops)

# Build display string, e.g. [1][2][3][4]
output=""
for i in $(seq 1 $total); do
    if [ "$i" -eq "$current" ]; then
        output+="[$i]"      # Highlight current desktop
    else
        output+="$i"
    fi
done

# Output JSON for Waybar
echo "{\"text\":\"$output\",\"tooltip\":\"Click to switch desktops\"}"
