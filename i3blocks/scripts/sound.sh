#!/bin/bash

MIC=" "
HEADSET="󰋎 "
MUTEMIC="󰍭 "
HEADPHONE="󰋋 "
SPEAKER="󰓃 "
NOSPEAKER="󰓄 "
MUTESPEAKER="󰝟 "


SOURCE_VOL=$(pactl -f json get-source-volume @DEFAULT_SOURCE@ | jq '.volume | .["front-left"] | .value_percent | .[0:-1] | tonumber')
SINK_VOL=$(pactl -f json get-sink-volume @DEFAULT_SINK@ | jq '.volume | .["front-left"] | .value_percent | .[0:-1] | tonumber')

echo "<span color=\"#786531\">$SINK_VOL $SOURCE_VOL</span>"
