#!/bin/bash
echo "Installing user services and timers from ./services/..."

# Make sure user systemd dir exists
mkdir -p ~/.config/systemd/user

# Copy all .service and .timer files
cp -v /services/*.service ~/.config/systemd/user/
cp -v services/*.timer ~/.config/systemd/user/

# Reload systemd user units
echo "Reloading systemd user daemon..."
systemctl --user daemon-reload

# run custom services/timer
echo "Start and Enable all services"
systemctl --user enable --now

echo "All services and timers installed, enabled, and running."