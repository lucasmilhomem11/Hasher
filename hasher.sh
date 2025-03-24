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

Input="$1"  

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

# Function to format last_analysis_stats from YAML output
format_vt_stats() {
    echo -e "${YELLOW}Fetching stats from YAML output...${NC}"
    echo -e "${BLUE}"
    printf "+------------------+-------+\n"
    printf "| %-16s | %5s |\n" "Category" "Count"
    printf "+------------------+-------+\n"

    # Parse YAML output from vt file report
    vt file report "$HASH" | while IFS= read -r line; do
        if [[ "$line" =~ ^\ *last_analysis_stats: ]]; then
            in_section="yes"
        elif [[ "$in_section" == "yes" && "$line" =~ ^\ *([^:]+):\ ([0-9]+)$ ]]; then
            key="${BASH_REMATCH[1]// /}"  # Remove leading/trailing spaces
            value="${BASH_REMATCH[2]}"
            if [[ "$key" =~ ^(harmless|malicious|suspicious|type-unsupported|undetected)$ ]]; then
                printf "| %-16s | %5s |\n" "$key" "$value"
            fi
        elif [[ "$in_section" == "yes" && "$line" =~ ^\ *[a-zA-Z_-]+: ]]; then
            in_section="no"
            printf "+------------------+-------+\n"
            break
        fi
    done
    echo -e "${NC}"
}

# Check if the input is a hash
is_hash

if [ -n "$HASH_TYPE" ]; then
    HASH="$Input"
    echo -e "${YELLOW}Checking $HASH_TYPE hash online...${NC}"
else
    check_hashes
    HASH="$MD5"  # Use MD5 hash for online check
    echo -e "${YELLOW}Checking hashes online...${NC}"
fi

read -p "Do you want a full report - type 'n' if you want a basic summary? (y/n): " REPORT_TYPE

Directory=$(pwd)
if [[ "$REPORT_TYPE" == "y" ]]; then
    vt file "$HASH" >  $Directory/vt_report.txt
    echo -e "${YELLOW}Full report saved to $Directory/vt_report.txt${NC}"
else
    echo -e "${YELLOW}Fetching full report...${NC}"
    format_vt_stats
