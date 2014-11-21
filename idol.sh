#!/bin/bash

clear

### GLOBAL DECLARATIONS:

#Declaring Variables
	NOW=$(date +"%m_%d_%Y_%H%M%S")
	LOCATIONS="Lab01 Lab02 Lab03 Lab04 COLO01"
	SRVNUM=0
	SUCCESS=0
	FAIL=0

#Declaring Directory Locations
	PWD="`pwd`"
	LOG_DIR=$PWD/log
	LOG_OUT=$LOG_DIR/log_$NOW.txt
	TEST_OUT=$PWD/tests
	MAN_DIR=$PWD/man

### END DECLARATIONS



#READ INPUT AND OUTPUT HELP IF NEEDED

#Output help if "?" received as $1
	{
	if [ "$1" = "?" ] || [ "$1" = "-?" ] || [ "$1" = "-h" ] || [ "$1" = "help" ] || [ "$1" = "--help" ];
	then
		$MAN_DIR/idol_man.sh;
		exit 0;
	fi
	}

