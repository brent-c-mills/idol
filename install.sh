#!/bin/bash

set -e;
clear;

cancel_install() {
	echo "Cancelling installation." | tee -a $INSTALL_LOG;
	echo "For help, please contact brent.c.mills@gmail.com.";
	exit 1;
}

check_bats() {
	if (! echo $PATH | grep "/bats/bin" >> /dev/null); then
		clear;
		echo "";
		echo "	#########################################";
		echo "	##                                     ##";
		echo "	##               ALERT!                ##";
		echo "	##       NO BATS INSTANCE FOUND        ##";
		echo "	##   WOULD YOU LIKE TO INSTALL ONE?    ##";
		echo "	##                                     ##";
		echo "	#########################################";
		echo "";

		read -p "Please select an option. [Y/N] " -n 1 -r;
		echo "";

		case "$REPLY" in
			"Y" | "YES" | "y" | "yes" )
			    echo "Installing a new copy of BATS...";
			    install_bats;
			    ;;
		    "N" | "NO" | "n" | "no" )
				cancel_install;
				;;
			* )
			    echo $REPLY" is not a valid option.";
			    cancel_install;
			    ;;
		esac
	fi
}

completion() {
	echo "";
	echo "Installation completed successfully." | tee -a $INSTALL_LOG;
	echo "Please log out or reboot before using Idol.";
	exit 0;
}

install_bats() {
	clear;
	echo "";
	#Check if BATS installation files exist in the idol/bin/bats_current directory.
	if [ ! -e $BASE_DIR/lib/bats_current/bats_master.tar.gz ]; then
    	echo "BATS installer files not found." | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Prompt user to input a new installation path for BATS (Default is ${BASE_DIR}/bats).
	read -e -p "Please specify an input directory for BATS: ["${BASE_DIR}"/bats]"  REPLY;
	echo "";

	#Read the user's selected installation path.
	if [[ -z $REPLY ]];
	then
	    BATS_PATH=${BASE_DIR}/bats;
	    echo "BATS will be installed in "$BATS_PATH | tee -a $INSTALL_LOG;
	else
		eval BATS_PATH=$REPLY;
	    echo "BATS will be installed in "$BATS_PATH | tee -a $INSTALL_LOG;
	fi

	#Check if specified installation path already exists.  Exit installation if it does.
	if [[ -e $BATS_PATH ]]; then
    	echo $BATS_PATH" already exists." | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Create BATS installation directory.
	echo "Creating BATS installation directory." | tee -a $INSTALL_LOG
	mkdir $BATS_PATH;
	#Verify that BATS installation directory was created successfully.
	if [[ $? -ne 0 ]]; then
    	echo "Unable to create directory "$BATS_PATH | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Expand BATS files into installation directory.
	tar -zxvf $BASE_DIR/lib/bats_current/bats_master.tar.gz -C $BATS_PATH/;
	#Verify that BATS files were successfully expanded into installation directory.
	if [[ $? -ne 0 ]]; then
    	echo "Unable to expand BATS files into "$BATS_PATH | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Export bats to $PATH
	echo "export PATH="${BATS_PATH}/bin:"\$PATH" >> ~/.bash_profile;
	source ~/.bash_profile; #Works on some systems.
	. ~/.bash_profile; #Works on some systems.

	echo "BATS was successfully installed to "$BATS_PATH"." | tee -a $INSTALL_LOG;
}

install_idol() {
	mkdir -p ${BASE_DIR}/log;
	mkdir -p ${BASE_DIR}/tests;
}

test_bats_install() {
	if [[ "$(uname)" -ne "Darwin" ]]; then
		echo "";
		echo "Testing BATS installation." | tee -a ${INSTALL_LOG};
		bats ${BATS_PATH}/test/bats.bats | tee -a $INSTALL_LOG;

		if (grep "not ok" ${INSTALL_LOG} >> /dev/null); then
		        echo "BATS installation failed.  See ./log/install.log for more information.";
		        cancel_install;
		fi
	fi
}

test_idol_install() {
	echo "";
	echo "Checking for idol directory structure .bats file." | tee -a ${INSTALL_LOG};
	if [[ ! -e ${BASE_DIR}/lib/idol.bats ]]; then
		echo "Idol directory structure .bats file could not be found." | tee -a ${INSTALL_LOG};
		cancel_install;
	fi

	echo "Executing BATS test against idol directory structure." | tee -a ${INSTALL_LOG};
	echo "" | tee -a ${INSTALL_LOG};
	bats ${BASE_DIR}/lib/idol.bats | tee -a ${INSTALL_LOG}; 

	if (grep "not ok" ${INSTALL_LOG} >> /dev/null); then
	        echo "Idol directory structure is not intact.  See ./log/install.log for more information.";
	        cancel_install;
	fi
}

#################################
##    FIND BASE DIRECTORY:     ##
#################################
echo "Determining installation directory..." | tee -a ${INSTALL_LOG};
BASE_DIR="`pwd`";
BIN_DIR=${BASE_DIR}/bin;
LIB_DIR=${BASE_DIR}/lib;
LOG_DIR=${BASE_DIR}/log;
TEST_DIR=${BASE_DIR}/tests;
MAN_DIR=${BASE_DIR}/man;

#################################
##     CREATE INSTALL LOG:     ##
#################################

INSTALL_LOG=${BASE_DIR}/log/install.log;
rm -f ${INSTALL_LOG};
mkdir -p "$(dirname ${INSTALL_LOG})" && touch ${INSTALL_LOG};

#################################
##       CHECK FOR BATS:       ##
#################################
BATS_PATH=${BASE_DIR}/bats;
check_bats;

#################################
##     CHECK BATS INSTALL:     ##
#################################
test_bats_install;

#################################
##  CHECK IDOL FILESTRUCTURE:  ##
#################################
install_idol;

#################################
##  CHECK IDOL FILESTRUCTURE:  ##
#################################
test_idol_install;

#################################
##   DEFINE IDOL CONFIG FILE   ##
#################################
CONFIG_FILE=${BASE_DIR}/config/idol.config;
sed -i -e "s+PLACEHOLD_CONFIG_FILE+${CONFIG_FILE}+g" ${BASE_DIR}/bin/idol;

#################################
##      BUILD CONFIG FILE      ##
#################################
sed -i -e "s+PLACEHOLD_BASE_DIR+${BASE_DIR}+g" ${BASE_DIR}/config/idol.config;
sed -i -e "s+PLACEHOLD_BIN_DIR+${BIN_DIR}+g" ${BASE_DIR}/config/idol.config;
sed -i -e "s+PLACEHOLD_LIB_DIR+${LIB_DIR}+g" ${BASE_DIR}/config/idol.config;
sed -i -e "s+PLACEHOLD_LOG_DIR+${LOG_DIR}+g" ${BASE_DIR}/config/idol.config;
sed -i -e "s+PLACEHOLD_TEST_DIR+${TEST_DIR}+g" ${BASE_DIR}/config/idol.config;
sed -i -e "s+PLACEHOLD_MAN_DIR+${MAN_DIR}+g" ${BASE_DIR}/config/idol.config;

#################################
##          EDIT PATH:         ##
#################################
echo "export PATH="${BASE_DIR}/bin:"\$PATH" >> ~/.bash_profile;
source ~/.bash_profile; #Works on some systems.
. ~/.bash_profile; #Works on some systems.

#################################
##          COMPLETION         ##
#################################
completion;
