#!/bin/bash

clear

### GLOBAL DECLARATIONS:

#Declaring Directory Locations
	PWD="`pwd`"
	NOW=$(date +"%m_%d_%Y_%H%M%S")
	BIN_DIR=$PWD/bin
	LOG_DIR=$PWD/log
	LOG_OUT=$LOG_DIR/log_$NOW.txt
	TEST_OUT=$PWD/tests
	MAN_DIR=$PWD/man

### END DECLARATIONS


#VERIFY INPUT
	{
	if [ $# -eq 0 ]; then
		echo "No argument supplied.  Run idol.sh -h for help and usage." | tee -a $LOG_OUT;
		exit 1;
	fi
	}

	{
	if [ "$1" -ne "?" ] && [ "$1" -ne "-?" ] && [ "$1" -ne "-h" ] && [ "$1" -ne "help" ] && [ "$1" -ne "--help" ] && [ "$1" -ne "-c" ] && [ "$1" -ne "--create" ] && [ "$1" -ne "-l" ] && [ "$1" -ne "--list" ] && [ "$1" -ne "-p" ] && [ "$1" -ne "--package" ] && [ "$1" -ne "-t" ] && [ "$1" -ne "--test" ]; then
		echo "Invalid input.  Run idol.sh -h for help and usage." | tee -a $LOG_OUT;
		exit 2;
	fi
	}

#READ INPUT AND OUTPUT HELP IF NEEDED

#Output help message
	{
	if [ "$1" = "?" ] || [ "$1" = "-?" ] || [ "$1" = "-h" ] || [ "$1" = "help" ] || [ "$1" = "--help" ]; then
		$MAN_DIR/idol_man.sh;
		exit 0;
	fi
	}

#Output list of current golden images

	{
	if [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
		$BIN_DIR/list_idols.sh $TEST_OUT;
		exit 0;
	fi
	}

#CREATE NEW IDOL
	{
	if [ "$1" = "-c" ] || [ "$1" = "--create" ]; then
		IDOL_NAME=$2;

		if [ -a /etc/centos-release ] || [ -a /etc/redhat-release ]; then
			echo "Host OS recognized as CentOS / Redhat." | tee -a $LOG_OUT;
			$BIN_DIR/idol_create_centos.sh $IDOL_NAME

		elif [ -a /etc/os-release]; then
			echo "Host OS recognized as Debian / Ubuntu." | tee -a $LOG_OUT;
			$BIN_DIR/idol_create_ubuntu.sh $IDOL_NAME	

		elif [ $OSTYPE -eq "darwin"* ]; then
			echo "Host OS recognized as Apple OS X." | tee -a $LOG_OUT;
			$BIN_DIR/idol_create_os_x.sh $IDOL_NAME	
		else echo "Sorry.  This operating system is not supported at this time." | tee -a $LOG_OUT; exit 5;
		fi

	fi
	}