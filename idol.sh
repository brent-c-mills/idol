#!/bin/bash

set -e
clear

#################################
##    GLOBAL DECLARATIONS:     ##
#################################

##--DECLARING DIRECTORY STRUCTURE

	BASE_DIR="`pwd`"
	NOW=$(date +"%m_%d_%Y_%H%M%S")
	BIN_DIR=$BASE_DIR/bin
	LIB_DIR=$BASE_DIR/lib
	LOG_DIR=$BASE_DIR/log
	LOG_OUT=$LOG_DIR/log_$NOW.txt
	TEST_DIR=$BASE_DIR/tests
	MAN_DIR=$BASE_DIR/man

##--DECLARING FUNCTIONS

version() {
	echo "Idol 0.0.1"
}

usage() {
	version
	echo "Usage: idol [-h | -l] [-c | -p | -t] [<idol>...]"
}

help() {
	$MAN_DIR/idol_man.sh;
}

list_idol() {
	$BIN_DIR/list_idols.sh $TEST_DIR;
}

fingerprint() {
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
}

create_idol() {
	echo $OPERATING_SYSTEM
	echo $IDOL_NAME
	echo $BASE_DIR
	echo $LOG_OUT

	$BIN_DIR/idol_create.sh $OPERATING_SYSTEM $IDOL_NAME $BASE_DIR $LOG_OUT
}

test_idol() {
	echo "Verifying Idol "${IDOL_NAME}"..." | tee -a $LOG_OUT;
	if [[ -e ${TEST_DIR}/${IDOL_NAME} ]]; then
		echo "Initiating BATS tests on Idol "${IDOL_NAME}"." | tee -a $LOG_OUT;
		bats ${TEST_DIR}/${IDOL_NAME}
		exit 0;
	else
		echo "Idol "${IDOL_NAME}" not found." | tee -a $LOG_OUT; exit 6;
	fi
}

package_idol() {
	echo "PACKAGE FUNCTION COMING IN A FUTURE RELEASE..."
}

#################################
##   END GLOBAL DECLARATIONS:  ##
#################################


#################################
##        ACCEPT INPUT:        ##
#################################

options=()
arguments=()
for arg in "$@"; do
  if [ "${arg:0:1}" = "-" ]; then
    if [ "${arg:1:1}" = "-" ]; then
      options[${#options[*]}]="${arg:2}"
    else
      index=1
      while option="${arg:$index:1}"; do
        [ -n "$option" ] || break
        options[${#options[*]}]="$option"
        let index+=1
      done
    fi
  else
    arguments[${#arguments[*]}]="$arg"
  fi
done

for option in "${options[@]}"; do
	case "$option" in
	"c" | "create" )
	    IDOL_NAME=$2;
		fingerprint
		create_idol
		exit 0;
	    ;;
	"h" | "help" )
	    help
	    exit 0
	    ;;
    "l" | "list" )
		list_idol
		exit 0;
		;;
	"p" | "package" )
	    package_idol
		exit 0;
	    ;;
	"t" | "test" )
    	IDOL_NAME=$2;
		test_idol
		exit 0;
    	;;
	"v" | "version" )
	    version
	    exit 0
	    ;;
	* )
	    usage >&2
	    exit 1
	    ;;
	esac
done

#################################
##     END ACCEPT INPUT:       ##
#################################
