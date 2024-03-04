Python SSH Brute Force Tool
Tommy Juricek
2/27/2024

NAME
sshbrute.py

USAGE
./sshbrute.py [host] [user] -f [password_file]
./sshbrute.py [host] [user] -g [alphabet]

DESCRIPTION
This Python script is developed to perform brute force attacks on SSH services. It supports two modes of operation: using a predefined list of passwords from a file, or generating passwords from a given alphabet. It utilizes the pexpect library to automate login attempts and determine the validity of each password attempt.

COMMAND-LINE OPTIONS
File mode: ./sshbrute.py [host] [user] -f [password_file]
This option allows the user to specify a file containing a list of passwords to try against the specified SSH host and user.

Generate mode: ./sshbrute.py [host] [user] -g [alphabet]
    With this option, the script generates all possible combinations of passwords from the provided alphabet (limited to combinations of length 3 for efficiency) and tries them.
    
INPUT FILE FORMAT
For file mode (-f), the script expects a plain text file with one password per line:
password1
password2
password3

BREAKINBOX PASSWORDS
The passwords to the test VM accounts are:
usera abc123
userb baseball
userc adf
userd letmein
usere cxv

KNOWN BUGS/LIMITATIONS
This script is written for Bash, and uses certain features specific to it. It may not work as expected on systems with a different shell
This script is designed for educational and ethical testing purposes only. Unauthorized access to systems is illegal and unethical.
Make sure to install `pexpect` before running the script.
