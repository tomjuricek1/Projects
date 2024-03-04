#!/usr/bin/python3
# THOMAS JURICEK, 2/27/2024
import pexpect
import sys
import itertools

def generate_passwords(alphabet):
    # generates combinations of length 3 from the given alphabet
    return [''.join(p) for p in itertools.product(alphabet, repeat=3)]

def try_login(host, user, password_list):

    # tries to login to the given host as the user using a list of passwords

    for passwd in password_list:
        conn_str = f"ssh {user}@{host}"
        print(f"Trying password: {passwd}")
        child = pexpect.spawn(conn_str)

        index = child.expect(['password:', pexpect.EOF, pexpect.TIMEOUT], timeout=10)
        
        if index != 0:
            print("Error connecting to host or unexpected prompt received.")
            child.close()
            continue

        child.sendline(passwd)

        # Expecting shell prompt, permission denied message, or timeout
        ret = child.expect(['\$', 'Permission denied', pexpect.EOF, pexpect.TIMEOUT], timeout=10)
        if ret == 0:
            print(f"Success! Password: {passwd}")
            
            child.close()
            return True
        else:
            print("Password failed or connection timed out")
            child.close()

    print("Failed to login with any password.")
    return False

if __name__ == '__main__':
    if len(sys.argv) != 5:
        print("Usage: python3 script.py <host> <user> -f <password_file> OR -g <alphabet>")
        sys.exit(1)
    
    host, user = sys.argv[1], sys.argv[2]
    mode, value = sys.argv[3], sys.argv[4]

    password_list = []
    if mode == '-f':
        try:
            with open(value, 'r') as file:
                password_list = file.read().splitlines()
        except FileNotFoundError:
            print("Password file not found.")
            sys.exit(1)
    elif mode == '-g':
        password_list = generate_passwords(value)
    else:
        print("Invalid mode. Use -f for file or -g for generated passwords.")
        sys.exit(1)
    
    success = try_login(host, user, password_list)
    if not success:
        print("No password succeeded")

