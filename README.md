


                     _..-'(                       )`-.._
                  ./'. '||\\.       /\__/\       .//||` .`\.
               ./'.|'.'||||\\|..    ||||||    ..|//||||`.`|.`\.
            ./'..|'.|| |||||\`````` '||||` ''''''/||||| ||.`|..`\.       
          ./'.||'.|||| ||||||||||||.||||||.|||||||||||| ||||.`||.`\.     
         /'|||'.|||||| |||||| |||||{||||||}||||| |||||| ||||||.`|||`\    
        '.|||'.||||||| ||||||||||||{||||||}|||||||||||| |||||||.`|||.`  
       '.||| ||||||||| |/'   ``\||``||||||''||/''   `\| ||||||||| |||.`
       |/' \./'     `\./         \!|\||||/|!/         \./'     `\./ `\|  
       V    V         V          }' `\||/' `{          V         V    V
       `    `         `               \/               '         '    '



	 ___ ___   ___  _      _       ___  ___  _    ___  ___ _  _   ___   _ _____ 
	|_ _|   \ / _ \| |    (_)     / __|/ _ \| |  |   \| __| \| | | _ ) /_\_   _|
	 | || |) | (_) | |__   _     | (_ | (_) | |__| |) | _|| .` | | _ \/ _ \| |  
	|___|___/ \___/|____| (_)     \___|\___/|____|___/|___|_|\_| |___/_/ \_\_|  
	                                                                            
	 _____ ___ ___ _____     _  _   _ _____ ___  __  __   _ _____ ___ ___  _  _ 
	|_   _| __/ __|_   _|   /_\| | | |_   _/ _ \|  \/  | /_\_   _|_ _/ _ \| \| |
	  | | | _|\__ \ | |    / _ \ |_| | | || (_) | |\/| |/ _ \| |  | | (_) | .` |
	  |_| |___|___/ |_|   /_/ \_\___/  |_| \___/|_|  |_/_/ \_\_| |___\___/|_|\_|
	                                                                            
	 ___ ___    _   __  __ _____      _____  ___ _  __
	| __| _ \  /_\ |  \/  | __\ \    / / _ \| _ \ |/ /
	| _||   / / _ \| |\/| | _| \ \/\/ / (_) |   / ' < 
	|_| |_|_\/_/ \_\_|  |_|___| \_/\_/ \___/|_|_\_|\_\

idol
====


DESCRIPTION:

Idol sits on top of BATS (https://github.com/sstephenson/bats).  Idol creates and stores Idols (Golden Images) --> ( A Golden Bat == an Idol!  Get it? ).  Future systems can be tested against these Idols to check compliance to the golden image / golden standard for a given system.


INSTALLATION:

To install Idol, run the install.sh script.  This script installs a version of BATS as well as installing Idol and running a series of BATS tests against the Idol installation.

	NOTE:  There is currently an issue where the Idol installation script is unable to properly refresh the PATH.  You will need to close your terminal session and re-open after installing Idol.

CURRENT FUNCTIONALITY:

	Install:  Idol is currently able to install itself and a local instance of BATS 4.0.
	Create:  Idol is currently able to create Idols.  
	List:  Idol is currently able to list all stored Idols.

CURRENT IDOL TESTS:

Idol currently tests the following:
**Installed Programs
**Current Users (and permissions)
**Current Groups (and permissions)

PLANNED IDOL TESTS:

Idol will soon support testing for:
**Network configuration
**Environment variables
**Hardware configuration

To request other functionality, please contact brent.c.mills@gmail.com or open an issue.
