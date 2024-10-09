#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Assign the input argument to a variable
filename="$1"

# Check if the file exists and is readable
if [ ! -f "$filename" ] || [ ! -r "$filename" ]; then
    echo "File not found or not readable: $filename"
    exit 1
fi

# Read the file line by line
while IFS=: read -r username password || [[ -n "$username" ]]; do
    if [[ -z "$username" || -z "$password" ]]; then
        echo "Invalid format in $filename. Expected format: username:password"
        continue
    fi

    # Add the user using the lisa_kasutaja script
    ./lisa_kasutaja.sh "$username"

    # Set the password for the user
    echo "$username:$password" | sudo chpasswd
    if [ $? -eq 0 ]; then
        echo "User $username added with the specified password."
    else
        echo "Failed to set password for user $username."
    fi
done < "$filename"

echo "All users from $filename have been processed."
