# Ubuntu XFCE + VNC + Chrome + NVM + n8n Setup

This repository contains a script to automatically set up an Ubuntu server with:

- XFCE4 desktop environment
- TightVNC Server
- Google Chrome browser (set as default)
- NVM (Node Version Manager)
- Node.js 20.15.0
- n8n workflow automation tool

## Quick Installation

To install directly from GitHub:

```bash
# Method 1: Using curl
curl -fsSL https://raw.githubusercontent.com/USERNAME/REPO_NAME/main/ubuntu-setup.sh | bash

# Method 2: Clone and run
git clone https://github.com/USERNAME/REPO_NAME.git
cd REPO_NAME
chmod +x ubuntu-setup.sh
./ubuntu-setup.sh
```

Replace `USERNAME` and `REPO_NAME` with your GitHub username and repository name.

## What Does This Script Do?

1. Updates and upgrades all system packages
2. Installs XFCE4 desktop environment and additional goodies
3. Installs and configures TightVNC server
4. Sets up proper XFCE startup for VNC
5. Installs Google Chrome and sets it as the default browser
6. Installs NVM (Node Version Manager)
7. Installs Node.js 20.15.0 and sets it as default
8. Installs n8n workflow automation tool globally

## VNC Access

After running the script, you can connect to your VNC server at:

```
YOUR_SERVER_IP:5901
```

You'll need a VNC client like RealVNC, TightVNC, or VNC Viewer to connect.

## Post-Installation

- **Starting n8n**: Run `n8n start` to launch n8n
- **Restarting VNC**: If you need to restart the VNC server, run `vncserver`
- **Stopping VNC**: To stop the VNC server, run `vncserver -kill :1`

## Security Considerations

- This script sets up a basic VNC password during the first run
- For production use, consider setting up SSH tunneling or VPN for VNC connections
- Consider adding a systemd service for automatically starting VNC on boot

## Troubleshooting

If you encounter issues:

1. Check log files in `~/.vnc/`
2. Ensure your firewall allows connections on port 5901
3. For NVM issues, try reloading your shell or manually sourcing NVM with:
   ```bash
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
   ```

## Contributing

Feel free to submit issues or pull requests to improve this script.
