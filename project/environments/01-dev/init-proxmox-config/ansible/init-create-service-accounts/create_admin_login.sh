#!/bin/bash

# Make user account
echo "Make user account..."
useradd --shell /bin/bash --create-home --home-dir /home/lifeless/ lifeless

# Give sudo access
echo "Give sudo access"
usermod -aG sudo lifeless

# Set password
echo "Set password..."
passwd lifeless
