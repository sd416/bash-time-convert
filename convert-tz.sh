#!/bin/bash

# Convert current time to multiple timezones

# Input your wished timezone abbreviations here
timezones=(
    "UTC" # Coordinated Universal Time
    "IST" # India Standard Time
    "CST" # China Standard Time
    "EST" # Eastern Standard Time
    "CET" # Central European Time
    "PST" # Pacific Standard Time
    "BST" # British Summer Time
)

# Function to get the full timezone name from abbreviation
get_full_timezone() {
    case $1 in
        "UTC") echo "Etc/UTC" ;;
        "IST") echo "Asia/Kolkata" ;;
        "CST") echo "Asia/Shanghai" ;;
        "EST") echo "America/New_York" ;;
        "CET") echo "Europe/Berlin" ;;
        "PST") echo "America/Los_Angeles" ;;
        "BST") echo "Europe/London" ;;
        *) echo "Etc/UTC" ;; # Default to UTC if abbreviation is not found
    esac
}

# Check if `date` is GNU or not
if [[ $(date --version 2> /dev/null | grep -i GNU) ]]; then
    flag_gnu="true"
else
    flag_gnu="false"
fi

# Default to 12-hour format
time_format="%h %d %I:%M %p"

# Parse the format flag
while getopts "f:" opt; do
    case ${opt} in
        f )
            if [[ $OPTARG == "24" ]]; then
                time_format="%h %d %H:%M"
            elif [[ $OPTARG != "12" ]]; then
                echo "Invalid format. Use -f 12 for 12-hour format or -f 24 for 24-hour format."
                exit 1
            fi
            ;;
        \? )
            echo "Usage: cmd [-f format]"
            exit 1
            ;;
    esac
done

# Get the current timestamp
timestamp=$(date +%s)

results=()
for abbr in "${timezones[@]}"
do
    tz=$(get_full_timezone $abbr)
    if [[ "${flag_gnu}" == "true" ]]; then
        convert_tz=$(TZ=$tz date -d "@$timestamp" +"$time_format")
    else
        convert_tz=$(TZ=$tz date -r "$timestamp" +"$time_format")
    fi
    results+=("$abbr $convert_tz")
done

# Print each timezone's time on a new line
for result in "${results[@]}"
do
    echo "$result"
done

exit 0
