RESET="\e[0m"

RED="\e[1;31m"
LIGHTORANGE="\e[38;2;193;140;1m"
GREEN="\e[1;32m"
LIGHTGREEN="\e[38;2;54;193;1m"
ORANGE="\e[38;2;241;80;47m"

getFirstHalf(){
  COLOR="${1:-\e[1;31m}" 
  printf "$COLOR|$USER $HOSTNAME|$RESET"
}

getSecondHalf(){
DIRCOLOR="${1:-\e[1;32m}" 
GITCOLOR="${2:-\e[1;33m}" 

ISGITDIR=$(git rev-parse --is-inside-work-tree 2> /dev/null)
CURRENTPATH=$(pwd)
CLEANEDPATH=$CURRENTPATH
GITPATH=""
RELATIVEPATH=""
BASEGITPATH=""
SECONDHALF=""
GITBRANCH=""

if [[ $ISGITDIR ]];then
  GITPATH=$( git rev-parse --show-toplevel )
  GITBRANCH=$(git branch --show-current)
  RELATIVEPATH=$(realpath --relative-to=$GITPATH $CURRENTPATH)


  BASEGITPATH=$( basename $GITPATH )
  CLEANEDPATH="${GITPATH%$BASEGITPATH}"
fi

if [[ $CLEANEDPATH == "$HOME"* ]];then
  CLEANEDPATH="~${CLEANEDPATH#$HOME}"
fi

if [[ $ISGITDIR ]];then
  COLOREDGITDIR="${GITCOLOR}󰊢 ${BASEGITPATH}"

  if [[ $RELATIVEPATH == "." ]];then
  SECONDHALF="|${DIRCOLOR}${CLEANEDPATH}${COLOREDGITDIR}|${GITCOLOR}(${GITBRANCH})"
else
  SECONDHALF="|${DIRCOLOR}${CLEANEDPATH}${COLOREDGITDIR}${DIRCOLOR}/${RELATIVEPATH}|${GITCOLOR}(${GITBRANCH})"
  fi
else
  SECONDHALF="|$DIRCOLOR$CLEANEDPATH|"
fi
printf "$SECONDHALF$DIRCOLOR\n\$ $RESET"
}

get_ps1(){
FIRSTHALF=$(getFirstHalf $LIGHTORANGE)
SECONDHALF=$(getSecondHalf $LIGHTGREEN $ORANGE )

printf "%b%b" "$FIRSTHALF""$SECONDHALF"
}

# PS1="$get_ps1" 

PS1='$(get_ps1)' 

