#!/bin/bash

NEW_USERNAME="terraform"

# Make user account
echo "Make user account..."
useradd --shell /sbin/nologin --system --create-home --home-dir /home/$NEW_USERNAME $NEW_USERNAME

# Give sudo access
echo "Give sudo access"
usermod -aG sudo $NEW_USERNAME

# Set password
echo "Set password..."
passwd $NEW_USERNAME
