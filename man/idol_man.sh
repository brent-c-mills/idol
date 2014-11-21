#!/bin/bash

bold=`tput bold`
normal=`tput sgr0`
clear



echo "idol.sh";
echo "";

echo "${bold}NAME${normal}"
echo "	idol.sh - Jenkins XML file generator";
echo "";

echo "${bold}SYNOPSIS${normal}"
echo "	${bold}idol.sh${normal} [-p] [--longoption ...] [-c name] [-p name]";
echo "";

echo "${bold}DESCRIPTION${normal}";
echo "	Idol auto generates BATS tests on golden image systems.  This al-";
echo "	lows admins to verify that new systems match the golden image.  A";
echo "	new Idol test suite can be created from an existing system.  The ";
echo "	same test suite can be packaged so as to allow testing on new sy-";
echo "	stems.";
echo "";

echo "${bold}COMMAND-LINE OPTIONS${normal}"
echo "	${bold}-c, --create${normal}	Create an Idol test suite from a running system.";
echo "";
echo "	${bold}-t, --test${normal}	Run the specified Idol test suite against the cu-";
echo "			rrent system.";
echo "";
echo "	${bold}-p, --package${normal}	Package the specified Idol test suite for deploy-";
echo "			ment on a remote system.";
echo "";
exit;