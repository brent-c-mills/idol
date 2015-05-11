#!/bin/bash

set -e;

completion() {
    fail_list_generate;
    echo "" | tee -a ${CURRENT_LOG};
    echo "idol_test.sh has completed testing for idol "$IDOL_NAME | tee -a ${CURRENT_LOG};
    echo "";
    echo "";
    echo "____________RESULTS_____________";
    echo "Tests Run:          "$(grep -c "ok " ${CURRENT_LOG});
    echo "Hash Tests Failed:  "$(grep "not ok " ${FAIL_LIST} | grep -c "HASH");
    echo "Tests Failed:       "$(grep -v "HASH" ${FAIL_LIST} | grep -c "not ok");
    echo "";
    echo "Failed tests are stored in "${FAIL_LIST}".";
    echo "";
    if [[ $(grep -v "HASH" ${FAIL_LIST} | grep -c "not ok") -ne 0 ]]; then
    	exit 1;
    fi
    exit 0;
}

fail_list_generate() {
#This function initially generates a list of failures.
#It can be adjusted to mail a log server for each failed test.

#OUTPUT TO FILE
rm -f ${FAIL_LIST};
touch ${FAIL_LIST};
echo "TESTS RUN: "$(date +"%m_%d_%Y_%H%M") >> ${FAIL_LIST};
echo "" >> ${FAIL_LIST};
echo "" >> ${FAIL_LIST};
echo "========================================" >> ${FAIL_LIST};

FAIL_COUNT=$(grep -c "not ok" ${CURRENT_LOG});

for (( i=1; i<=${FAIL_COUNT}; i++ )); do
    echo "" >> ${FAIL_LIST};
    grep -m${i} -A2 "not ok" ${CURRENT_LOG} | tail -n3 >> ${FAIL_LIST};
    echo "" >> ${FAIL_LIST};
    echo "========================================" >> ${FAIL_LIST};
done;

#OUTPUT TO EMAIL
#Uncomment and update below data for email logging
#__________________________________________________
#
#FAIL_EMAIL=/tmp/fail_email.txt;
#SUBJECT="IDOL TEST FAILURE"
#EMAIL="admin@company.com"

#for (( i=1; i<=${FAIL_COUNT}; i++ )); do
#	rm -f ${FAIL_EMAIL};
#	touch ${FAIL_EMAIL};
#    grep -m${i} -A2 "not ok" ${CURRENT_LOG} | tail -n3 >> ${FAIL_EMAIL};
#	/bin/mail -s "${SUBJECT}" "${EMAIL}" < "${FAIL_EMAIL}";
#done;

}

full_bats_test() {
	bats_category=$1;
	fullbats="${bats_category}_full.bats";

	echo "**" | tee -a ${CURRENT_LOG};
	echo "** A full bats test for "${IDOL_NAME}" : "${bats_category}" has been triggered." | tee -a ${CURRENT_LOG};
	echo "" | tee -a ${CURRENT_LOG};
	echo "========================================" | tee -a ${CURRENT_LOG};
	echo "Commencing full test for "${fullbats}" on Idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
	echo "" | tee -a ${CURRENT_LOG};
	bats ${FULL_BATS}/${fullbats} | tee -a ${CURRENT_LOG}
	echo "" | tee -a ${CURRENT_LOG};
	echo "Completed full bats test for "${IDOL_NAME}" : "${bats_category}"." | tee -a ${CURRENT_LOG};
}

handoff() {
    echo "idol_test.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "idol_test.sh is initiating hash and full bats tests..." | tee -a ${CURRENT_LOG};
    echo "idol name:	"${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "" | tee -a ${CURRENT_LOG};
}

hash_bats_test() {
	local hash_bats_name=$(basename ${hashbats});
	IFS=_ read bats_category bats_type <<< ${hash_bats_name};
	echo "" | tee -a ${CURRENT_LOG};
	echo "========================================" | tee -a ${CURRENT_LOG};
	echo "Commencing hash test for "${hash_bats_name}" on Idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
	echo "" | tee -a ${CURRENT_LOG};
	if [[ $(bats ${hashbats} | tee -a ${CURRENT_LOG}) == *"not ok"* ]]; then
        echo ${hash_bats_name}" does not match the golden image for this Idol.  Full tests will be run." | tee -a ${CURRENT_LOG};
        full_bats_test ${bats_category};
    else
    	echo ${hash_bats_name}" matches the golden image for this Idol." | tee -a ${CURRENT_LOG};
    	echo "Completed hash bats test for "${IDOL_NAME}" : "${bats_category}"." | tee -a ${CURRENT_LOG};
	fi
}

verify_idol() {
	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a ${CURRENT_LOG};
	echo ""  | tee -a ${CURRENT_LOG};
	if [[ ! -e ${TEST_DIR}/${IDOL_NAME} ]]; then
		echo "Idol "${IDOL_NAME}" not found." | tee -a ${CURRENT_LOG}; 
		exit 1;
	else
		echo "Idol "${IDOL_NAME}" verified." | tee -a ${CURRENT_LOG}; 
		echo "Commencing testing..." | tee -a ${CURRENT_LOG}; 
	fi
}

#################################
##         READ INPUT:         ##
#################################
EXPECTED_ARGS=4;

if [ $# -ne ${EXPECTED_ARGS} ]; then
	echo "Something has gone wrong.  The script idol_test.sh expected 3 arguments from idol, but only received "$#".";
	exit 1;
fi

#################################
##        DECLARATIONS:        ##
#################################
IDOL_NAME=$1;
CURRENT_LOG=$2;
BASE_DIR=$3;
TEST_DIR=$4;

IDOL_DIR=${TEST_DIR}/${IDOL_NAME};
FULL_BATS=${IDOL_DIR}/full_bats;
HASH_BATS=${IDOL_DIR}/hash_bats;
FAIL_LIST=${BASE_DIR}/log/failed.txt;

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
