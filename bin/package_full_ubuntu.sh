#!/bin/bash

set -e

completion() {
    echo "package_full_ubuntu.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_package_bats() {
    while IFS=, read -r package; do

        PACKAGE=${package};

        echo "Adding package_full test for "${PACKAGE} >> ${CURRENT_LOG};
        echo "@test \"SOFTWARE CHECK - "${PACKAGE}"\" {" >> ${OUTPUT_BATS};
        echo "dpkg --list | awk '{ print $2 }' | grep \""${PACKAGE}"\"" >> ${OUTPUT_BATS};
        echo "[ \$? -eq 0 ]" >> ${OUTPUT_BATS};
        echo "}" >> ${OUTPUT_BATS};
        echo " " >> ${OUTPUT_BATS};

    done < /tmp/package_full.txt;
}

generate_package_list() {
    rm -f /tmp/package_full.txt && touch /tmp/package_full.txt;
    dpkg --list | awk '{ print $2 }' >> /tmp/package_full.txt;
}

handoff() {
    echo "package_full_ubuntu.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "package_full_ubuntu.sh is initiating full package BATS creation..." | tee -a ${CURRENT_LOG};
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

OUTPUT_BATS=${FULL_BATS}/package_full.bats;

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##         CREATE BATS         ##
#################################
initialize_bats;
generate_package_list;
generate_package_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
