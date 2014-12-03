#!/bin/bash

set -e;

completion() {
    echo "" | tee -a ${LOG_OUT};
    echo "idol_test.sh has completed testing for idol "$IDOL_NAME | tee -a ${LOG_OUT};
    echo "";
    echo "";
    echo "____________RESULTS_____________";
    echo "Tests Run:    "$(grep -c "ok " ${LOG_OUT});
    echo "Tests Failed: "$(grep -c "not ok " ${LOG_OUT});
    echo "";
    if [[ $(grep -c "not ok " ${LOG_OUT}) -ne 0 ]]; then
    	fail_list_generate;
    fi
    exit 0;
}

fail_list_generate() {
#This function initially generates a list of failures.
#It can be adjusted to mail a log server for each failed test.

#OUTPUT TO FILE
FAIL_LIST=${BASE_DIR}/log/failed.txt;
rm -f ${FAIL_LIST};
touch ${FAIL_LIST};

while IFS='' read -r LINE notused
	echo "========================================" | tee -a ${FAIL_LIST};
	echo "" | tee -a ${FAIL_LIST};

 	while IFS='--' read -r LINE notused
	do
		echo ${LINE} >> ${FAIL_LIST};
	done < <(grep -A 2 "not ok" ${LOG_OUT});

	echo "" | tee -a ${FAIL_LIST};
	echo "========================================" | tee -a ${FAIL_LIST};
done < <(grep "not ok" ${LOG_OUT});

#OUTPUT TO EMAIL
#Uncommend and update below data for email logging
#__________________________________________________
#
#FAIL_EMAIL=/tmp/fail_email.txt;
#SUBJECT="IDOL TEST FAILURE"
#EMAIL="admin@somewhere.com"

#while IFS='' read -r LINE notused
#	rm -f ${FAIL_EMAIL};
#	touch ${FAIL_EMAIL};
#
#	while IFS='--' read -r LINE notused
#	do
#		echo ${LINE} >> ${FAIL_EMAIL};
#	done < <(grep -A 2 "not ok" ${LOG_OUT});
#
#	/bin/mail -a "${SUBJECT}" "${EMAIL}" < "${FAIL_EMAIL}";
#
#done < <(grep "not ok" ${LOG_OUT});

}

full_bats_test() {
	bats_category=$1;
	fullbats="${bats_category}_full.bats";

	echo "**" | tee -a ${LOG_OUT};
	echo "** A full bats test for "${IDOL_NAME}" : "${bats_category}" has been triggered." | tee -a ${LOG_OUT};
	echo "" | tee -a ${LOG_OUT};
	echo "========================================" | tee -a ${LOG_OUT};
	echo "Commencing full test for "${fullbats}" on Idol "${IDOL_NAME} | tee -a ${LOG_OUT};
	echo "" | tee -a ${LOG_OUT};
	bats ${FULL_BATS}/${fullbats} | tee -a ${LOG_OUT}
	echo "" | tee -a ${LOG_OUT};
	echo "Completed full bats test for "${IDOL_NAME}" : "${bats_category}"." | tee -a ${LOG_OUT};
}

handoff() {
    echo "idol_test.sh has been kicked off by idol_create.sh..." | tee -a ${LOG_OUT};
    echo "idol_test.sh is initiating hash and full bats tests..." | tee -a ${LOG_OUT};
    echo "idol name:	"${IDOL_NAME} | tee -a ${LOG_OUT};
    echo "" | tee -a ${LOG_OUT};
}

hash_bats_test() {

	local hash_bats_name=$(basename ${hashbats});
	IFS=_ read bats_category bats_type <<< ${hash_bats_name};
	echo "" | tee -a ${LOG_OUT};
	echo "========================================" | tee -a ${LOG_OUT};
	echo "Commencing hash test for "${hash_bats_name}" on Idol "${IDOL_NAME} | tee -a ${LOG_OUT};
	echo "" | tee -a ${LOG_OUT};
	if [[ $(bats ${hashbats} | tee -a ${LOG_OUT}) == *"not ok"* ]]; then
        echo ${hash_bats_name}" does not match the golden image for this Idol.  Full tests will be run." | tee -a ${LOG_OUT};
        full_bats_test ${bats_category};
    else
    	echo ${hash_bats_name}" matches the golden image for this Idol." | tee -a ${LOG_OUT};
    	echo "Completed hash bats test for "${IDOL_NAME}" : "${bats_category}"." | tee -a ${LOG_OUT};
	fi

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

#################################
##         READ INPUT:         ##
#################################

EXPECTED_ARGS=3;

if [ $# -ne ${EXPECTED_ARGS} ]; then
	echo "Something has gone wrong.  The script idol_test.sh expected 3 arguments from idol, but only received "$#".";
	exit 1;
fi


#################################
##        DECLARATIONS:        ##
#################################

IDOL_NAME=$1;
BASE_DIR=$2;
LOG_OUT=$3;

TEST_DIR=${BASE_DIR}/tests;
IDOL_DIR=${TEST_DIR}/${IDOL_NAME};
FULL_BATS=${IDOL_DIR}/full_bats;
HASH_BATS=${IDOL_DIR}/hash_bats;

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