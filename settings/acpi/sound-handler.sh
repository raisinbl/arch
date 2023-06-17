#!/bin/bash

# Get current mute status
mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

case "$1" in
	button/volumeup)
    #OLUP)	
        # Volume Up button event	
	# Get current mute status
	mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
	# Check if currently muted
	if echo "$mute_status" | grep -qi "MUTE"; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 fi
	# Volume up
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
	;;

	button/volumedown)
    #VOLDN)
        # Volume Down button event
	# Get current mute status
	mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
        # Check if currently muted
	if echo "$mute_status" | grep -qi "MUTE"; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 fi
	# Volume down
	wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
	;;

	button/mute)
    #MUTE)
        # Mute/Unmute the volume event
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;

	button/f20)
    #F20)
        # Mute/Unmute the microphone event
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        ;;
    *)
        # Unknown event
        echo "Unhandled button event: $1"
        ;;
esac

# vim:set ts=4 sw ft=sh et:
