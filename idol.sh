#!/bin/bash

clear

### GLOBAL DECLARATIONS:

#Declaring Directory Locations
	PWD="`pwd`"
	BIN_DIR=$PWD/bin
	LOG_DIR=$PWD/log
	LOG_OUT=$LOG_DIR/log_$NOW.txt
	TEST_OUT=$PWD/tests
	MAN_DIR=$PWD/man

### END DECLARATIONS



#READ INPUT AND OUTPUT HELP IF NEEDED

#Output help message
	{
	if [ "$1" = "?" ] || [ "$1" = "-?" ] || [ "$1" = "-h" ] || [ "$1" = "help" ] || [ "$1" = "--help" ];
	then
		$MAN_DIR/idol_man.sh;
		exit 0;
	fi
	}

#Output list of current golden images

	{
	if [ "$1" = "-l" ] || [ "$1" = "--list" ];
	then
		$BIN_DIR/list_idols.sh $TEST_OUT;
		exit 0;
	fi
	}