#!/bin/bash

set -e;
clear;

INSTALL_LOG="/tmp/idol_tmp_log.log";
touch $INSTALL_LOG;

cancel_install() {
	echo "Cancelling installation." | tee -a $INSTALL_LOG;
	echo "For help, please contact brent.c.mills@gmail.com.";
	exit 1;
}

install_bats() {
	#Check if BATS installation files exist in the idol/bin/bats_current directory.
	if [ ! -e $BASE_DIR/bin/bats_current/bats_master.tar.gz ]; then
    	echo "BATS installer files not found." | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Prompt user to input a new installation path for BATS (Default is /opt/bats)
	read -e -p "Please specify an input directory for BATS. [/opt/bats] " REPLY;
	echo "";

	#Read the user's selected installation path.
	if [[ -z $REPLY ]];
	then
	    BATS_PATH="/opt/bats";
	    echo "BATS will be installed in "$BATS_PATH | tee -a $INSTALL_LOG;
	    exit 0;
	else
		eval BATS_PATH=$REPLY;
	    echo "BATS will be installed in "$BATS_PATH | tee -a $INSTALL_LOG;
	    exit 0;
	fi

	#Check if specified installation path already exists.  Exit installation if it does.
	if [[ -e $BATS_PATH ]]; then
    	echo $BATS_PATH" already exists." | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Create BATS installation directory.
	mkdir $BATS_PATH;
	#Verify that BATS installation directory was created successfully.
	if [[ $? -ne 0 ]]; then
    	echo "Unable to create directory "$BATS_PATH | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Expand BATS files into installation directory.
	tar -zxvf $BASE_DIR/bin/bats_current/bats_master.tar.gz -C $BATS_PATH/;
	#Verify that BATS files were successfully expanded into installation directory.
	if [[ $? -ne 0 ]]; then
    	echo "Unable expand BATS files into "$BATS_PATH | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Export bats to $PATH
	echo "export PATH="${BATS_PATH}/bin/bats:${PATH} >> ~/.bash_profile;
	source ~/.bash_profile;

	#Run BATS installation script.
	$BATS_PATH/install.sh;
	#Verify that BATS was installed successfully.
	if [[ $? -ne 0 ]]; then
    	echo "BATS installation failed..." | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	echo "BATS was successfully installed to "$BATS_PATH"." | tee -a $INSTALL_LOG;
}

locate_bats() {

}


#################################
##    FIND BASE DIRECTORY:     ##
#################################
echo "Determining installation directory..." | tee -a $INSTALL_LOG;
BASE_DIR="`pwd`";


#################################
##       CHECK FOR BATS:       ##
#################################
bats
if [[ $? -eq 1 ]]; then
	echo "A BATS install could not be found...";
	echo "What would you like to do?";
	echo "1) Install a new copy of BATS 0.4.0";
	echo "2) Provide the install location of a current copy of BATS";
	echo "3) Cancel Installation"

	read -p "Please select an option... " -n 1 -r;
	echo "";

	case "$REPLY" in
		"1" )
		    echo "Installing a new copy of BATS...";
		    install_bats;
		    ;;
		"2" )
		    echo "BATS EXISTS.  Need to find that sucker...";
		    ;;
	    "3" )
			cancel_install;
			;;
		* )
		    echo $REPLY" is not a valid option.";
		    cancel_install;
		    ;;
	esac

fi

#################################
##  CHECK IDOL FILESTRUCTURE:  ##
#################################


#################################
##   EDIT BASE_DIR IN IDOL:    ##
#################################
sed -i -e 's/PLACEHOLD_BASE_DIRECTORY/'$BASE_DIR'/g' ./bin/idol;

#################################
##          EDIT PATH:         ##
#################################
