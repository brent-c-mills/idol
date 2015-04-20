#!/bin/bash

set -e

completion() {
    echo "gem_hash_centos.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_gem_hash() {
    rm -f /tmp/gem_hash.txt && touch /tmp/gem_hash.txt;
	gem list --local >> /tmp/gem_hash.txt;
	local hashgolden=($(md5 /tmp/gem_hash.txt | awk '{ print $4 }'));
	echo $hashgolden;
    rm -f /tmp/gem_hash.txt;
}

generate_gem_hash_bats() {
    echo "@test \"RUBY GEM CHECK - "${IDOL_NAME}" HASH\" {" >> ${OUTPUT_BATS};
    echo "gem list --local > /tmp/gem_hash.txt" >> ${OUTPUT_BATS};
    echo "HASHCHECK=(\$(md5 /tmp/gem_hash.txt | awk '{ print \$4 }'))" >> ${OUTPUT_BATS};
    echo "[ \$HASHCHECK = ${HASHGOLDEN} ]" >> ${OUTPUT_BATS};
    echo "}" >> ${OUTPUT_BATS};
    echo " " >> ${OUTPUT_BATS};
}

handoff() {
    echo "gem_hash_centos.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "gem_hash_centos.sh is initiating gem hash BATS creation..." | tee -a ${CURRENT_LOG};
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

skip() {
    echo "Ruby is not installed on this system." | tee -a ${CURRENT_LOG};
    exit 0;
}

verify_ruby() {
    if [[ ! $(gem -v 2> /dev/null) ]]; then
        skip;
    fi
}

#################################
##     INPUT AND VARIABLES     ##
#################################
HASH_BATS=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;

OUTPUT_BATS=${HASH_BATS}/gem_hash.bats;

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##  VERIFY RUBY INSTALLATION   ##
#################################
verify_ruby;

#################################
##         CREATE BATS         ##
#################################
initialize_bats;
HASHGOLDEN=$(generate_gem_hash);
generate_gem_hash_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
