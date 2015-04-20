#!/bin/bash

set -e;

bold=`tput bold`;
normal=`tput sgr0`;
clear;

TEST_DIR=$1;

echo "idol.sh";
echo "";

echo "${bold}			CURRENT IDOLS	${normal}";
echo "";

if [ ! "$(ls -A /$1)" ]; then
	echo "  NO IDOLS  ";
else
	printf "${bold}%-15s | %-15s | %-15s | %-15s\n " "  IDOL" "OS" "DATE" "AUTHOR";
	echo "${normal}------------------------------------------------------------";

	available=(`ls -1 ${TEST_DIR}`);
	for i in ${available[@]}; do
	    IDOLNAME=$(grep "NAME" ${TEST_DIR}/${i}/README.txt | awk -F':' '{ print $2 }');
		IDOLOS=$(grep "OS:" ${TEST_DIR}/${i}/README.txt | awk -F':' '{ print $2 }');
		IDOLDATE=$(grep "DATE" ${TEST_DIR}/${i}/README.txt | awk -F':' '{ print $2 }');
		IDOLAUTHOR=$(grep "AUTHOR" ${TEST_DIR}/${i}/README.txt | awk -F':' '{ print $2 }');

		printf "%-15s | %-15s | %-15s | %-15s\n" "  "${IDOLNAME} ${IDOLOS} ${IDOLDATE} ${IDOLAUTHOR};
	done
fi
echo "";

#Output list of current golden images
