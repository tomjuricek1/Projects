CPSC 42700 Project 1: Bash Port Scanner
Tommy Juricek
2/52024

NAME
    portscanner.sh

USAGE
    ./portscanner.sh [host startport stopport]
    You can also specify a custom timeout time by adding a [-t (time)] after calling the script.

DESCRIPTION
    This Bash script provides a user-friendly tool for scanning network ports on given hosts. It's designed to support direct command-line usage, interactive mode, and batch processing through piping from a file. 

COMMAND-LINE OPTIONS
    Direct mode: ./portscanner.sh [-t timeout] [host] [startport] [stopport]
    	You can specify a specific host to scan through the command line.
    
    Batch Mode: cat [a text file with host list].txt | ./portscanner.sh
    	With this, you can pipe in a list of hosts to scan. 
    
    Prompt Mode: ./portscanner.sh
    	The script will prompt you for a host and ports to scan

INPUT FILE FORMAT
	www.example1.com
	start_port1
	stop_port1
	www.example2.com
	start_port2
	stop_port2
	...
    

KNOWN BUGS AND LIMITATIONS

	This script is written for Bash, and uses certain features specific to it. It may not work as expected on systems with a different shell
	
	When trying to get a piped command with also a changed timeout time, I kept having issues and it would start to mess with other parts of the script so I decided to leave it out. When I originally created the script, I completly overlooked that the timeout time on a piped output would need to be implemented, so getting it to work after the fact was a struggle. It currently just give a error when a piped command is ran with a [-t (num)].

ADDITIONAL NOTES
    
