#!/bin/bash

BASE_DIR=$1;
IDOL_NAME=$2;
LOG_OUT=$3;
BIN_DIR=$BASE_DIR/bin;
LIB_DIR=$BASE_DIR/lib;
TEST_DIR=$BASE_DIR/tests;
MAN_DIR=$BASE_DIR/man;
IDOL_DIR=$TEST_DIR/$IDOL_NAME;

OUTPUT_BATS=$IDOL_DIR/package_full.bats
FAILEDLIST=/tmp/failedlist.txt

PROCESSED=0
SUCCESS=0
FAIL=0

#Initialize .bats file

echo "#!/usr/bin/env bats" >> $OUTPUT_BATS
echo "" >> $OUTPUT_BATS
echo "load test_helper" >> $OUTPUT_BATS
echo "fixtures bats" >> $OUTPUT_BATS
echo "" >> $OUTPUT_BATS

#Generating Initial Package List
rm -f /tmp/package.txt && touch /tmp/package.txt
rm -f /tmp/failedlist.txt && touch /tmp/failedlist.txt
dpkg --list | awk '{ print $2 }' >> /tmp/packge.txt

while IFS=, read -r package; do

    PACKAGE=$package

    echo "@test \"SOFTWARE CHECK - "${PACKAGE}"\" {" >> $OUTPUT_BATS
    echo "dpkg --list | awk '{ print $2 }' | grep \""${PACKAGE}"\"" >> $OUTPUT_BATS
    echo "[ \$? -eq 0 ]" >> $OUTPUT_BATS
    echo "}" >> $OUTPUT_BATS
    echo " " >> $OUTPUT_BATS

    SUCCESS=$[SUCCESS + 1]
    PROCESSED=$[PROCESSED + 1]

done < /tmp/package.txt

echo "Number of Packages processed.         "$PROCESSED | tee -a $LOG_OUT;
echo "Number of BATS Successfully Created.  "$SUCCESS | tee -a $LOG_OUT;
echo "Number of BATS Failed.                "$FAIL | tee -a $LOG_OUT;
echo "FAILED BATS:      
                    "
while IFS=, read -r FAILEDPACKAGE; do
    echo "                                      "$FAILEDPACKAGE;
done < $FAILEDLIST;