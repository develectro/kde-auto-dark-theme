# KDE Day/Night Mode Automator

Automatically switches your KDE Plasma Global Theme between a light and dark variant based on the time of day.

## How It Works

This project uses a simple shell script that is executed periodically by a `systemd` user timer.

-   **`kde-day-night.sh`**: The core script that checks the current time and applies the appropriate KDE Global Theme using `lookandfeeltool`.
-   **`kde-day-night.service`**: A `systemd` user service that runs the shell script.
-   **`kde-day-night.timer`**: A `systemd` user timer that triggers the service every 15 minutes.

## Prerequisites

-   A Linux distribution with KDE Plasma 5.
-   `systemd` (used by most modern Linux distributions).
-   Your desired light and dark Global Themes must be installed.

## Installation

1.  Save all the project files (`kde-day-night.sh`, `install.sh`, etc.) into a single directory.

2.  Open a terminal and navigate into that directory.

3.  Run the installer:
    The installer will copy the files to the correct locations (`~/.config/`) and enable the `systemd` timer for your user.
    ```bash
    bash ./install.sh
    ```

That's it! The script will now run automatically.

## Configuration

If you want to change the times or the themes, you can edit the configuration section at the top of the script:

`~/.config/kde-day-night/kde-day-night.sh`

```bash
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
```

### Finding Theme Names

You can find the internal names of your installed Global Themes by looking in `System Settings > Appearance > Global Theme` or by listing the contents of `/usr/share/plasma/look-and-feel/`. The directory names correspond to the theme names (e.g., `org.kde.breezedark.desktop`).

## Usage

The script runs automatically. To manually trigger a theme check, you can run:

```bash
systemctl --user start kde-day-night.service
```

### Checking Status and Logs

To check the status of the timer: `systemctl --user status kde-day-night.timer`

To view the logs from the script: `journalctl --user -u kde-day-night.service`

## Uninstallation

To remove the automation, simply run these commands:

```bash
systemctl --user stop kde-day-night.timer
systemctl --user disable kde-day-night.timer
rm ~/.config/systemd/user/kde-day-night.{service,timer}
rm -r ~/.config/kde-day-night
systemctl --user daemon-reload
```