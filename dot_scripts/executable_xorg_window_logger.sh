#!/bin/sh
while true; do
    echo "$(date +%s),$(xprop -id $(xprop -root -f _NET_ACTIVE_WINDOW 0x " \$0\\n" _NET_ACTIVE_WINDOW | awk "{print \$2}") | grep "WM_CLASS(STRING) =" | head -1 | rev | cut -f 1 -d " " | cut -f 2 -d "\"" | rev | tr '[:upper:]' '[:lower:]')" >>~/window.log
    sleep 2
done
