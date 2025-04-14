#!/bin/bash

# Ubuntu XFCE + VNC + Chrome + NVM + n8n Setup Script
# Author: Claude
# Date: April 14, 2025

set -e  # Exit on error
echo "Starting Ubuntu setup script..."

# Update and upgrade packages
echo "===== Updating and upgrading packages ====="
sudo apt update && sudo apt upgrade -y

# Install XFCE desktop environment
echo "===== Installing XFCE desktop environment ====="
sudo apt install -y xfce4 xfce4-goodies

# Install TightVNC server
echo "===== Installing TightVNC server ====="
sudo apt install -y tightvncserver

# Set up VNC server
echo "===== Setting up VNC server ====="
# First time setup requires a password
if [ ! -d "$HOME/.vnc" ]; then
    echo "Setting up VNC for the first time..."
    echo "You will be prompted to enter a VNC password."
    vncserver
    vncserver -kill :1
else
    echo "VNC directory already exists. Killing any running instances..."
    vncserver -kill :1 || true
fi

# Configure VNC xstartup file
echo "===== Configuring VNC xstartup ====="
mkdir -p $HOME/.vnc
cat > $HOME/.vnc/xstartup << 'EOL'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOL

# Make xstartup executable
chmod +x $HOME/.vnc/xstartup

# Start VNC server
echo "===== Starting VNC server ====="
vncserver

# Install Google Chrome
echo "===== Installing Google Chrome ====="
if ! command -v google-chrome &> /dev/null; then
    echo "Downloading Google Chrome..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y ./google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb

    # Set Chrome as default browser
    echo "Setting Google Chrome as default browser..."
    xdg-settings set default-web-browser google-chrome.desktop
else
    echo "Google Chrome is already installed."
fi

# Install NVM (Node Version Manager)
echo "===== Installing NVM ====="
if [ ! -d "$HOME/.nvm" ]; then
    echo "Downloading and installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

    # Load NVM for the current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    # Install Node.js
    echo "===== Installing Node.js 20.15.0 ====="
    nvm install 20.15.0
    nvm use 20.15.0
    nvm alias default 20.15.0
else
    echo "NVM is already installed."
    # Load NVM for current session anyway
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    # Ensure correct Node.js version
    if ! nvm ls 20.15.0 &> /dev/null; then
        echo "Installing Node.js 20.15.0..."
        nvm install 20.15.0
        nvm use 20.15.0
        nvm alias default 20.15.0
    else
        echo "Node.js 20.15.0 is already installed."
        nvm use 20.15.0
    fi
fi

# Install n8n
echo "===== Installing n8n ====="
npm install n8n -g

# Install ngrok
echo "===== Installing ngrok ====="
# Check if ngrok is already installed
if ! command -v ngrok &> /dev/null; then
    echo "Downloading and installing ngrok..."
    # Download the ngrok package
    wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -O ngrok.tgz
    # Extract ngrok
    sudo tar -xvzf ngrok.tgz -C /usr/local/bin
    # Remove the archive
    rm ngrok.tgz
    # Make ngrok executable
    sudo chmod +x /usr/local/bin/ngrok

    echo "ngrok installed successfully."
    echo "NOTE: You will need to authenticate ngrok with your auth token."
    echo "Run 'ngrok config add-authtoken YOUR_AUTH_TOKEN' after installation."
else
    echo "ngrok is already installed."
fi

# Cleanup step - remove cache, temp files, and downloaded items
echo "===== Cleaning up system ====="
# Clean apt cache
sudo apt clean
sudo apt autoclean
sudo apt autoremove -y

# Clean temp files
rm -rf /tmp/*
rm -rf /var/tmp/*

# Clean user cache
rm -rf ~/.cache/thumbnails/*
rm -rf ~/.npm/_cacache/*
rm -rf ~/.wget-hsts

# Remove all downloaded packages and archives
sudo rm -rf /var/cache/apt/archives/*.deb

echo "===== Setup Complete! ====="
echo "VNC server is running at :1"
echo "NVM and Node.js 20.15.0 are installed"
echo "n8n is installed globally"
echo "ngrok is installed - run 'ngrok config add-authtoken YOUR_AUTH_TOKEN' to authenticate"
echo "System has been cleaned of temporary files and caches"
echo "To connect to your VNC server, use a VNC client with your server's IP and port 5901"
echo "To start n8n, run: n8n start"
