#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Set the times for day and night mode switching (24-hour format HH:MM)
DAY_START="07:00"
NIGHT_START="19:00"

# Set the names of your preferred light and dark global themes.
# You can find available themes in System Settings > Appearance > Global Theme.
# The names are often package-like, e.g., "org.kde.breeze.desktop" or "org.kde.breezedark.desktop"
LIGHT_THEME="org.kde.breeze.desktop"
DARK_THEME="org.kde.breezedark.desktop"
# --- End Configuration ---

# Ensure the script is running in a user session with access to D-Bus
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    # Find the D-Bus session address from the user's environment
    USER_ID=$(id -u)
    DBUS_SESSION_BUS_ADDRESS_FILE="/run/user/$USER_ID/bus"
    if [ -e "$DBUS_SESSION_BUS_ADDRESS_FILE" ]; then
        export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_SESSION_BUS_ADDRESS_FILE"
    else
        echo "Could not find D-Bus session address. Exiting." >&2
        exit 1
    fi
fi

# Get current time in HH:MM format
CURRENT_TIME=$(date +%H:%M)

# Function to set the theme
set_theme() {
    local theme_name="$1"
    echo "Setting global theme to $theme_name"
    lookandfeeltool --apply "$theme_name"
}

# Read the current theme from the configuration file
kdeglobals_file="$HOME/.config/kdeglobals"
current_theme=""
if [ -f "$kdeglobals_file" ]; then
    current_theme=$(grep -oP 'LookAndFeelPackage=\K.*' "$kdeglobals_file")
fi

# Determine target theme based on time
if [[ "$CURRENT_TIME" > "$DAY_START" && "$CURRENT_TIME" < "$NIGHT_START" ]]; then
    TARGET_THEME=$LIGHT_THEME
    TARGET_MODE="Day"
else
    TARGET_THEME=$DARK_THEME
    TARGET_MODE="Night"
fi

# Apply the theme if it's not already set
if [[ "$current_theme" != "$TARGET_THEME" ]]; then
    echo "It's $TARGET_MODE time. Current theme is '$current_theme', changing to '$TARGET_THEME'."
    set_theme "$TARGET_THEME"
else
    echo "It's $TARGET_MODE time. Theme '$TARGET_THEME' is already set. No change needed."
fi