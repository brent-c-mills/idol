#!/bin/bash

set -e

completion() {
    echo "user_full_darwin.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_user_bats() {
    while IFS=, read -r user; do

        username=$(echo ${user} | cut -d: -f1);
        user=${user};

        echo "Adding user_full test for "${user} >> ${CURRENT_LOG};
        echo "@test \"USER CHECK - "${user}"\" {" >> ${OUTPUT_BATS};
        echo "cat /etc/passwd | grep \""${user}"\"" >> ${OUTPUT_BATS};
        echo "[ \$? -eq 0 ]" >> ${OUTPUT_BATS};
        echo "}" >> ${OUTPUT_BATS};
        echo " " >> ${OUTPUT_BATS};

    done < /tmp/user_full.txt;
}

generate_user_list() {
    echo "Generating User Golden List for "${IDOL_NAME} >> ${CURRENT_LOG};
    rm -f /tmp/user_full.txt && touch /tmp/user_full.txt;
    cat /etc/passwd >> /tmp/user_full.txt;
}

handoff() {
    echo "user_full_darwin.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "user_full_darwin.sh is initiating full user BATS creation..." | tee -a ${CURRENT_LOG};
    echo "idol name.................."${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "users to be processed..."$(ls /Applications | wc -l) | tee -a ${CURRENT_LOG};
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
FULL_BATS=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;

OUTPUT_BATS=${FULL_BATS}/user_full.bats;

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##         CREATE BATS         ##
#################################
initialize_bats;
generate_user_list;
generate_user_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
