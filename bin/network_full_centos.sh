#!/bin/bash

set -e

handoff() {
    echo "network_full_centos.sh has been kicked off by idol_create.sh..." | tee -a $LOG_OUT;
    echo "network_full_centos.sh is initiating full network BATS creation..." | tee -a $LOG_OUT;
    echo "idol name.................."$IDOL_NAME | tee -a $LOG_OUT;
    echo "networks to be processed..."$(cat /etc/passwd | wc -l) | tee -a $LOG_OUT;
    echo "" | tee -a $LOG_OUT;
}

completion() {
    echo "network_full_centos.sh has completed for idol "$IDOL_NAME | tee -a $LOG_OUT;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
    echo "load test_helper" >> $OUTPUT_BATS;
    echo "fixtures bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
}

generate_network_list() {
    rm -f /tmp/network_full.txt && touch /tmp/network_full.txt;
    cat /etc/passwd >> /tmp/network_full.txt;
}

generate_network_bats() {
    while IFS=, read -r network; do

        networkname=$(echo $network | cut -d: -f1);
        network=$network;

        echo "Adding network_full test for "${networkname} >> $LOG_OUT;
        echo "@test \"NETWORK CHECK - "${networkname}"\" {" >> $OUTPUT_BATS;
        echo "cat /etc/passwd | grep \""${network}"\"" >> $OUTPUT_BATS;
        echo "[ \$? -eq 0 ]" >> $OUTPUT_BATS;
        echo "}" >> $OUTPUT_BATS;
        echo " " >> $OUTPUT_BATS;

    done < /tmp/network_full.txt;
}


FULL_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;

OUTPUT_BATS=$FULL_BATS/network_full.bats;

#Acknowledge handoff...
handoff;

#Initialize bats and generate network list / network bats.
initialize_bats;
generate_network_list;
generate_network_bats;

#Acknowledge completion of BATS generation.
completion;
