#!/bin/bash

case "$1" in
    video/brightnessdown)
	brightnessctl set 10%-
        ;;
    video/brightnessup)
	brightnessctl set 10%+
        ;;
    *)
        # Unknown event
        echo "Unhandled sound event: $event"
        ;;
esac
