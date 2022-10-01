#!/bin/bash

# Make user account
echo "Make user account..."
useradd --shell /bin/bash --create-home --home-dir /home/admin admin

# Give sudo access
echo "Give sudo access"
usermod -aG sudo admin

# Set password
echo "Set password..."
passwd admin
