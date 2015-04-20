#!/bin/bash

set -e

completion() {
    echo "package_hash_ubuntu.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_package_hash() {
    echo "Generating Package Golden Hash for "${IDOL_NAME} >> ${CURRENT_LOG};
    rm -f /tmp/package_hash.txt && touch /tmp/package_hash.txt;
	dpkg --list | awk '{ print $2 }' >> /tmp/package_hash.txt;
	local hashgolden=($(md5sum /tmp/package_hash.txt));
	echo $hashgolden;
}

generate_package_hash_bats() {
    echo "Generating Package Hash Test for "${IDOL_NAME} >> ${CURRENT_LOG};
    echo "@test \"SOFTWARE CHECK - "${IDOL_NAME}" Package HASH\" {" >> ${OUTPUT_BATS};
    echo "dpkg --list | awk '{ print $2 }' > /tmp/package_hash.txt" >> ${OUTPUT_BATS};
    echo "HASHCHECK=(\$(md5sum /tmp/package_hash.txt))" >> ${OUTPUT_BATS};
    echo "[ \$HASHCHECK = ${HASHGOLDEN} ]" >> ${OUTPUT_BATS};
    echo "}" >> ${OUTPUT_BATS};
    echo " " >> ${OUTPUT_BATS};
}

handoff() {
    echo "package_hash_ubuntu.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "package_hash_ubuntu.sh is initiating package hash BATS creation..." | tee -a ${CURRENT_LOG};
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

OUTPUT_BATS=${HASH_BATS}/package_hash.bats;

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##         CREATE BATS         ##
#################################
initialize_bats;
HASHGOLDEN=$(generate_package_hash);
generate_package_hash_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
