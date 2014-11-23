#!/bin/bash

set -e;
clear;

INSTALL_LOG="/tmp/idol_install.log";
rm -f $INSTALL_LOG;
touch $INSTALL_LOG;

#################################
##         FUNCTIONS!:         ##
#################################

cancel_install() {
	echo "Cancelling installation." | tee -a $INSTALL_LOG;
	echo "For help, please contact brent.c.mills@gmail.com.";
	mv $INSTALL_LOG $BASE_DIR/log/install.log;
	exit 1;
}

install_bats() {
	#Check if BATS installation files exist in the idol/bin/bats_current directory.
	if [ ! -e $BASE_DIR/bin/bats_current/bats_master.tar.gz ]; then
    	echo "BATS installer files not found." | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Prompt user to input a new installation path for BATS (Default is /opt/bats)
	read -e -p "Please specify an input directory for BATS. [~/bats] " REPLY;
	echo "";

	#Read the user's selected installation path.
	if [[ -z $REPLY ]];
	then
	    BATS_PATH="${`HOME`}/bats";
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
	tar -zxvf $BASE_DIR/bin/bats_current/bats_master.tar.gz -C $BATS_PATH/;
	#Verify that BATS files were successfully expanded into installation directory.
	if [[ $? -ne 0 ]]; then
    	echo "Unable expand BATS files into "$BATS_PATH | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	#Export bats to $PATH
	echo "export PATH="${BATS_PATH}/bin:"\$PATH" >> ~/.bash_profile;
	source ~/.bash_profile;
	. ~/.bash_profile;	

	#Run BATS installation script.
	$BATS_PATH/install.sh /usr/local/bin/bats;
	#Verify that BATS was installed successfully.
	if [[ $? -ne 0 ]]; then
    	echo "BATS installation failed..." | tee -a $INSTALL_LOG;
    	cancel_install;
	fi

	echo "BATS was successfully installed to "$BATS_PATH"." | tee -a $INSTALL_LOG;
}

locate_bats() {
	read -e -p "Please point us to the base BATS directory (ie: \"/opt/bats\"): " REPLY;
	echo "";

	#Read the user's selected installation path.
	if [[ -z $REPLY ]];
	then
	    BATS_PATH="/opt/bats";
	    echo "BATS will be installed in "$BATS_PATH | tee -a $INSTALL_LOG;
	    exit 0;
	else
	    echo "No directory specified." | tee -a $INSTALL_LOG;
	    cancel_install;
	fi

	if [[ -e ${BATS_PATH}/bin/bats ]]; then
        echo "BATS installation found..." | tee -a $INSTALL_LOG;
        echo "Adding BATS to \$PATH..." | tee -a $INSTALL_LOG;

        #Adding $BATS_PATH/bin/bats to the $PATH.
        echo "export PATH="${BATS_PATH}/bin/bats:${PATH} >> ~/.bash_profile;
		source ~/.bash_profile;

	else
		echo "Unable to locate the BATS executable at "${BATS_PATH}"/bin/bats." | tee -a $INSTALL_LOG;
		cancel_install;
	fi
}

#################################
##    FIND BASE DIRECTORY:     ##
#################################
echo "Determining installation directory..." | tee -a $INSTALL_LOG;
BASE_DIR="`pwd`";


#################################
##       CHECK FOR BATS:       ##
#################################
if [[ ! -e /usr/local/bin/bats ]]; then
	echo "";
	echo "A BATS install could not be found...";
	echo "What would you like to do?";
	echo "";
	echo "1) Install a new copy of BATS 0.4.0";
	echo "2) Provide the install location of a current copy of BATS";
	echo "3) Cancel Installation"
	echo "";

	read -p "Please select an option... " -n 1 -r;
	echo "";

	case "$REPLY" in
		"1" )
		    echo "Installing a new copy of BATS...";
		    install_bats;
		    ;;
		"2" )
		    echo "Time to follow the guano!";
		    locate_bats;
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

echo "Checking for idol directory structure .bats file..." | tee -a $INSTALL_LOG;
if [[ ! -e ${BASE_DIR}/lib/idol.bats ]]; then
	echo "Idol directory structure .bats file could not be found." | tee -a $INSTALL_LOG;
	cancel_install;
fi

echo "Executing BATS test against idol directory structure..." | tee -a $INSTALL_LOG;
echo "" | tee -a $INSTALL_LOG;
bats $BASE_DIR/lib/idol.bats | tee -a $INSTALL_LOG; 

if (grep "not ok" ${INSTALL_LOG} >> /dev/null); then
        echo "Idol directory structure is not intact.  See ./log/install.log for more information.";
        cancel_install;
fi

#################################
##   EDIT BASE_DIR IN IDOL:    ##
#################################

#Modify the BASE_DIR variable in the idol script.  This allows idol to determine the appropriate path to all associated scripts.
sed -i -e 's/PLACEHOLD_BASE_DIRECTORY/'$BASE_DIR'/g' ./bin/idol;

#################################
##          EDIT PATH:         ##
#################################

#Add the idol script to the $PATH.
echo "export PATH="${BASE_DIR}/bin/idol:${PATH} >> ~/.bash_profile;
source ~/.bash_profile;


#################################
##          COMPLETION         ##
#################################

echo "Installation completed successfully." | tee -a $INSTALL_LOG;
mv $INSTALL_LOG $BASE_DIR/log/install.log;
exit 0;
