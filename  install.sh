#!/bin/bash

set -e

# Define paths
SCRIPT_NAME="kde-day-night.sh"
SERVICE_NAME="kde-day-night.service"
TIMER_NAME="kde-day-night.timer"

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TARGET_SCRIPT_DIR="$HOME/.config/kde-day-night"
TARGET_SYSTEMD_DIR="$HOME/.config/systemd/user"

echo "Starting installation of KDE Day/Night Mode Automator..."

# Create target directories if they don't exist
echo "Creating target directories..."
mkdir -p "$TARGET_SCRIPT_DIR"
mkdir -p "$TARGET_SYSTEMD_DIR"

# Copy files
echo "Copying script and systemd unit files..."
cp "$SOURCE_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT_DIR/"
cp "$SOURCE_DIR/$SERVICE_NAME" "$TARGET_SYSTEMD_DIR/"
cp "$SOURCE_DIR/$TIMER_NAME" "$TARGET_SYSTEMD_DIR/"

# Make the script executable
echo "Setting script permissions..."
chmod +x "$TARGET_SCRIPT_DIR/$SCRIPT_NAME"

# Reload systemd user daemon, enable and start the timer
echo "Configuring and starting systemd timer..."
systemctl --user daemon-reload
systemctl --user enable --now "$TIMER_NAME"

echo ""
echo "Installation complete!"
echo "The script will now run every 15 minutes to check and switch your KDE theme."
echo "You can customize times and themes by editing:"
echo "  $TARGET_SCRIPT_DIR/$SCRIPT_NAME"
echo "To check the status of the timer, run:"
echo "  systemctl --user status $TIMER_NAME"
echo "To see the logs of the last run, run:"
echo "  journalctl --user -u $SERVICE_NAME -n 20"