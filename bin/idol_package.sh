#!/bin/bash

set -e;

alert_and_verify() {
	clear;
	echo "";
	echo "";
	echo "	#########################################";
	echo "	##                                     ##";
	echo "	##               ALERT!                ##";
	echo "	##     YOU CURRENTLY HAVE NO IDOLS.    ##";
	echo "	##  ARE YOU SURE YOU WANT TO PACKAGE?  ##";
	echo "	##                                     ##";
	echo "	#########################################";
	echo "";
	echo "";
	echo "Packging your Idol instance prepares a copy for delivery to a remote system.";
	echo "This is useful when testing remote systems against an Idol golden image.";

	echo "Issued alert to user." >> ${LOG_OUT};

	read -p "Are you certain you want to proceed?  [y/n] : " REPLY;
	echo "";

	case "$REPLY" in
		"y" | "Y" )
		    echo "Your Idol instance will be packaged.";
		    echo "User has elected to proceed with packaging." >> ${LOG_OUT};
		    package_idol;
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

cancel() {
    echo "" | tee -a ${LOG_OUT};
    echo "idol_package.sh has been cancelled." | tee -a ${LOG_OUT};
    echo "idol will not be packaged." | tee -a ${LOG_OUT};
    exit 1;
}

completion() {
    echo "" | tee -a ${LOG_OUT};
    echo "idol_package.sh has successfully packaged your Idol instance." | tee -a ${LOG_OUT};
    exit 0;
}

handoff() {
    echo "idol_package.sh has been kicked off by idol..." | tee -a ${LOG_OUT};
    echo "" | tee -a ${LOG_OUT};
}

package_idol_full() {
	echo "" | tee -a ${LOG_OUT};
	echo "========================================" | tee -a ${LOG_OUT};
	echo "Commencing packaging..." | tee -a ${LOG_OUT};

	read -e -p "Please specify a destination directory: ["${OUTPUT_DIR}"]"  REPLY;
	echo "";

	#Read the user's selected export path.
	if [[ ! -z $REPLY ]]; then
		eval OUTPUT_DIR=$REPLY;

		if [ ! "$(ls -A /$OUTPUT_DIR)" ]; then
			echo "ERROR:  Specified directory does not exist." | tee -a ${LOG_OUT};
			package_idol;
		fi
	fi


	echo "Resetting pre-installation variables..." >> ${LOG_OUT};
	sed -i -e "s+${BASE_DIR}+PLACEHOLD_BASE_DIR+g" ${BASE_DIR}/bin/idol;

	echo "Your packaged Idol instance will be output to "${OUTPUT_DIR}"/idol.tar.gz" | tee -a ${LOG_OUT};
	tar --exclude="${BASE_DIR}/bats" --exclude="${BASE_DIR}/.git" -cvzf "${OUTPUT_DIR}/idol.tar.gz" -C $(dirname "${BASE_DIR}") idol;

	echo "Resetting post-installation variables..." >> ${LOG_OUT};
	sed -i -e "s+PLACEHOLD_BASE_DIR+${BASE_DIR}+g" ${BASE_DIR}/bin/idol;

	completion;
}

package_idol_individual() {
	echo "" | tee -a ${LOG_OUT};
	echo "========================================" | tee -a ${LOG_OUT};
	echo "Commencing packaging..." | tee -a ${LOG_OUT};

	read -e -p "Please specify a destination directory: ["${OUTPUT_DIR}"]"  REPLY;
	echo "";

	#Read the user's selected export path.
	if [[ ! -z $REPLY ]]; then
		eval OUTPUT_DIR=$REPLY;

		if [ ! "$(ls -A /$OUTPUT_DIR)" ]; then
			echo "ERROR:  Specified directory does not exist." | tee -a ${LOG_OUT};
			package_idol;
		fi
	fi

	echo "Your packaged Idol will be output to "${OUTPUT_DIR}"/"${IDOL_NAME}".idol" | tee -a ${LOG_OUT};
	tar -cvzf "${OUTPUT_DIR}/${IDOL_NAME}.idol" -C ${TEST_DIR} ${IDOL_NAME};

	completion;
}

verify_idol_full() {
	echo "" | tee -a ${LOG_OUT};
	echo "Preparing for full package..." | tee -a ${LOG_OUT};
	if [ ! "$(ls -A /$TEST_DIR)" ]; then
		echo "No Idols found." | tee -a ${LOG_OUT};
		alert_and_verify;
	else
		package_idol_full;
	fi
}

verify_idol_individual() {
	
	if [[ -z "$3" ]]; then
		clear;
		echo "idol --package";
		echo "";
		echo "";
		echo "	#########################################";
		echo "	##                                     ##";
		echo "	##               ALERT!                ##";
		echo "	##        NO IDOL NAME SUPPLIED        ##";
		echo "	##   PLEASE SELECT AN IDOL TO PACKAGE  ##";
		echo "	##                                     ##";
		echo "	#########################################";

		echo "";
		echo "	Available Idols:";
		echo "";

		if [ ! "$(ls -A /${TEST_DIR})" ]; then
			echo "  NO IDOLS  ";
			alert_and_verify;
		else
			available=$(ls -1 ${TEST_DIR});
			for i in available[@]; do
			    echo "  "$available;
			done
		fi

		echo "";
		read -p "Please provide an Idol name: " REPLY;
		
		if [[ -z $REPLY ]]; then
			echo "No Idol specified.";
			cancel;
		fi
		IDOL_NAME=$REPLY;
	fi

	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a ${LOG_OUT};
	echo ""  | tee -a ${LOG_OUT};
	if [ ! -e ${TEST_DIR}/${IDOL_NAME} ]; then
		echo "Idol "${IDOL_NAME}" not found." | tee -a ${LOG_OUT};
		cancel;
	else
		package_idol_individual;
	fi
}

verify_package_type() {

	clear;
	echo "idol --package";
	echo "";
	echo "";
	echo "	#########################################";
	echo "	##                                     ##";
	echo "	##               ALERT!                ##";
	echo "	##   WHAT WOULD YOU LIKE TO PACKAGE?   ##";
	echo "	##  PLEASE SELECT FULL OR INDIVIDUAL   ##";
	echo "	##                                     ##";
	echo "	#########################################";

	echo "";
	echo "  An individual package will only include 1 Idol golden image.";
	echo "  A full package will include all Idol golden images and an instance of Idol.";
	echo "";

	read -p "What would you like to do?  [full / individual] : " REPLY;
	echo "";

	case "$REPLY" in
		"full" | "Full"  | "FULL")
		    echo "Your full Idol instance will be packaged.";
		    echo "User has elected to package a full Idol instance." >> ${LOG_OUT};
		    verify_idol_full;
		    ;;
		"individual" | "Individual" | "INDIVIDUAL")
		    verify_idol_individual;
		    ;;
		* )
		    echo $REPLY" is not a valid option.  Please enter only \"full\" or \"individual\".";
		    cancel;
		    ;;
	esac

}

#################################
##         READ INPUT:         ##
#################################

EXPECTED_ARGS=2;

if [ $# -lt $EXPECTED_ARGS ]; then
	echo "Something has gone wrong.  The script idol_test.sh expected at least "${EXPECTED_ARGS}" arguments from idol, but only received "$#"." | tee -a ${LOG_OUT};
	cancel;
fi


#################################
##        DECLARATIONS:        ##
#################################

BASE_DIR=$1;
LOG_OUT=$2;
IDOL_NAME=$3;

TEST_DIR=${BASE_DIR}/tests;
OUTPUT_DIR=~;

#################################
##       ACCEPT HANDOFF        ##
#################################
handoff;

#################################
##    DETERMINE PACKAGE TYPE   ##
#################################

verify_package_type;
