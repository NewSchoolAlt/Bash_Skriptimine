#!/bin/bash

# Kontrollime, kas fail on antud
if [ $# -ne 1 ]; then
    echo "No filename provided, selecting a file with fzf..."
    filename=$(fzf --prompt="Select a file: " --preview="batcat {}")
    if [ -z "$filename" ]; then
        echo "No file selected. Exiting..."
        exit 1
    fi
else
    # Assignime faili
    filename="$1"
fi

# Kontrollime, kas fail eksisteerib ja on loetav
if [ ! -f "$filename" ] || [ ! -r "$filename" ]; then
    echo "File not found or not readable: $filename"
    exit 1
fi

# Loeme faili ja töötleme kasutajad
while IFS=: read -r username password || [[ -n "$username" ]]; do
    if [[ -z "$username" || -z "$password" ]]; then
        echo "Invalid format in $filename. Expected format: username:password"
        continue
    fi

    # Kutsume teist skripti kasutajaga
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
