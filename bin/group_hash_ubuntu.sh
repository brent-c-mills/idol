#!/bin/bash

set -e

handoff() {
    echo "group_hash_ubuntu.sh has been kicked off by idol_create.sh..." | tee -a $LOG_OUT;
    echo "group_hash_ubuntu.sh is initiating group hash BATS creation..." | tee -a $LOG_OUT;
    echo "idol name.................."$IDOL_NAME | tee -a $LOG_OUT;
    echo "" | tee -a $LOG_OUT;
}

completion() {
    echo "group_hash_ubuntu.sh has completed for idol "$IDOL_NAME | tee -a $LOG_OUT;
    exit 0;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
    echo "load test_helper" >> $OUTPUT_BATS;
    echo "fixtures bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
}

generate_group_hash() {
    echo "Generating group Golden Hash for "${IDOL_NAME} >> $LOG_OUT;
    rm -f /tmp/group_hash.txt && touch /tmp/group_hash.txt;
	cat /etc/group >> /tmp/group_hash.txt;
	local hashgolden=($(md5sum /tmp/group_hash.txt));
	echo $hashgolden;
}

generate_group_hash_bats() {
    echo "Generating group Hash Test for "${IDOL_NAME} >> $LOG_OUT;
    echo "@test \"GROUP CHECK - "${IDOL_NAME}" group HASH\" {" >> $OUTPUT_BATS;
    echo "cat /etc/group > /tmp/group_hash.txt" >> $OUTPUT_BATS;
    echo "HASHCHECK=($(md5sum /tmp/group_hash.txt))" >> $OUTPUT_BATS;
    echo "[ $HASHCHECK -eq ${HASHGOLDEN} ]" >> $OUTPUT_BATS;
    echo "}" >> $OUTPUT_BATS;
    echo " " >> $OUTPUT_BATS;
}


HASH_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;

OUTPUT_BATS=$HASH_BATS/group_hash.bats;

#Acknowledge handoff...
handoff;

#Initialize bats and generate group list / group bats.
initialize_bats;
HASHGOLDEN=$(generate_group_hash);
generate_group_hash_bats;

#Acknowledge completion of BATS generation.
completion;
