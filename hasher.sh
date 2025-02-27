#!/bin/bash

echo "This application will check the file hashes and crosscheck with databases online to see if it is malicious or not"

# Check if a file path is provided as an argument
if [ -z "$1" ]; then
    echo "Please provide a file path as an argument."
    exit 1
fi

File="$1"  # Store file path

check_hashes() {
    echo "Checking hashes..."
    MD5=$(md5sum "$File" | awk '{print $1}')
    SHA1=$(sha1sum "$File" | awk '{print $1}')
    SHA256=$(sha256sum "$File" | awk '{print $1}')
    SHA512=$(sha512sum "$File" | awk '{print $1}')

    echo "------------------------"
    echo "MD5: $MD5"
    echo "------------------------"
    echo "SHA1: $SHA1"
    echo "------------------------"
    echo "SHA256: $SHA256"
    echo "------------------------"
    echo "SHA512: $SHA512"
    echo "------------------------"
}

check_hashes

# Ask the user if they want to check the hashes online
read -p "Do you want to check these hashes online? (y/n): " CHECK_ONLINE

if [[ "$CHECK_ONLINE" == "y" ]]; then
    read -p "Do you want a full report? (y/n): " REPORT_TYPE
    if [[ "$REPORT_TYPE" == "n" ]]; then
        echo "Checking hashes online..."
    
        # Placeholder for API query (we'll add that next)
        vt file report $MD5 | grep malicious |  tail -n 2 
    else
        vt file report $MD5
    fi
else
    echo "Skipping online check."
fi
