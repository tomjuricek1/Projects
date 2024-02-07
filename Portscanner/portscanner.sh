#!/bin/bash
#Thomas Juricek, CPSC 42700-001, 2/5/2024, Project 1

# timeout value
default_timeout=2
timeout=$default_timeout

# check input for mistakes, and error if there is a mistake
usage() {
    echo "Usage: $0 [-t timeout] [host startport stopport]"
    exit 1
}

# check number of arguments
if [ $# -ne 0 ] && [ $# -ne 3 ] && [ $# -ne 5 ]; then
    usage
fi


# function to check if a host is up
function pingcheck
{
# scrape the output of ping to see if it succeeded.
pingresult=$(ping -c 1 $host | grep bytes | wc -l)
if [ "$pingresult" -gt 1 ] ; then
    echo "$host is up"
else
    echo "$host is down, quitting"
    exit 1
fi
}

# function to check ports
portcheck() {
    local host=$1
    local startport=$2
    local stopport=$3
    for ((counter=$startport; counter <= $stopport; counter++)); do
        if timeout $timeout bash -c "echo > /dev/tcp/$host/$counter" &> /dev/null; then
            echo "$counter open"
        else
            echo "$counter closed"
        fi
    done
}

# check for a -t option
if [ "$1" = "-t" ]; then
    if ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: -t must be followed by a number."
        exit 1
    fi
    timeout=$2
    echo "Timeout changed to $timeout"
    shift 2 # removes -t and the requested time from the input
fi

# check the mode of operation
if [ $# -eq 3 ]; then
    # Direct mode: ./script.sh host startport stopport
    host=$1
    startport=$2
    stopport=$3
    pingcheck && portcheck "$host" "$startport" "$stopport"
elif [ -t 0 ]; then
    # interactive mode
    while : ; do
        read -p "Enter hostname (leave blank to quit): " host
        [ -z "$host" ] && break # exit loop if hostname is blank
        read -p "Enter start port: " startport
        read -p "Enter stop port: " stopport
        
        pingcheck && portcheck "$host" "$startport" "$stopport"
    done
else
    # for when a file is pipped into the script
    while read host && read startport && read stopport; do
    # exit loop if hostname is blank
        [ -z "$host" ] && break 
        # check if the host is up and then scan ports
        pingcheck "$host" && portcheck "$host" "$startport" "$stopport"
    done
fi
