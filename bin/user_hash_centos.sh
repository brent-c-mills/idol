#!/bin/bash

set -e

handoff() {
    echo "user_hash_centos.sh has been kicked off by idol_create.sh..." | tee -a $LOG_OUT;
    echo "user_hash_centos.sh is initiating user hash BATS creation..." | tee -a $LOG_OUT;
    echo "idol name.................."$IDOL_NAME | tee -a $LOG_OUT;
    echo "" | tee -a $LOG_OUT;
}

completion() {
    echo "user_hash_centos.sh has completed for idol "$IDOL_NAME | tee -a $LOG_OUT;
    exit 0;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
    echo "load test_helper" >> $OUTPUT_BATS;
    echo "fixtures bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
}

generate_user_hash() {
    rm -f /tmp/user.txt && touch /tmp/user.txt;
	cat /etc/passwd >> /tmp/user.txt;
	local hashgolden=($(md5sum /tmp/user.txt));
	echo $hashgolden;
}

generate_user_hash_bats() {
    echo "@test \"SOFTWARE CHECK - "${IDOL_NAME}" user HASH\" {" >> $OUTPUT_BATS;
    echo "cat /etc/passwd > /tmp/user.txt" >> $OUTPUT_BATS;
    echo "HASHCHECK=($(md5sum /tmp/user.txt))" >> $OUTPUT_BATS;
    echo "[ $HASHCHECK -eq ${HASHGOLDEN} ]" >> $OUTPUT_BATS;
    echo "}" >> $OUTPUT_BATS;
    echo " " >> $OUTPUT_BATS;
}


HASH_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;

OUTPUT_BATS=$HASH_BATS/user_full.bats;

#Acknowledge handoff...
handoff;

#Initialize bats and generate user list / user bats.
initialize_bats;
HASHGOLDEN=$(generate_user_hash);
generate_user_hash_bats;

#Acknowledge completion of BATS generation.
completion;
