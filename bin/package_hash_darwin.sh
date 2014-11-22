#!/bin/bash

set -e

handoff() {
    echo "package_hash_darwin.sh has been kicked off by idol_create.sh..." | tee -a $LOG_OUT;
    echo "package_hash_darwin.sh is initiating package hash BATS creation..." | tee -a $LOG_OUT;
    echo "idol name.................."$IDOL_NAME | tee -a $LOG_OUT;
    echo "" | tee -a $LOG_OUT;
}

completion() {
    echo "package_hash_darwin.sh has completed for idol "$IDOL_NAME | tee -a $LOG_OUT;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS
    echo "" >> $OUTPUT_BATS
    echo "load test_helper" >> $OUTPUT_BATS
    echo "fixtures bats" >> $OUTPUT_BATS
    echo "" >> $OUTPUT_BATS
}

generate_package_hash() {
    rm -f /tmp/package.txt && touch /tmp/package.txt
	ls /Applications/ >> /tmp/packge.txt
	local hashgolden=($(md5sum /tmp/package.txt))
	echo $hashgolden
}

generate_package_hash_bats() {
    echo "@test \"SOFTWARE CHECK - "${IDOL_NAME}" Package HASH\" {" >> $OUTPUT_BATS
    echo "ls /Applications/ > /tmp/packge.txt" >> $OUTPUT_BATS
    echo "HASHCHECK=($(md5sum /tmp/package.txt))" >> $OUTPUT_BATS
    echo "[ $HASHCHECK -eq ${HASHGOLDEN} ]" >> $OUTPUT_BATS
    echo "}" >> $OUTPUT_BATS
    echo " " >> $OUTPUT_BATS
}


BASE_DIR=$1;
IDOL_NAME=$2;
LOG_OUT=$3;
BIN_DIR=$BASE_DIR/bin;
LIB_DIR=$BASE_DIR/lib;
TEST_DIR=$BASE_DIR/tests;
MAN_DIR=$BASE_DIR/man;
IDOL_DIR=$TEST_DIR/$IDOL_NAME;

OUTPUT_BATS=$IDOL_DIR/package_hash.bats

#Acknowledge handoff...
handoff

#Initialize bats and generate package list / package bats.
initialize_bats
HASHGOLDEN=$(generate_package_hash)
generate_package_hash_bats

#Acknowledge completion of BATS generation.
completion
