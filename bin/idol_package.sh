#!/bin/bash

set -e;

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

package_idol() {
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

verify_idol() {
	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a ${LOG_OUT};
	echo ""  | tee -a ${LOG_OUT};
	if [ ! "$(ls -A /$TEST_DIR)" ]; then
		echo "No Idols found." | tee -a ${LOG_OUT};
		alert_and_verify;
	else
		package_idol;
	fi
}

alert_and_verify() {
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
		    echo "Idol will be packaged.";
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

#################################
##         READ INPUT:         ##
#################################

EXPECTED_ARGS=2;

if [ $# -ne $EXPECTED_ARGS ]; then
	echo "Something has gone wrong.  The script idol_test.sh expected 2 arguments from idol, but only received "$#".";
	exit 1;
fi


#################################
##        DECLARATIONS:        ##
#################################

BASE_DIR=$1;
LOG_OUT=$2;

TEST_DIR=$BASE_DIR/tests;
OUTPUT_DIR=~;

#################################
##       ACCEPT HANDOFF        ##
#################################
handoff;

#################################
##    VERIFY IDOL EXISTANCE    ##
#################################
verify_idol;
