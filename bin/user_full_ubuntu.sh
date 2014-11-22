#!/bin/bash

set -e

handoff() {
    echo "user_full_ubuntu.sh has been kicked off by idol_create.sh..." | tee -a $LOG_OUT;
    echo "user_full_ubuntu.sh is initiating full user BATS creation..." | tee -a $LOG_OUT;
    echo "idol name.................."$IDOL_NAME | tee -a $LOG_OUT;
    echo "users to be processed..."$(dpkg --list | awk '{ print $2 }' | wc -l) | tee -a $LOG_OUT;
    echo "" | tee -a $LOG_OUT;
}

completion() {
    echo "user_full_ubuntu.sh has completed for idol "$IDOL_NAME | tee -a $LOG_OUT;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
    echo "load test_helper" >> $OUTPUT_BATS;
    echo "fixtures bats" >> $OUTPUT_BATS;
    echo "" >> $OUTPUT_BATS;
}

generate_user_list() {
    rm -f /tmp/user.txt && touch /tmp/user.txt;
    cat /etc/passwd >> /tmp/user.txt;
}

generate_user_bats() {
    while IFS=, read -r user; do

        username=$(echo $user | cut -d: -f1);
        user=$user;

        echo "Adding user_full test for "${user} >> $LOG_OUT;
        echo "@test \"SOFTWARE CHECK - "${user}"\" {" >> $OUTPUT_BATS;
        echo "cat /etc/passwd | grep \""${user}"\"" >> $OUTPUT_BATS;
        echo "[ \$? -eq 0 ]" >> $OUTPUT_BATS;
        echo "}" >> $OUTPUT_BATS;
        echo " " >> $OUTPUT_BATS;

    done < /tmp/user.txt;
}


FULL_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;

OUTPUT_BATS=$FULL_BATS/user_full.bats;

#Acknowledge handoff...
handoff;

#Initialize bats and generate user list / user bats.
initialize_bats;
generate_user_list;
generate_user_bats;

#Acknowledge completion of BATS generation.
completion;
