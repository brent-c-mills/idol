#!/bin/bash

set -e

completion() {
    echo "chef_hash_centos.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_chef_hash() {
    rm -f /tmp/chef_hash.txt && touch /tmp/chef_hash.txt;
	knife cookbook list >> /tmp/chef_hash.txt;
    knife recipe list >> /tmp/chef_hash.txt;
	local hashgolden=($(md5sum /tmp/chef_hash.txt));
	echo $hashgolden;
    rm -f /tmp/chef_hash.txt;
}

generate_chef_hash_bats() {
    echo "@test \"CHEF CHECK - "${IDOL_NAME}" HASH\" {" >> ${OUTPUT_BATS};
    echo "knife cookbook list > /tmp/chef_hash.txt" >> ${OUTPUT_BATS};
    echo "knife recipe list > /tmp/chef_hash.txt" >> ${OUTPUT_BATS};
    echo "HASHCHECK=(\$(md5sum /tmp/chef_hash.txt))" >> ${OUTPUT_BATS};
    echo "[ \$HASHCHECK = ${HASHGOLDEN} ]" >> ${OUTPUT_BATS};
    echo "}" >> ${OUTPUT_BATS};
    echo " " >> ${OUTPUT_BATS};
}

handoff() {
    echo "chef_hash_centos.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "chef_hash_centos.sh is initiating chef hash BATS creation..." | tee -a ${CURRENT_LOG};
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
    echo "Chef is not installed on this system." | tee -a ${CURRENT_LOG};
    exit 0;
}

verify_chef() {
    if [[ ! $(chef -v 2> /dev/null) ]]; then
        skip;
    fi

    if [[ $(`knife list recipe 2> /dev/null`) != 0 ]]; then
        echo "Chef has encountered an error.  Skipping Chef full BATS generation..." | tee -a ${CURRENT_LOG};
        skip;
    fi
}

#################################
##     INPUT AND VARIABLES     ##
#################################
HASH_BATS=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;

OUTPUT_BATS=${HASH_BATS}/chef_hash.bats;

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##  VERIFY CHEF INSTALLATION   ##
#################################
verify_chef;

#################################
##         CREATE BATS         ##
#################################
initialize_bats;
HASHGOLDEN=$(generate_chef_hash);
generate_chef_hash_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
