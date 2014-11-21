#!/bin/bash

bold=`tput bold`
normal=`tput sgr0`
clear



echo "idol.sh";
echo "";

echo "${bold}	CURRENT IDOLS	${normal}"
echo "";

[ "$(ls -A /$1)" ] && ls -1 $1 || echo "  NO IDOLS  "
echo "";

#Output list of current golden images

