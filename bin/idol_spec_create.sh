#!/bin/bash

set -e

#################################
##          FUNCTIONS          ##
#################################



#################################
##         READ INPUT:         ##
#################################

EXPECTED_ARGS=4

if [ $# -ne $EXPECTED_ARGS ]
then
	echo "Something has gone wrong.  The script idol_spec_create.sh expected 4 arguments from idol.sh, but only received "$#".";
	exit 1;
fi

#################################
##        DECLARATIONS:        ##
#################################

OPERATING_SYSTEM=$1;
IDOL_SPEC_NAME=$2;
BASE_DIR=$3;
CURRENT_LOG=$4;



NOW=$(date +"%m_%d_%Y_%H%M%S");
BIN_DIR=$BASE_DIR/bin;
LIB_DIR=$BASE_DIR/lib;
MAN_DIR=$BASE_DIR/man;
IDOL_DIR=$TEST_DIR/$IDOL_NAME;
FULL_BATS=$IDOL_DIR/full_bats;
HASH_BATS=$IDOL_DIR/hash_bats;


#################################
##   CREATE SERVERSPEC TESTS   ##
#################################

#CREATING SERVERSPEC TEST DIRECTORY

create_serverspec_dir;

#UPDATE IDOL-SPECIFIC README TO INCLUDE SERVERSPEC

update_idol_readme;

#COPY NEEDED FILES INTO SERVERSPEC DIRECTORY...

copy_serverspec_requirements;

#COMPLETION

output_results;
completion;