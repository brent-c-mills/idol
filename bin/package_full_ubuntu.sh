#!/bin/bash

set -e

handoff() {
    echo "package_full_ubuntu.sh has been kicked off by idol_create.sh..." | tee -a $LOG_OUT;
    echo "package_full_ubuntu.sh is initiating full package BATS creation..." | tee -a $LOG_OUT;
    echo "idol name.................."$IDOL_NAME | tee -a $LOG_OUT;
    echo "Packages to be processed..."$(dpkg --list | awk '{ print $2 }' | wc -l) | tee -a $LOG_OUT;
    echo "" | tee -a $LOG_OUT;
}

completion() {
    echo "package_full_ubuntu.sh has completed for idol "$IDOL_NAME | tee -a $LOG_OUT;
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> $OUTPUT_BATS
    echo "" >> $OUTPUT_BATS
    echo "load test_helper" >> $OUTPUT_BATS
    echo "fixtures bats" >> $OUTPUT_BATS
    echo "" >> $OUTPUT_BATS
}

generate_package_list() {
    rm -f /tmp/package.txt && touch /tmp/package.txt
    dpkg --list | awk '{ print $2 }' >> /tmp/packge.txt
}

generate_package_bats() {
    while IFS=, read -r package; do

        PACKAGE=$package

        echo "Adding package_full test for "${PACKAGE} >> $LOG_OUT;
        echo "@test \"SOFTWARE CHECK - "${PACKAGE}"\" {" >> $OUTPUT_BATS
        echo "dpkg --list | awk '{ print $2 }' | grep \""${PACKAGE}"\"" >> $OUTPUT_BATS
        echo "[ \$? -eq 0 ]" >> $OUTPUT_BATS
        echo "}" >> $OUTPUT_BATS
        echo " " >> $OUTPUT_BATS

    done < /tmp/package.txt
}


FULL_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;

OUTPUT_BATS=$FULL_BATS/package_full.bats

#Acknowledge handoff...
handoff

#Initialize bats and generate package list / package bats.
initialize_bats
generate_package_list
generate_package_bats

#Acknowledge completion of BATS generation.
completion
