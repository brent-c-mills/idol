#!/bin/bash

set -e;

cancel() {
    echo "" | tee -a ${LOG_OUT};
    echo "idol_delete.sh has been cancelled." | tee -a ${LOG_OUT};
    echo "idol "$IDOL_NAME" not deleted." | tee -a ${LOG_OUT};
    exit 1;
}

completion() {
    echo "" | tee -a ${LOG_OUT};
    echo "idol_delete.sh has successfully deleted idol "$IDOL_NAME | tee -a ${LOG_OUT};
    exit 0;
}

delete_idol() {
	echo "" | tee -a ${LOG_OUT};
	echo "========================================" | tee -a ${LOG_OUT};
	echo "Commencing deletion of "${IDOL_NAME} | tee -a ${LOG_OUT};

	rm -rf ${IDOL_DIR};
	completion;
}

handoff() {
    echo "idol_delete.sh has been kicked off by idol_create.sh..." | tee -a ${LOG_OUT};
    echo "idol name:	"$IDOL_NAME | tee -a ${LOG_OUT};
    echo "" | tee -a ${LOG_OUT};
}

verify_idol() {
	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a ${LOG_OUT};
	echo ""  | tee -a ${LOG_OUT};
	if [[ ! -e ${TEST_DIR}/${IDOL_NAME} ]]; then
		echo "Idol "${IDOL_NAME}" not found." | tee -a ${LOG_OUT}; 
		cancel;
	else
		echo "Idol "${IDOL_NAME}" verified." | tee -a ${LOG_OUT}; 
		echo "Preparing to delete..." | tee -a ${LOG_OUT}; 
	fi
}

warn_and_verify() {
	echo "";
	echo "";
	echo "	#########################################";
	echo "	##                                     ##";
	echo "	##            WARNING!                 ##";
	echo "	##   YOU ARE ABOUT TO DELETE AN IDOL   ##";
	echo "	##   THIS PROCESS CANNOT BE REVERSED   ##";
	echo "	##                                     ##";
	echo "	#########################################";
	echo "";
	echo "	IDOL NAME: "${IDOL_NAME};
	echo "	IDOL LOCATION: "${IDOL_DIR};
	echo "";
	echo "The above Idol and directory will be deleted.  This cannot be undone.";

	echo "Issued warning to user." >> ${LOG_OUT};

	read -p "Are you certain you want to proceed?  YES / [no] : " REPLY;
	echo "";

	case "$REPLY" in
		"YES" )
		    echo "Idol "${IDOL_NAME}" will be deleted.";
		    echo "User has elected to delete Idol "${IDOL_NAME}"." >> ${LOG_OUT};
		    delete_idol;
		    ;;
		"no" )
		    cancel;
		    ;;
	    "NO" )
			cancel;
			;;
		* )
		    echo $REPLY" is not a valid option.  All options are case-sensitive.";
		    cancel;
		    ;;
	esac

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

#################################
##       ACCEPT HANDOFF        ##
#################################
handoff;

#################################
##    VERIFY IDOL EXISTANCE    ##
#################################
verify_idol;


#################################
##       WARN AND VERIFY       ##
#################################
warn_and_verify;

#################################
##         DELETE IDOL         ##
#################################
delete_idol;
