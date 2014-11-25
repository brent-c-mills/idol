#!/bin/bash

set -e;

verify_idol() {
	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a $LOG_OUT;
	if [[ ! -e ${TEST_DIR}/${IDOL_NAME} ]]; then
		echo "Idol "${IDOL_NAME}" not found." | tee -a $LOG_OUT; 
		exit 1;
	fi
}

hash_bats_test() {
	bats ${HASH_BATS}/${hashbats} | tee -a ${hashbats_log};
	cat ${hashbats_log} >> $LOG_OUT;

    if (grep "not ok" ${hashbats_log} >> /dev/null); then
        echo ${hashbats_log}" does not match the golden idol.  Full tests will be run..." | tee -a $LOG_OUT;
        full_bats_test;
	fi

	rm -f ${hashbats_log};
}

full_bats_test() {
	echo "Full bats test functionality isn't available yet.";
}


#################################
##         READ INPUT:         ##
#################################

EXPECTED_ARGS=3;

if [ $# -ne $EXPECTED_ARGS ]; then
	echo "Something has gone wrong.  The script idol_test.sh expected 3 arguments from idol, but only received "$#".";
	exit 1;
fi


#################################
##        DECLARATIONS:        ##
#################################

IDOL_NAME=$1;
BASE_DIR=$2;
LOG_OUT=$3;

NOW=$(date +"%m_%d_%Y_%H%M%S");
BIN_DIR=$BASE_DIR/bin;
LIB_DIR=$BASE_DIR/lib;
TEST_DIR=$BASE_DIR/tests;
IDOL_DIR=$TEST_DIR/$IDOL_NAME;
FULL_BATS=$IDOL_DIR/full_bats;
HASH_BATS=$IDOL_DIR/hash_bats;


#################################
##    VERIFY IDOL EXISTANCE    ##
#################################

verify_idol;


#################################
##       TEST HASH BATS        ##
#################################

for hashbats in ${HASH_BATS}/*.bats; do
    local hashbats_log=/tmp/${hashbats}.tmp.log

    hash_bats_test;

done


#################################
##       TEST FULL BATS        ##
#################################

