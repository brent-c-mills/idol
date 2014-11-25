#!/bin/bash

set -e;

bold=`tput bold`;
normal=`tput sgr0`;
clear;

TEST_DIR=$1;

echo "idol.sh";
echo "";

echo "${bold}	CURRENT IDOLS	${normal}";
echo "";

if [ ! "$(ls -A /$1)" ]; then
	echo "  NO IDOLS  ";
else
	available=$(ls -1 ${TEST_DIR});
	for i in available[@]; do
	    echo "  "$available;
	done
fi
echo "";

#Output list of current golden images

