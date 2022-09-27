#!/bin/bash

# Make user account
echo "Make user account..."
useradd --shell /sbin/nologin --system --create-home --home-dir /home/terraform/ terraform

# Give sudo access
echo "Give sudo access"
usermod -aG sudo terraform

