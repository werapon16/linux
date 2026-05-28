#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Prompt user for the username to delete
read -p "Enter the username to delete: " username

# Check if the user exists
if id "$username" &>/dev/null; then
    # Confirm deletion
    read -p "Are you sure you want to delete the user '$username' and their home directory? [y/N]: " confirm
    confirm=${confirm,,} # Convert to lowercase for consistent comparison
    if [[ "$confirm" == "y" || "$confirm" == "yes" ]]; then
        # Delete the user and their home directory
        userdel -r "$username"
        if [ $? -eq 0 ]; then
            echo "User '$username' and their home directory have been deleted."
        else
            echo "Failed to delete user '$username'."
        fi
    else
        echo "Deletion cancelled."
    fi
else
    echo "User '$username' does not exist."
fi

