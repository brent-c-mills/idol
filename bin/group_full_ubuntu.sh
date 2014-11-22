#!/bin/bash

set -e

handoff() {
    echo "group_full_ubuntu.sh has been kicked off by idol_create.sh..." | tee -a $LOG_OUT;
    echo "group_full_ubuntu.sh is initiating full group BATS creation..." | tee -a $LOG_OUT;
    echo "idol name.................."$IDOL_NAME | tee -a $LOG_OUT;
    echo "groups to be processed..."$(dpkg --list | awk '{ print $2 }' | wc -l) | tee -a $LOG_OUT;
    echo "" | tee -a $LOG_OUT;
}

completion() {
    echo "group_full_ubuntu.sh has completed for idol "$IDOL_NAME | tee -a $LOG_OUT;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
    echo "load test_helper" >> $OUTPUT_BATS;
    echo "fixtures bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
}

generate_group_list() {
    echo "Generating group Golden List for "${IDOL_NAME} >> $LOG_OUT;
    rm -f /tmp/group_full.txt && touch /tmp/group_full.txt;
    cat /etc/group >> /tmp/group_full.txt;
}

generate_group_bats() {
    while IFS=, read -r group; do

        groupname=$(echo $group | cut -d: -f1);
        group=$group;

        echo "Adding group_full test for "${group} >> $LOG_OUT;
        echo "@test \"GROUP CHECK - "${group}"\" {" >> $OUTPUT_BATS;
        echo "cat /etc/group | grep \""${group}"\"" >> $OUTPUT_BATS;
        echo "[ \$? -eq 0 ]" >> $OUTPUT_BATS;
        echo "}" >> $OUTPUT_BATS;
        echo " " >> $OUTPUT_BATS;

    done < /tmp/group_full.txt;
}


FULL_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;

OUTPUT_BATS=$FULL_BATS/group_full.bats;

#Acknowledge handoff...
handoff;

#Initialize bats and generate group list / group bats.
initialize_bats;
generate_group_list;
generate_group_bats;

#Acknowledge completion of BATS generation.
completion;
