#!/bin/bash

BASE_DIR=$1;
IDOL_NAME=$2;
LOG_OUT=$3;
BIN_DIR=$BASE_DIR/bin;
LIB_DIR=$BASE_DIR/lib;
TEST_DIR=$BASE_DIR/tests;
MAN_DIR=$BASE_DIR/man;
IDOL_DIR=$TEST_DIR/$IDOL_NAME;

OUTPUT_BATS=$IDOL_DIR/package_hash.bats
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

HASHGOLDEN=($(md5sum /tmp/package.txt))

#GENERATE TEST

    echo "@test \"SOFTWARE CHECK - "${IDOL_NAME}" Package HASH\" {" >> $OUTPUT_BATS
    echo "dpkg --list | awk '{ print $2 }' > /tmp/packge.txt" >> $OUTPUT_BATS
    echo "HASHCHECK=($(md5sum /tmp/package.txt))" >> $OUTPUT_BATS
    echo "[ $HASHCHECK -eq ${HASHGOLDEN} ]" >> $OUTPUT_BATS
    echo "}" >> $OUTPUT_BATS
    echo " " >> $OUTPUT_BATS

echo "Finished Generating Package Hash Test for "${IDOL_NAME} | tee -a $LOG_OUT;