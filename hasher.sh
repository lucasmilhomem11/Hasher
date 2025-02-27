#!/bin/bash

echo "This application will check the file hashes and crosscheck with databases online to see if it is malicious or not"

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide a file path or a hash as an argument."
    exit 1
fi

Input="$1"  # Store input

# Function to check if the input is a hash
is_hash() {
    if [[ "$Input" =~ ^[a-fA-F0-9]{32}$ ]]; then
        echo "MD5 hash detected."
        HASH_TYPE="MD5"
    elif [[ "$Input" =~ ^[a-fA-F0-9]{40}$ ]]; then
        echo "SHA1 hash detected."
        HASH_TYPE="SHA1"
    elif [[ "$Input" =~ ^[a-fA-F0-9]{64}$ ]]; then
        echo "SHA256 hash detected."
        HASH_TYPE="SHA256"
    elif [[ "$Input" =~ ^[a-fA-F0-9]{128}$ ]]; then
        echo "SHA512 hash detected."
        HASH_TYPE="SHA512"
    else
        HASH_TYPE=""
    fi
}

# Function to check hashes of a file
check_hashes() {
    echo "Checking hashes..."
    MD5=$(md5sum "$Input" | awk '{print $1}')
    SHA1=$(sha1sum "$Input" | awk '{print $1}')
    SHA256=$(sha256sum "$Input" | awk '{print $1}')
    SHA512=$(sha512sum "$Input" | awk '{print $1}')

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

# Check if the input is a hash
is_hash

if [ -n "$HASH_TYPE" ]; then
    # Input is a hash, check it online
    HASH="$Input"
    echo "Checking $HASH_TYPE hash online..."
else
    # Input is a file, check its hashes
    check_hashes
    HASH="$MD5"  # Use MD5 hash for online check
fi

echo "Checking hashes online..."
read -p "Do you want a full report? (y/n): " REPORT_TYPE

if [[ "$REPORT_TYPE" == "n" ]]; then
    vt file report $HASH | grep malicious | tail -n 2 
else
    vt file report $HASH
fi
