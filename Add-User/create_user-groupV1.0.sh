#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Prompt for the group name
read -p "Enter the group name to create: " groupname

# Prompt for the optional GID
read -p "Enter the GID for the group (leave blank for default): " gid

# Check if the group already exists
if getent group "$groupname" &>/dev/null; then
    echo "Group '$groupname' already exists."
else
    # Create the group with or without GID
    if [ -z "$gid" ]; then
        groupadd "$groupname"
    else
        groupadd -g "$gid" "$groupname"
    fi

    if [ $? -eq 0 ]; then
        echo "Group '$groupname' created successfully."
    else
        echo "Failed to create group '$groupname'."
        exit 1
    fi
fi

# Prompt for the username
read -p "Enter the username to create: " username

# Prompt for the optional UID
read -p "Enter the UID for the user (leave blank for default): " uid

# Check if the user already exists
if id "$username" &>/dev/null; then
    echo "User '$username' already exists."
else
    # Create the user with or without UID and assign to the group
    if [ -z "$uid" ]; then
        useradd -g "$groupname" "$username"
    else
        useradd -u "$uid" -g "$groupname" "$username"
    fi

    if [ $? -eq 0 ]; then
        echo "User '$username' created successfully and added to group '$groupname'."
    else
        echo "Failed to create user '$username'."
        exit 1
    fi
fi

# Prompt to set a password for the user
read -sp "Enter the password for the user '$username': " password
echo
read -sp "Confirm the password: " confirm_password
echo

# Check if passwords match
if [ "$password" != "$confirm_password" ]; then
    echo "Passwords do not match. Exiting."
    exit 1
fi

# Set the password for the user
echo "$username:$password" | chpasswd

if [ $? -eq 0 ]; then
    echo "Password set successfully for user '$username'."
else
    echo "Failed to set password for user '$username'."
    exit 1
fi

