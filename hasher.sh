#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ASCII art for the application name
echo -e "${BLUE}"
echo " _   _                           "
echo "| | | | __ _ ____ ____ _ ___ _____"
echo "| |_| |/ _\` / __| '_ \ / __| '__|"
echo "|  _  | (_| \__ \ | | | (__| |   "
echo "|_| |_|\__,_|___/_| |_|\___|_|   "
echo -e "${NC}"

echo -e "${GREEN}This application will check the file hashes and crosscheck with databases online to see if it is malicious or not${NC}"

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide a file path or a hash as an argument."
    exit 1
fi

Input="$1"  # Store input

# Function to check if the input is a hash
is_hash() {
    if [[ "$Input" =~ ^[a-fA-F0-9]{32}$ ]]; then
        echo -e "${YELLOW}MD5 hash detected.${NC}"
        HASH_TYPE="MD5"
    elif [[ "$Input" =~ ^[a-fA-F0-9]{40}$ ]]; then
        echo -e "${YELLOW}SHA1 hash detected.${NC}"
        HASH_TYPE="SHA1"
    elif [[ "$Input" =~ ^[a-fA-F0-9]{64}$ ]]; then
        echo -e "${YELLOW}SHA256 hash detected.${NC}"
        HASH_TYPE="SHA256"
    elif [[ "$Input" =~ ^[a-fA-F0-9]{128}$ ]]; then
        echo -e "${YELLOW}SHA512 hash detected.${NC}"
        HASH_TYPE="SHA512"
    else
        HASH_TYPE=""
    fi
}

# Function to check hashes of a file
check_hashes() {
    MD5=$(md5sum "$Input" | awk '{print $1}')
    SHA1=$(sha1sum "$Input" | awk '{print $1}')
    SHA256=$(sha256sum "$Input" | awk '{print $1}')
    SHA512=$(sha512sum "$Input" | awk '{print $1}')

    echo -e "${BLUE}------------------------${NC}"
    echo -e "${GREEN}MD5: $MD5${NC}"
    echo -e "${BLUE}------------------------${NC}"
    echo -e "${GREEN}SHA1: $SHA1${NC}"
    echo -e "${BLUE}------------------------${NC}"
    echo -e "${GREEN}SHA256: $SHA256${NC}"
    echo -e "${BLUE}------------------------${NC}"
    echo -e "${GREEN}SHA512: $SHA512${NC}"
    echo -e "${BLUE}------------------------${NC}"
}

# Check if the input is a hash
is_hash

if [ -n "$HASH_TYPE" ]; then
    # Input is a hash, check it online
    HASH="$Input"
    echo -e "${YELLOW}Checking $HASH_TYPE hash online...${NC}"
else
    # Input is a file, check its hashes
    check_hashes
    HASH="$MD5"  # Use MD5 hash for online check
    echo -e "${YELLOW}Checking hashes online...${NC}"
fi


read -p "Do you want a full report? (y/n): " REPORT_TYPE

if [[ "$REPORT_TYPE" == "n" ]]; then
    vt file report $HASH | grep malicious | tail -n 2 
else
    vt file report $HASH
fi
