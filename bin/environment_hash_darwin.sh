#!/bin/bash

set -e

completion() {
    echo "environment_hash_darwin.sh has completed for idol "${IDOL_NAME} | tee -a ${LOG_OUT};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_environment_hash() {
    rm -f /tmp/environment_hash.txt && touch /tmp/environment_hash.txt;
    
    for i in "${ENV_COMPONENT[@]}"
    do
            cat ${i} >> /tmp/environment_hash.txt;
            echo "" >> /tmp/environment_hash.txt;
            echo "" >> /tmp/environment_hash.txt;
    done

    local hashgolden=($(md5 /tmp/environment_hash.txt | awk '{ print $4 }'));
    rm -f /tmp/environment_hash.txt;
    echo $hashgolden;
}

generate_environment_hash_bats() {
    echo "@test \"ENVIRONMENT CHECK - "${IDOL_NAME}" Environment HASH\" {" >> ${OUTPUT_BATS};
    echo "ls /Applications/ > /tmp/environment_hash.txt" >> ${OUTPUT_BATS};
    echo "HASHCHECK=\$(md5 /tmp/environment_hash.txt | awk '{ print \$4 }')" >> ${OUTPUT_BATS};
    echo "[ \$HASHCHECK = ${HASHGOLDEN} ]" >> ${OUTPUT_BATS};
    echo "}" >> ${OUTPUT_BATS};
    echo " " >> ${OUTPUT_BATS};
}

handoff() {
    echo "environment_hash_darwin.sh has been kicked off by idol_create.sh..." | tee -a ${LOG_OUT};
    echo "environment_hash_darwin.sh is initiating hashed environment BATS creation..." | tee -a ${LOG_OUT};
    echo "idol name.................."${IDOL_NAME} | tee -a ${LOG_OUT};
    echo "" | tee -a ${LOG_OUT};
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
LOG_OUT=$3;

OUTPUT_BATS=${HASH_BATS}/environment_hash.bats;

ENV_COMPONENT=( "/etc/shells" "/etc/hosts" "/etc/hosts.equiv" "/etc/paths" );

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##   GENERATE HASH AND BATS    ##
#################################
initialize_bats;
HASHGOLDEN=$(generate_environment_hash);
generate_environment_hash_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
