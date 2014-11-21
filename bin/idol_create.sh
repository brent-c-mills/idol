#!/bin/bash

#VERIFY CORRECT NUMBER OF ARGUMENTS...

EXPECTED_ARGS=4

if [ $# -ne $EXPECTED_ARGS ]
then
	echo "Something has gone wrong.  The script idol_create.sh expected 4 arguments from idol.sh, but only received "${EXPECTED_ARGS}".";
	exit 7;
fi

#READ ARGUMENTS AND ASSIGN VARIABLE NAMES

OPERATING_SYSTEM=$1;
IDOL_NAME=$2;
BASE_DIR=$3;
LOG_OUT=$4;

#DECLARATIONS

NOW=$(date +"%m_%d_%Y_%H%M%S");
BIN_DIR=$BASE_DIR/bin
LIB_DIR=$BASE_DIR/lib
LOG_DIR=$BASE_DIR/log
TEST_DIR=$BASE_DIR/tests
MAN_DIR=$BASE_DIR/man
IDOL_DIR=$TEST_DIR/$IDOL_NAME

#CREATING IDOL (BATS TEST DIRECTORY)...

mkdir $IDOL_DIR;

#CREATE A IDOL-SPECIFIC README WITH SOME BASIC INFORMATION

echo "IDOL INFORMATION:" >> $IDOL_DIR/README.txt;
echo "" >> $IDOL_DIR/README.txt;
echo "Log file.........  " $LOG_OUT >> $IDOL_DIR/README.txt;
echo "Created on.......  " $NOW >> $IDOL_DIR/README.txt;
echo "Idol name........  " $IDOL_NAME >> $IDOL_DIR/README.txt;
echo "Operating System.  " $OPERATING_SYSTEM >> $IDOL_DIR/README.txt;

#COPY NEEDED FILES INTO IDOL DIRECTORY...
cp -r $LIB_DIR/fixtures $IDOL_DIR/;
cp -r $LIB_DIR/test_helper.bash $IDOL_DIR/;

#CREATE PACKAGE-REALTED BATS TESTS

