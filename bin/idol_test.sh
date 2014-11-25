#!/bin/bash

set -e;

handoff() {
    echo "idol_test.sh has been kicked off by idol_create.sh..." | tee -a ${LOG_OUT};
    echo "idol_test.sh is initiating hash and full bats tests..." | tee -a ${LOG_OUT};
    echo "idol name:	"$IDOL_NAME | tee -a ${LOG_OUT};
    echo "" | tee -a ${LOG_OUT};
}

completion() {
    echo "" | tee -a ${LOG_OUT};
    echo "idol_test.sh has completed testing for idol "$IDOL_NAME | tee -a ${LOG_OUT};
    exit 0;
}

verify_idol() {
	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a ${LOG_OUT};
	echo ""  | tee -a ${LOG_OUT};
	if [[ ! -e ${TEST_DIR}/${IDOL_NAME} ]]; then
		echo "Idol "${IDOL_NAME}" not found." | tee -a ${LOG_OUT}; 
		exit 1;
	else
		echo "Idol "${IDOL_NAME}" verified." | tee -a ${LOG_OUT}; 
		echo "Commencing testing..." | tee -a ${LOG_OUT}; 
	fi
}

hash_bats_test() {

	local hash_bats_name=$(basename ${hashbats});
	IFS=_ read bats_category bats_type <<< $hash_bats_name;
	echo "" | tee -a ${LOG_OUT};
	echo "========================================" | tee -a ${LOG_OUT};
	echo "Commencing hash test for "${hash_bats_name}" on Idol "${IDOL_NAME} | tee -a ${LOG_OUT};

	if [[ $(bats ${hashbats} | tee -a ${LOG_OUT}) == *"not ok"* ]]; then
        echo ${hash_bats_name}" does not match the golden image for this Idol.  Full tests will be run." | tee -a ${LOG_OUT};
        full_bats_test ${bats_category};
    else
    	echo ${hash_bats_name}" matches the golden image for this Idol." | tee -a ${LOG_OUT};
	fi

}

full_bats_test() {
	bats_category=$1;
	fullbats="${bats_category}_full.bats";

	echo "** A full bats test for "${IDOL_NAME}" : "${bats_category}" has been triggered." | tee -a ${LOG_OUT};
	echo "" | tee -a ${LOG_OUT};
	echo "========================================" | tee -a ${LOG_OUT};
	echo "Commencing full test for "${fullbats}" on Idol "${IDOL_NAME} | tee -a ${LOG_OUT};
	echo "" | tee -a ${LOG_OUT};
	bats $FULL_BATS/${fullbats} | tee -a ${LOG_OUT}
	echo "" | tee -a ${LOG_OUT};
	echo "Completed full bats test for "${IDOL_NAME}" : "${bats_category}"." | tee -a ${LOG_OUT};
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

TEST_DIR=$BASE_DIR/tests;
IDOL_DIR=$TEST_DIR/$IDOL_NAME;
FULL_BATS=$IDOL_DIR/full_bats;
HASH_BATS=$IDOL_DIR/hash_bats;

#################################
##       ACCEPT HANDOFF        ##
#################################
handoff;

#################################
##    VERIFY IDOL EXISTANCE    ##
#################################
verify_idol;


#################################
##       TEST HASH BATS        ##
#################################
for hashbats in ${HASH_BATS}/*.bats; do
    hash_bats_test;

done

#################################
##       TEST FULL BATS        ##
#################################

#Called from within hash tests.  This is due to the fact that full tests should only be run if hash tests fail (to save time).

#################################
##         COMPLETION          ##
#################################
completion;