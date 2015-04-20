#!/bin/bash

set -e;

alert_and_verify() {
	clear;
	echo "";
	echo "";
	echo "	#########################################";
	echo "	##                                     ##";
	echo "	##               ALERT!                ##";
	echo "	##  IDOL WITH THAT NAME ALREADY EXISTS ##";
	echo "	##      DO YOU WISH TO OVERWRITE?      ##";
	echo "	##                                     ##";
	echo "	#########################################";
	echo "";
	echo "";
	
	echo "Issued alert to user." >> ${CURRENT_LOG};

	read -p "Do you wish to overwrite the existing Idol?  [y/n] : " REPLY;
	echo "";

	case "$REPLY" in
		"y" | "Y" )
			echo "User has elected to overwrite the existing Idol." >> ${CURRENT_LOG};
		    echo "The Idol "${IDOL_NAME}" will be overwritten." | tee -a ${CURRENT_LOG};
		    rm -rf ${TEST_DIR}/${IDOL_NAME};
		    import_idol;
		    ;;
		"n" | "N")
		    cancel;
		    ;;
		* )
		    echo $REPLY" is not a valid option.  Please enter only \"y\" or \"n\".";
		    cancel;
		    ;;
	esac
}

handoff() {
    echo "idol_import.sh has been kicked off by idol.sh..." | tee -a ${CURRENT_LOG};
    echo "idol_import.sh is initiating hash and full bats tests..." | tee -a ${CURRENT_LOG};
    echo "" | tee -a ${CURRENT_LOG};
}

cancel() {
    echo "" | tee -a ${CURRENT_LOG};
    echo "idol_import.sh has been cancelled." | tee -a ${CURRENT_LOG};
    echo "The idol will not be imported" | tee -a ${CURRENT_LOG};
    exit 1;
}

completion() {
    echo "" | tee -a ${CURRENT_LOG};
    echo "idol_import.sh has successfully imported idol "$IDOL_NAME | tee -a ${CURRENT_LOG};
    exit 0;
}

get_idol() {
	clear;
	echo "idol --package";
	echo "";
	echo "";
	echo "	#########################################";
	echo "	##                                     ##";
	echo "	##               ALERT!                ##";
	echo "	##   THIS TOOL IMPORTS PACKAGED IDOLS  ##";
	echo "	##    PROVIDE THE IDOL NAME AND PATH   ##";
	echo "	##                                     ##";
	echo "	#########################################";
	echo "";
	read -p "Please provide the full path to the Idol (\"/home/user1/centos.idol\"): " REPLY;
	
	if [[ -e $REPLY && $REPLY =~ \.idol$ ]]; then
		IDOL_NAME_LOCATION=$REPLY;
		verify_idol_existing;
	else
		echo "The specified file does not exist or is not an Idol." | tee -a ${CURRENT_LOG};
		cancel;
	fi
}

verify_idol_existing() {
	IDOL_PACKAGE_NAME=$(basename $IDOL_NAME_LOCATION);
	IDOL_NAME=${IDOL_PACKAGE_NAME%.idol};

	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a ${CURRENT_LOG};
	echo ""  | tee -a ${CURRENT_LOG};
	if [[ -e ${TEST_DIR}/${IDOL_NAME} ]]; then
		alert_and_verify;
	else
		import_idol; 
	fi
}

import_idol() {
	tar -xzvf ${IDOL_NAME_LOCATION} -C ${TEST_DIR}/
	completion;
}

#################################
##         READ INPUT:         ##
#################################

EXPECTED_ARGS=2;

if [ $# -ne $EXPECTED_ARGS ]; then
	echo "Something has gone wrong.  The script idol_test.sh expected 2 arguments from idol, but only received "$#".";
	cancel;
fi

#################################
##        DECLARATIONS:        ##
#################################
CURRENT_LOG=$1;
TEST_DIR=$2;

#################################
##       ACCEPT HANDOFF        ##
#################################
handoff;

#################################
##    VERIFY IDOL LOCATION     ##
#################################
get_idol;

#################################
##         COMPLETION          ##
#################################
completion;
