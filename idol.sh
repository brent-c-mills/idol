#!/bin/bash

clear

### GLOBAL DECLARATIONS:

#Declaring Directory Locations
	BASE_DIR="`pwd`"
	NOW=$(date +"%m_%d_%Y_%H%M%S")
	BIN_DIR=$BASE_DIR/bin
	LIB_DIR=$BASE_DIR/lib
	LOG_DIR=$BASE_DIR/log
	LOG_OUT=$LOG_DIR/log_$NOW.txt
	TEST_DIR=$BASE_DIR/tests
	MAN_DIR=$BASE_DIR/man

### END DECLARATIONS


#VERIFY INPUT
	{
	if [[ -z "$1" ]]; then
		echo "No argument supplied.  Run idol.sh -h for help and usage." | tee -a $LOG_OUT;
		exit 1;
	fi
	}

	{
	if [[ "$1" -ne "-h" ]] && [[ "$1" -ne "--help" ]] && [[ "$1" -ne "-c" ]] && [[ "$1" -ne "--create" ]] && [[ "$1" -ne "-l" ]] && [[ "$1" -ne "--list" ]] && [[ "$1" -ne "-p" ]] && [[ "$1" -ne "--package" ]] && [[ "$1" -ne "-t" ]] && [[ "$1" -ne "--test" ]]; then
		echo "Invalid input.  Run idol.sh -h for help and usage." | tee -a $LOG_OUT;
		exit 2;
	fi
	}

#READ INPUT AND OUTPUT HELP IF NEEDED

#Output help message
	{
	if [[ "$1" = "-h" ]] || [[ "$1" = "help" ]] ; then
		$MAN_DIR/idol_man.sh;
		exit 0;
	fi
	}

#Output list of current golden images

	{
	if [[ "$1" = "-l" ]] || [[ "$1" = "list" ]]; then
		$BIN_DIR/list_idols.sh $TEST_DIR;
		exit 0;
	fi
	}

#CREATE NEW IDOL
	{
	if [[ "$1" = "-c" ]] || [[ "$1" = "create" ]]; then
		IDOL_NAME=$2;

		if [[ -a /etc/centos-release ]] || [[ -a /etc/redhat-release ]]; then
			echo "Host OS recognized as CentOS / Redhat." | tee -a $LOG_OUT;
			OPERATING_SYSTEM="centos";

		elif [[ -a /etc/os-release ]]; then
			echo "Host OS recognized as Debian / Ubuntu." | tee -a $LOG_OUT;
			OPERATING_SYSTEM="ubuntu";

		elif [[ "$(uname)" -eq "Darwin" ]]; then
			echo "Host OS recognized as Apple OS X." | tee -a $LOG_OUT;
			OPERATING_SYSTEM="darwin";
		else echo "Sorry.  This operating system is not supported at this time." | tee -a $LOG_OUT; exit 5;
		fi
		
		$BIN_DIR/idol_create.sh $OPERATING_SYSTEM $IDOL_NAME $BASE_DIR $LOG_OUT
		exit 0;
	fi
	}

#TEST EXISTING IDOL
	{
	if [[ "$1" -eq "-t" ]] || [[ "$1" = "test" ]]; then
		IDOL_NAME=$2;
		echo "Verifying Idol "${IDOL_NAME}"..." | tee -a $LOG_OUT;
		if [[ -e ${TEST_DIR}/${IDOL_NAME} ]]; then
			echo "Initiating BATS tests on Idol "${IDOL_NAME}"." | tee -a $LOG_OUT;
			bats ${TEST_DIR}/${IDOL_NAME}
			exit 0;
		else
			echo "Idol "${IDOL_NAME}" not found." | tee -a $LOG_OUT; exit 6;
		fi
	fi	
	}

#PACKAGE IDOL INSTANCE FOR REMOTE USE
	{
	if [[ "$1" -eq "-p" ]] || [[ "$1" -eq "package" ]]
		echo "PACKAGE FUNCTION COMING IN A FUTURE RELEASE..."
	}