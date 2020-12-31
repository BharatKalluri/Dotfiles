if [ -f ~/.functions ]; then
    . ~/.functions
fi

# Mute spotify on ad
while sleep 1; do mute_ad_spotify; done &
