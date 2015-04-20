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

	echo "Issued alert to user." >> ${CURRENT_LOG};

	read -p "Are you certain you want to proceed?  [y/n] : " REPLY;
	echo "";

	case "$REPLY" in
		"y" | "Y" )
		    echo "Your Idol instance will be packaged.";
		    echo "User has elected to proceed with packaging." >> ${CURRENT_LOG};
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
    echo "" | tee -a ${CURRENT_LOG};
    echo "idol_package.sh has been cancelled." | tee -a ${CURRENT_LOG};
    echo "idol will not be packaged." | tee -a ${CURRENT_LOG};
    exit 1;
}

completion() {
    echo "" | tee -a ${CURRENT_LOG};
    echo "idol_package.sh has successfully packaged your Idol instance." | tee -a ${CURRENT_LOG};
    exit 0;
}

handoff() {
    echo "idol_package.sh has been kicked off by idol..." | tee -a ${CURRENT_LOG};
    echo "" | tee -a ${CURRENT_LOG};
}

package_idol_full() {
	echo "" | tee -a ${CURRENT_LOG};
	echo "========================================" | tee -a ${CURRENT_LOG};
	echo "Commencing packaging..." | tee -a ${CURRENT_LOG};

	read -e -p "Please specify a destination directory: ["${OUTPUT_DIR}"]"  REPLY;
	echo "";

	#Read the user's selected export path.
	if [[ ! -z $REPLY ]]; then
		eval OUTPUT_DIR=$REPLY;

		if [ ! "$(ls -A /$OUTPUT_DIR)" ]; then
			echo "ERROR:  Specified directory does not exist." | tee -a ${CURRENT_LOG};
			package_idol;
		fi
	fi

	echo "Resetting pre-installation variables..." >> ${CURRENT_LOG};
	sed -i -e "s+${BASE_DIR}+PLACEHOLD_BASE_DIR+g" ${BASE_DIR}/bin/idol;

	echo "Your packaged Idol instance will be output to "${OUTPUT_DIR}"/idol.tar.gz" | tee -a ${CURRENT_LOG};
	tar --exclude="${BASE_DIR}/bats" --exclude="${BASE_DIR}/.git" -cvzf "${OUTPUT_DIR}/idol.tar.gz" -C $(dirname "${BASE_DIR}") idol;

	echo "Resetting post-installation variables..." >> ${CURRENT_LOG};
	sed -i -e "s+PLACEHOLD_BASE_DIR+${BASE_DIR}+g" ${BASE_DIR}/bin/idol;

	completion;
}

package_idol_individual() {
	echo "" | tee -a ${CURRENT_LOG};
	echo "========================================" | tee -a ${CURRENT_LOG};
	echo "Commencing packaging..." | tee -a ${CURRENT_LOG};

	read -e -p "Please specify a destination directory: ["${OUTPUT_DIR}"]"  REPLY;
	echo "";

	#Read the user's selected export path.
	if [[ ! -z $REPLY ]]; then
		eval OUTPUT_DIR=$REPLY;

		if [ ! "$(ls -A /$OUTPUT_DIR)" ]; then
			echo "ERROR:  Specified directory does not exist." | tee -a ${CURRENT_LOG};
			package_idol;
		fi
	fi

	echo "Your packaged Idol will be output to "${OUTPUT_DIR}"/"${IDOL_NAME}".idol" | tee -a ${CURRENT_LOG};
	tar -cvzf "${OUTPUT_DIR}/${IDOL_NAME}.idol" -C ${TEST_DIR} ${IDOL_NAME};

	completion;
}

verify_idol_full() {
	echo "" | tee -a ${CURRENT_LOG};
	echo "Preparing for full package..." | tee -a ${CURRENT_LOG};
	if [ ! "$(ls -A /$TEST_DIR)" ]; then
		echo "No Idols found." | tee -a ${CURRENT_LOG};
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
		echo "${bold}			CURRENT IDOLS	${normal}";
		echo "";

		if [ ! "$(ls -A /$1)" ]; then
			echo "  NO IDOLS  ";
			cancel;
		else
			printf "${bold}%-15s | %-15s | %-15s | %-15s\n " "  IDOL" "OS" "DATE" "AUTHOR";
			echo "${normal}------------------------------------------------------------";

			available=(`ls -1 ${TEST_DIR}`);
			for i in ${available[@]}; do
			    IDOLNAME=$(grep "NAME" ${TEST_DIR}/${i}/README.txt | awk -F':' '{ print $2 }');
				IDOLOS=$(grep "OS:" ${TEST_DIR}/${i}/README.txt | awk -F':' '{ print $2 }');
				IDOLDATE=$(grep "DATE" ${TEST_DIR}/${i}/README.txt | awk -F':' '{ print $2 }');
				IDOLAUTHOR=$(grep "AUTHOR" ${TEST_DIR}/${i}/README.txt | awk -F':' '{ print $2 }');

				printf "%-15s | %-15s | %-15s | %-15s\n" "  "${IDOLNAME} ${IDOLOS} ${IDOLDATE} ${IDOLAUTHOR};
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

	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a ${CURRENT_LOG};
	echo ""  | tee -a ${CURRENT_LOG};
	if [ ! -e ${TEST_DIR}/${IDOL_NAME} ]; then
		echo "Idol "${IDOL_NAME}" not found." | tee -a ${CURRENT_LOG};
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
		    echo "User has elected to package a full Idol instance." >> ${CURRENT_LOG};
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
	echo "Something has gone wrong.  The script idol_test.sh expected at least "${EXPECTED_ARGS}" arguments from idol, but only received "$#"." | tee -a ${CURRENT_LOG};
	cancel;
fi

#################################
##        DECLARATIONS:        ##
#################################
CURRENT_LOG=$1;
BASE_DIR=$2;
TEST_DIR=$3;

OUTPUT_DIR=~;

#################################
##       ACCEPT HANDOFF        ##
#################################
handoff;

#################################
##    DETERMINE PACKAGE TYPE   ##
#################################
verify_package_type;
