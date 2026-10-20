# Quickshell Panel

A Windows 10 action-center style side panel docked to the screen edge (like a bar, on the top layer),
with rounded corners and the Catppuccin Mocha palette (Mauve accent).

- Large time with today's date underneath
- Quick-toggle tiles (Wi-Fi, Bluetooth, DND, night light, airplane, lock)
- Volume and brightness sliders (`wpctl`, `brightnessctl`)
- Notification centre (the panel acts as the notification daemon; stop mako/dunst first)
- MPRIS now-playing card with transport controls and a live equalizer (needs `cava`, config in `cava.conf`)
- Power buttons

## Usage

    git clone <repo> ~/.config/quickshell/panel
    qs -c panel

Toggle visibility: `qs -c panel ipc call panel toggle` (also `show` / `hide`).

Icons use Nerd Font glyphs; the font is set in `Theme.qml`.
Tile commands assume `nmcli`, `bluetoothctl`, `makoctl`, `wlsunset`; edit `shell.qml` to suit.
Tile state is local and not synced with the system.
