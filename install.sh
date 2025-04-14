#!/bin/bash

# Installer script for ubuntu-setup.sh
# This script downloads and runs the main setup script

set -e  # Exit on error

echo "==================================================="
echo "Ubuntu XFCE + VNC + Chrome + NVM + n8n Installer"
echo "==================================================="

# Check if running as root (which we don't want for NVM installation)
if [ "$(id -u)" -eq 0 ]; then
    echo "ERROR: This script should not be run as root or with sudo."
    echo "Please run as a regular user with sudo privileges."
    exit 1
fi

# Check if running on Ubuntu
if [ ! -f /etc/lsb-release ] || ! grep -q "Ubuntu" /etc/lsb-release; then
    echo "WARNING: This script is designed for Ubuntu."
    echo "Your system may not be fully compatible."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for required commands
for cmd in wget curl sudo apt; do
    if ! command -v $cmd &> /dev/null; then
        echo "ERROR: Required command '$cmd' not found."
        echo "Please install it before continuing."
        exit 1
    fi
done

# Download the main setup script
echo "Downloading setup script..."
curl -fsSL https://raw.githubusercontent.com/USERNAME/REPO_NAME/main/ubuntu-setup.sh -o ubuntu-setup.sh

# Make it executable
chmod +x ubuntu-setup.sh

# Run the script
echo "Running setup script..."
./ubuntu-setup.sh

# Cleanup
rm ubuntu-setup.sh

echo "Installation complete!"
