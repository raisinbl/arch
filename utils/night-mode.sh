#!/usr/bin/env bash
if pidof wlsunset; then
	makoctl dismiss -a
	notify-send "Night Mode Off"
	killall wlsunset
else
	makoctl dismiss -a
	notify-send "Night Mode On"
	wlsunset -l 21.0 -L 105.8 
fi
