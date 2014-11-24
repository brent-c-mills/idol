#!/bin/bash

set -e

create_idol_dir() {
	mkdir $IDOL_DIR;
	mkdir $FULL_BATS;
	mkdir $HASH_BATS;
}

create_idol_readme() {
	echo "IDOL INFORMATION:" >> $IDOL_DIR/README.txt;
	echo "" >> $IDOL_DIR/README.txt;
	echo "Log file.........  " $LOG_OUT >> $IDOL_DIR/README.txt;
	echo "Created on.......  " $NOW >> $IDOL_DIR/README.txt;
	echo "Idol name........  " $IDOL_NAME >> $IDOL_DIR/README.txt;
	echo "Operating System.  " $OPERATING_SYSTEM >> $IDOL_DIR/README.txt;
}

copy_bats_requirements() {
	cp -r $LIB_DIR/fixtures $FULL_BATS/;
	cp -r $LIB_DIR/test_helper.bash $FULL_BATS/;
	cp -r $LIB_DIR/fixtures $HASH_BATS/;
	cp -r $LIB_DIR/test_helper.bash $HASH_BATS/;
}

create_bats_tests(){
	BATS_CATEGORY=( "package" "user" "group" "environment" "hardware" );

	for i in "${BATS_CATEGORY[@]}"
	do
		echo "Generating "$i"-related BATS files for "${IDOL_NAME}"..." | tee -a $LOG_OUT;
		$BIN_DIR/${i}_full_${OPERATING_SYSTEM}.sh $FULL_BATS $IDOL_NAME $LOG_OUT;
		$BIN_DIR/${i}_hash_${OPERATING_SYSTEM}.sh $HASH_BATS $IDOL_NAME $LOG_OUT;
		echo "Finished generating "$i"-related BATS files for "${IDOL_NAME}"..." | tee -a $LOG_OUT;
		echo "";

	done
}

#################################
##         READ INPUT:         ##
#################################

EXPECTED_ARGS=4

if [ $# -ne $EXPECTED_ARGS ]
then
	echo "Something has gone wrong.  The script idol_create.sh expected 4 arguments from idol.sh, but only received "$#".";
	exit 1;
fi

#################################
##        DECLARATIONS:        ##
#################################

OPERATING_SYSTEM=$1;
IDOL_NAME=$2;
BASE_DIR=$3;
LOG_OUT=$4;

NOW=$(date +"%m_%d_%Y_%H%M%S");
BIN_DIR=$BASE_DIR/bin;
LIB_DIR=$BASE_DIR/lib;
TEST_DIR=$BASE_DIR/tests;
MAN_DIR=$BASE_DIR/man;
IDOL_DIR=$TEST_DIR/$IDOL_NAME;
FULL_BATS=$IDOL_DIR/full_bats;
HASH_BATS=$IDOL_DIR/hash_bats;


#################################
##    CREATE IDOL AND BATS     ##
#################################

#CREATING IDOL (BATS TEST DIRECTORY)...

create_idol_dir

#CREATE A IDOL-SPECIFIC README WITH SOME BASIC INFORMATION

create_idol_readme

#COPY NEEDED FILES INTO IDOL DIRECTORY...

copy_bats_requirements

#CREATE BATS TESTS BY CATEGORY

create_bats_tests

