# ICONS
LIMITED="󱛅 "
PORTAL="󱚼 "
QUESTION=""
FULL="󰖩 "
NO="󰖪 "

ACTIVECONNECTION=$(nmcli -t connection show --active) 
STATE=$(nmcli -t networking connectivity)
SIGNALSTRINCLUDED=$(nmcli -t device wifi list --rescan no)


SSID=$(echo "$ACTIVECONNECTION" | awk -F: '
/802-11-wireless/ {
  print $1
}
')


if [[ -n $SSID ]];then
  read SPEED SIGNALSTRENGTH <<< $(echo "$SIGNALSTRINCLUDED" | awk ' {gsub (/\\:/,"|");print}' | awk -F: -v ssid="$SSID" '
  $0~ssid {
	 split($6,arr," ")
	 print arr[1]/8" "$7
  }
  ')
fi


COLOR="#eb3434" #red
ICON="$NO"


if [[ $STATE == "full" ]];then
  COLOR="#34eb3a" #green
  ICON="$FULL"
elif [[ $STATE == "unknown" ]];then
  ICON="$QUESTION"
elif [[ $STATE == "limited" ]];then
  ICON="$LIMITED"
elif [[ $STATE == "protal" ]]; then
  ICON="$PORTAL"
fi

TEXT=$ICON
if [[ -n $SSID ]];then
  TEXT="$TEXT $SSID ($SPEED Mb/s, $SIGNALSTRENGTH)"
fi
echo "<span color=\"$COLOR\">$TEXT</span>"
