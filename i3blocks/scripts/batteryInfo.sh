info=$(upower -b)


CHARGINGCOLOR="#6dde16"
WARNINGCOLOR="#debd16"
CRITICALCOLOR="#de4f16"
NORMALCOLOR="#ffffff"

CHARGING="󱐋"
PLUGGEDIN="󰚥"
CRITICAL="󰂃"
BATTERY10="󰁺"
BATTERY20="󰁻"
BATTERY30="󰁼"
BATTERY40="󰁽"
BATTERY50="󰁾"
BATTERY60="󰁿"
BATTERY70="󰂀"
BATTERY80="󰂁"
BATTERY90="󰂂"
BATTERY100="󰁹"

function FormatText(){
  local percent=$1
  local status=$2
  local time=$3

  local numberPercent=${percent%\%}

  local statusIcon
  local batteryIcon=$BATTERY100
  local color=$NORMALCOLOR
  if [[ $status == "pending-charge" ]];then
	 statusIcon=$PLUGGEDIN
  elif [[ $status == "charging" ]]; then
	 statusIcon=$CHARGING
	 color=$CHARGINGCOLOR
  elif (( $numberPercent < 10));then
	 color=$CRITICALCOLOR
  elif (( $numberPercent < 25));then
	 textColor=$WARNINGCOLOR
  fi

   if (( numberPercent < 5 )); then
	  batteryIcon=$CRITICAL
	elif (( numberPercent < 20 ));then
	  batteryIcon=$BATTERY10
	elif (( numberPercent < 30 ));then
	  batteryIcon=$BATTERY20
	elif (( numberPercent < 40 ));then
	  batteryIcon=$BATTERY30
	elif (( numberPercent < 50 ));then
	  batteryIcon=$BATTERY40
	elif (( numberPercent < 60 ));then
	  batteryIcon=$BATTERY50
	elif (( numberPercent < 70 ));then
	  batteryIcon=$BATTERY60
	elif (( numberPercent < 80 ));then
	  batteryIcon=$BATTERY70
	elif (( numberPercent < 90 ));then
	  batteryIcon=$BATTERY90
	elif (( numberPercent < 100 ));then
	  batteryIcon=$BATTERY90
	else
	  batteryIcon=$BATTERY100
	fi

	echo "<span color=\"$color\">$statusIcon $batteryIcon $percent $time</span>"

}

# function PrintText(){
#   local text=$1
#   local color=$2
#
#   echo "$text"
#
#   local numberPercent=${percent%\%}
#   local ICON="<span color=$NORMALCOLOR>$BATTERY100</span>"
#   local TEXT="<span color=$NORMALCOLOR>$status</span>"
#
#   if numberPercent -lt 10;then
# 	 local ICON="<span color=$NORMALCOLOR>$BATTERY100</span>"
#
# }

val=$( echo "$info" | awk -F: '
/percentage/ {
gsub(/ /,"",$2);p=$2
}
/time/ {
gsub(/^[\t]+/,"",$2);
split($2,arr," ");
split(arr[1],arr,".");
t="("arr[1]"."arr[2]"_hours)"
}
/state/ {
gsub(/ /,"",$2);s=$2
}
END {
  print p" "s" "t
}
' )

FormatText $val
