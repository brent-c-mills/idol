#!/bin/bash

set -e

completion() {
    echo "gem_full_centos.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_gem_bats() {
    while IFS=, read -r gem; do

        GEM=${gem};

        echo "Adding gem_full test for "${GEM} >> ${CURRENT_LOG};
        echo "@test \"RUBY GEM CHECK - "${GEM}"\" {" >> ${OUTPUT_BATS};
        echo "gem list --local | grep \""${GEM}"\"" >> ${OUTPUT_BATS};
        echo "[ \$? -eq 0 ]" >> ${OUTPUT_BATS};
        echo "}" >> ${OUTPUT_BATS};
        echo " " >> ${OUTPUT_BATS};

    done < /tmp/gem_full.txt;
    rm -f /tmp/gem_full.txt;
}

generate_gem_list() {
    rm -f /tmp/gem_full.txt && touch /tmp/gem_full.txt;
    gem list --local >> /tmp/gem_full.txt;
}

handoff() {
    echo "gem_full_centos.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "gem_full_centos.sh is initiating full gem BATS creation..." | tee -a ${CURRENT_LOG};
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
FULL_BATS=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;

OUTPUT_BATS=${FULL_BATS}/gem_full.bats;

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
generate_gem_list;
generate_gem_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
