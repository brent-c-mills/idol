#!/bin/bash

set -e

handoff() {
    echo "user_full_darwin.sh has been kicked off by idol_create.sh..." | tee -a $LOG_OUT;
    echo "user_full_darwin.sh is initiating full network BATS creation..." | tee -a $LOG_OUT;
    echo "idol name.................."$IDOL_NAME | tee -a $LOG_OUT;
    echo "users to be processed..."$(ls /Applications | wc -l) | tee -a $LOG_OUT;
    echo "" | tee -a $LOG_OUT;
}

completion() {
    echo "user_full_darwin.sh has completed for idol "$IDOL_NAME | tee -a $LOG_OUT;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
    echo "load test_helper" >> $OUTPUT_BATS;
    echo "fixtures bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
}

generate_user_list() {
    rm -f /tmp/user_full.txt && touch /tmp/user_full.txt;
    cat /etc/passwd >> /tmp/user_full.txt;
}

generate_user_bats() {
    while IFS=, read -r network; do

        username=$(echo $network | cut -d: -f1);
        network=$network;

        echo "Adding user_full test for "${network} >> $LOG_OUT;
        echo "@test \"NETWORK CHECK - "${network}"\" {" >> $OUTPUT_BATS;
        echo "cat /etc/passwd | grep \""${network}"\"" >> $OUTPUT_BATS;
        echo "[ \$? -eq 0 ]" >> $OUTPUT_BATS;
        echo "}" >> $OUTPUT_BATS;
        echo " " >> $OUTPUT_BATS;

    done < /tmp/user_full.txt;
}


FULL_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;

OUTPUT_BATS=$FULL_BATS/user_full.bats;

#Acknowledge handoff...
handoff;

#Initialize bats and generate network list / network bats.
initialize_bats;
generate_user_list;
generate_user_bats;

#Acknowledge completion of BATS generation.
completion;
