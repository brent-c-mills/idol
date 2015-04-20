#!/bin/bash

set -e

completion() {
    echo "group_full_centos.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_group_bats() {
    while IFS=, read -r group; do

        groupname=$(echo ${group} | cut -d: -f1);
        group=${group};

        echo "Adding group_full test for "${groupname} >> ${CURRENT_LOG};
        echo "@test \"GROUP CHECK - "${groupname}"\" {" >> ${OUTPUT_BATS};
        echo "cat /etc/group | grep \""${group}"\"" >> ${OUTPUT_BATS};
        echo "[ \$? -eq 0 ]" >> ${OUTPUT_BATS};
        echo "}" >> ${OUTPUT_BATS};
        echo " " >> ${OUTPUT_BATS};

    done < /tmp/group_full.txt;
}

generate_group_list() {
    echo "Generating group Golden List for "${IDOL_NAME} >> ${CURRENT_LOG};
    rm -f /tmp/group_full.txt && touch /tmp/group_full.txt;
    cat /etc/group >> /tmp/group_full.txt;
}

handoff() {
    echo "group_full_centos.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "group_full_centos.sh is initiating full group BATS creation..." | tee -a ${CURRENT_LOG};
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
FULL_BATS=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;

OUTPUT_BATS=${FULL_BATS}/group_full.bats;

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##         CREATE BATS         ##
#################################
initialize_bats;
generate_group_list;
generate_group_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
