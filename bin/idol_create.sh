#!/bin/bash

set -e

create_idol_dir() {
	mkdir ${IDOL_DIR};
	mkdir ${FULL_BATS};
	mkdir ${HASH_BATS};
}

create_idol_readme() {
	echo "IDOL INFORMATION:" >> ${IDOL_DIR}/README.txt;
	echo "" >> ${IDOL_DIR}/README.txt;
	echo "NAME:"${IDOL_NAME}  >> ${IDOL_DIR}/README.txt;
	echo "OS:"${OPERATING_SYSTEM}  >> ${IDOL_DIR}/README.txt;
	echo "DATE:"$(date +"%m_%d_%Y") >> ${IDOL_DIR}/README.txt;
	echo "AUTHOR:"$"`whoami`" >> ${IDOL_DIR}/README.txt;

}

copy_bats_requirements() {
	cp -r ${LIB_DIR}/fixtures ${FULL_BATS}/;
	cp -r ${LIB_DIR}/test_helper.bash ${FULL_BATS}/;
	mkdir ${FULL_BATS}/tmp;
	cp -r ${LIB_DIR}/fixtures ${HASH_BATS}/;
	cp -r ${LIB_DIR}/test_helper.bash ${HASH_BATS}/;
	mkdir ${HASH_BATS}/tmp;

}

create_bats_tests(){
	BATS_CATEGORY=( "package" "user" "group" "environment" "chef" "gem" );

	for i in "${BATS_CATEGORY[@]}"
	do
		echo "Generating "$i"-related BATS files for "${IDOL_NAME}"..." | tee -a ${CURRENT_LOG};
		${BIN_DIR}/${i}_full_${OPERATING_SYSTEM}.sh ${FULL_BATS} ${IDOL_NAME} ${CURRENT_LOG};
		${BIN_DIR}/${i}_hash_${OPERATING_SYSTEM}.sh ${HASH_BATS} ${IDOL_NAME} ${CURRENT_LOG};
		echo "Finished generating "$i"-related BATS files for "${IDOL_NAME}"..." | tee -a ${CURRENT_LOG};
		echo "";

	done
}

#################################
##         READ INPUT:         ##
#################################
EXPECTED_ARGS=7

if [ $# -ne $EXPECTED_ARGS ]
then
	echo "Something has gone wrong.  The script idol_create.sh expected 4 arguments from idol.sh, but only received "$#".";
	exit 1;
fi

#################################
##        DECLARATIONS:        ##
#################################
OPERATING_SYSTEM=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;
BASE_DIR=$4;
BIN_DIR=$5;
LIB_DIR=$6;
TEST_DIR=$7;

IDOL_DIR=${TEST_DIR}/${IDOL_NAME};
FULL_BATS=${IDOL_DIR}/full_bats;
HASH_BATS=${IDOL_DIR}/hash_bats;

#################################
##    CREATE IDOL AND BATS     ##
#################################

#CREATING IDOL (BATS TEST DIRECTORY)...
create_idol_dir

#CREATE A IDOL-SPECIFIC README WITH SOME BASIC INFORMATION
create_idol_readme

#COPY NEEDED FILES INTO IDOL DIRECTORY...
copy_bats_requirements

#CREATE BATS TESTS BY CATEGORY
create_bats_tests
