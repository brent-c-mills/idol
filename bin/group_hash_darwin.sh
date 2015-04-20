#!/bin/bash

set -e

completion() {
    echo "group_hash_darwin.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_group_hash() {
    echo "Generating group Golden Hash for "${IDOL_NAME} >> ${CURRENT_LOG};
    rm -f /tmp/group_hash.txt && touch /tmp/group_hash.txt;
	cat /etc/group >> /tmp/group_hash.txt;
	local hashgolden=($(md5 /tmp/group_hash.txt | awk '{ print $4 }'));
	echo $hashgolden;
}

generate_group_hash_bats() {
    echo "@test \"GROUP CHECK - "${IDOL_NAME}" group HASH\" {" >> ${OUTPUT_BATS};
    echo "cat /etc/group > /tmp/group_hash.txt" >> ${OUTPUT_BATS};
    echo "HASHCHECK=\$(md5 /tmp/group_hash.txt | awk '{ print \$4 }')" >> ${OUTPUT_BATS};
    echo "[ \$HASHCHECK = ${HASHGOLDEN} ]" >> ${OUTPUT_BATS};
    echo "}" >> ${OUTPUT_BATS};
    echo " " >> ${OUTPUT_BATS};
}

handoff() {
    echo "group_hash_darwin.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "group_hash_darwin.sh is initiating group hash BATS creation..." | tee -a ${CURRENT_LOG};
    echo "idol name.................."${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "" | tee -a ${CURRENT_LOG};
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> ${OUTPUT_BATS};
    echo "" >> ${OUTPUT_BATS};
    echo "load test_helper" >> ${OUTPUT_BATS};
    echo "fixtures bats" >> ${OUTPUT_BATS};
    echo "" >> ${OUTPUT_BATS};
}

#################################
##     INPUT AND VARIABLES     ##
#################################
HASH_BATS=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;

OUTPUT_BATS=${HASH_BATS}/group_hash.bats;

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##         CREATE BATS         ##
#################################
initialize_bats;
HASHGOLDEN=$(generate_group_hash);
generate_group_hash_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
