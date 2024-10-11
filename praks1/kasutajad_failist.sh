#!/bin/bash

# vaatame kas fail on antud
if [ $# -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Assignime faili
filename="$1"

# vaatame kas fail eksisteerib
if [ ! -f "$filename" ] || [ ! -r "$filename" ]; then
    echo "File not found or not readable: $filename"
    exit 1
fi

# loeme faili
while IFS=: read -r username password || [[ -n "$username" ]]; do
    if [[ -z "$username" || -z "$password" ]]; then
        echo "Invalid format in $filename. Expected format: username:password"
        continue
    fi

    # kutsume teist skripti kasutajaga
    ./lisa_kasutaja.sh "$username"

    # Setime parooli kasutajale
    echo "$username:$password" | sudo chpasswd
    if [ $? -eq 0 ]; then
        echo "User $username added with the specified password."
    else
        echo "Failed to set password for user $username."
    fi
done < "$filename"

echo "All users from $filename have been processed."
