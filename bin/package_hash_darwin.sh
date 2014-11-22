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
    exit 0;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
    echo "load test_helper" >> $OUTPUT_BATS;
    echo "fixtures bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
}

generate_package_hash() {
    rm -f /tmp/package.txt && touch /tmp/package.txt;
	ls /Applications/ >> /tmp/package.txt;
	local hashgolden=($(md5 /tmp/package.txt | awk '{ print $4 }'));
	echo $hashgolden;
}

generate_package_hash_bats() {
    echo "@test \"SOFTWARE CHECK - "${IDOL_NAME}" Package HASH\" {" >> $OUTPUT_BATS;
    echo "ls /Applications/ > /tmp/package.txt" >> $OUTPUT_BATS;
    echo "HASHCHECK=$(md5 /tmp/package.txt | awk '{ print $4 }')" >> $OUTPUT_BATS;
    echo "[ $HASHCHECK -eq ${HASHGOLDEN} ]" >> $OUTPUT_BATS;
    echo "}" >> $OUTPUT_BATS;
    echo " " >> $OUTPUT_BATS;
}


HASH_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;

OUTPUT_BATS=$HASH_BATS/package_full.bats;

#Acknowledge handoff...
handoff;

#Initialize bats and generate package list / package bats.
initialize_bats;
HASHGOLDEN=$(generate_package_hash);
generate_package_hash_bats;

#Acknowledge completion of BATS generation.
completion;
