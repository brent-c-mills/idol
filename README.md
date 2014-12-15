idol:  BATS Golden Image Test Automation Framework
====

Idol provides functionality above and beyond what BATS provides on its own.

* OS detection and OS-based test customization
* Dual-layer Hash / Full test framework - this saves time if all items in a category match the baseline
* Automated BATS test generation across Ubuntu/Debian, Cent/RHEL/Fedora, and Darwin/OS X
* Simultaneous storage for multiple IDOLs (multiple golden standards) with built-in export and import functionality
* Ability to list and pick which IDOL to test at run time

**DESCRIPTION:**

Idol sits on top of BATS (https://github.com/sstephenson/bats).  Idol creates and stores Idols (Golden Images) --> ( A Golden Bat == an Idol!  Get it? ).  Future systems can be tested against these Idols to check compliance to the golden image / golden standard for a given system.

Idol generates bats tests around users, groups, installed software, and environment variables.  Within each of these categories, two types of tests are generated; hash tests and full tests.  1x Hash test is generated for each category.  By default, hash tests are the only tests that are run.  However, if anything in a given category changes (including comments in files), the hash test will fail and a full test will be launched for that category.  Full tests do not test comments in files - as a result, it is possible for a hash test to fail, but all full tests for that category to pass.

This Hash and Full approach is taken in order to save time during testing while still allowing a full system test via BATS.


**INSTALLATION:**

To install Idol, run the install.sh script.  This script installs a version of BATS as well as installing Idol and running a series of BATS tests against the Idol installation.

	NOTE:  There is currently an issue where the Idol installation script is unable to properly refresh the PATH.  You will need to close your terminal session and re-open after installing Idol.


**GETTING STARTED:**

To get started with Idol, use:
	#idol --help


**BASIC COMMANDS:**

Idol accepts the following commands:

	#idol -c, #idol --create     :  Create a new Idol golden image
	#idol -d, #idol --delete     :  Safely and easily delete a specified Idol golden image
	#idol -h, #idol --help       :  Displays the help menu
	#idol -i, #idol --import     :  Import a packaged Idol into your Idol instance
	#idol -l, #idol --list       :  List all current Idol golden images
	#idol -p, #idol --package    :  Package a copy of your Idol instance for testing on a remote system
	#idol -t, #idol --test       :  Test the current system against an Idol golden image


**CURRENT FUNCTIONALITY:**

	Install:  Idol is currently able to install itself and a local instance of BATS 4.0.
	Create:  Idol is currently able to create Idols.  
	Delete:  Idol is able to safely and easily delete existing Idols.
	List:  Idol is currently able to list all stored Idols.
	Package:  Idol is able to package itself for deployment on remote systems (including all generated Idols).
	Test:  Idol is able to run automated tests against any stored Idol.
		Idol first attempts hash matches.  Failing this, it runs a full battery of tests.  
		This saves time over traditional BATS workflow.
	Import:  Import a packaged Idol from a remote instance into your Idol instance.

	Idol currently outputs a RESULTS section which outlines the total number of tests run and the total number of tests failed.  It then generates a failed list in the log directory in order to record failed tests.

**PLANNED FUNCTIONALITY:**
	
	Idol will soon provide the ability to output failed tests one at a time to a log server via email.  If "Idol --test ${IDOL_NAME}" is run at boot, this will allow for boot-time validation and monitoring of system configs against a golden standard.

**CURRENT IDOL TESTS:**

  Idol currently tests the following:
  
	Installed Programs (Only alerts if programs are updated or deleted, not if new programs are added)
	Current Users (and permissions)
	Current Groups (and permissions)
	Environment variables
	Ruby Gems (If Ruby is installed)
	Chef Cookbooks (If Chef is installed)
	Chef Recipes (If Chef is installed)

**PLANNED IDOL TESTS:**

  Idol will soon support testing for:
  
	Network configuration
	Hardware configuration

To request other functionality, please contact brent.c.mills@gmail.com or open an issue.
