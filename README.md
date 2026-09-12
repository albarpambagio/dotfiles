# Omarchy Dotfiles

Personal [Omarchy](https://omarchy.org/) configuration — a curated set of
keybindings, bar widgets, theming, automation hooks, and tool configs that
can be dropped onto a fresh install.

## What's Included

| Category | Configs |
|----------|---------|
| **Hyprland** | Night light (hyprsunset), window layout persistence (hypr-persist), autostart apps |
| **Bar** | Transparent bar, Google Calendar widget, media + Tailscale widgets |
| **Plugins** | `0xrichardh.gcal-events` — next event + agenda popup + Join links |
| **Notifications** | Desktop calendar alerts at 60/15/5 min before events |
| **Themes** | Custom Catppuccin Mocha-inspired theme (`wallhaven-d8dokj`) |
| **Hooks** | Post-update invites for Voxtype, agent setup, fingerprint |
| **Terminals** | Foot with iA Writer Mono S font |
| **Editor** | Neovim (LazyVim), Zed with custom Omazed theme |
| **Dev tools** | Mise (node, gh, opencode), Herdr (tmux-like), OpenCode |
| **Audio** | PipeWire speaker EQ (laptop preset) |
| **Systemd** | Google Calendar notify timer, Telegram weekday launch, Voxtype daemon |
| **GPU** | AMD GPU kernel params: full power mgmt (`ppfeaturemask=0xffffffff`), GPU recovery |

### Machine-Specific Presets

Hardware-dependent configs live in `machines/` and are applied only when you
pass a machine flag to the installer:

| Preset | What It Adds |
|--------|-------------|
| `--laptop` | Dual-monitor layout, Synaptics touchpad tuning, 3/4-finger swipe gestures, PipeWire speaker EQ, EasyEffects device config, AMD GPU kernel params script |

## Prerequisites

- [Omarchy](https://omarchy.org/) installed
- `git`, `curl`, `bash` (ship standard)
- `mise` for dev tool management (optional but recommended)

## Quick Start

```bash
# Clone the repo
git clone git@github.com:<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install universal configs
./install.sh

# Or install with machine-specific presets
./install.sh --laptop
```

The installer:
1. **Backs up** any existing config files (appends `.bak.<timestamp>`)
2. **Symlinks** all configs from this repo into `~/.config/`
3. **Links** custom scripts into `~/.local/bin/`

Nothing is deleted — existing files are preserved with timestamped backups.

## Post-Install

After running the installer, a few manual steps remain:

```bash
# 1. Restart the shell to pick up bar/theme changes
omarchy restart shell

# 2. Reload systemd user services
systemctl --user daemon-reload

# 3. Enable the calendar notification timer
systemctl --user enable --now omarchy-gcal-notify.timer

# 4. Set up Google Calendar (paste your secret iCal address)
#    Either click the bar pill or manually create the file:
mkdir -p ~/.local/state/omarchy/plugins/0xrichardh.gcal-events
echo "https://calendar.google.com/calendar/ical/.../basic.ics" \
  > ~/.local/state/omarchy/plugins/0xrichardh.gcal-events/feed-url.txt
chmod 600 ~/.local/state/omarchy/plugins/0xrichardh.gcal-events/feed-url.txt

# 5. (Laptop with AMD GPU only) Set GPU kernel parameters
sudo ./machines/laptop/boot/set-amd-gpu-params.sh
# Then reboot
```

## Repository Structure

```
dotfiles/
├── install.sh                  # Symlink installer
├── hypr/                       # Hyprland configs (universal)
│   ├── autostart.lua
│   ├── hyprsunset.conf
│   └── hypr-persist.toml
├── omarchy/
│   ├── shell.json              # Bar layout, widgets, idle settings
│   ├── defaults/agent          # Default AI agent
│   ├── hooks/                  # Automation hooks
│   ├── plugins/                # Bar plugins (gcal-events)
│   └── themes/                 # Custom themes
├── local/bin/                  # Custom scripts
├── foot/                       # Foot terminal
├── git/                        # Git config (name/email)
├── nvim/                       # Neovim (LazyVim)
├── opencode/                   # OpenCode AI assistant
├── zed/                        # Zed editor + custom theme
├── herdr/                      # Herdr terminal multiplexer
├── mise/                       # Dev tool versions
├── fontconfig/                 # Font preferences
├── aether/                     # Aether theme engine
├── systemd/user/               # User services
├── machines/
│   └── laptop/                 # Laptop-specific presets
│       ├── hypr/               # Monitors, input, bindings
│       ├── pipewire/           # Speaker EQ
│       ├── systemd/user/       # Speaker EQ service
│       ├── easyeffects/        # Audio device config
│       └── boot/               # AMD GPU kernel params (manual)
└── ...
```

## What's NOT Tracked

These files contain secrets or hardware-specific state and are intentionally
excluded via `.gitignore`:

| File | Reason |
|------|--------|
| `omarchy/plugins/.../feed-url.txt` | Google Calendar bearer token |
| `opencode/node_modules/` | NPM dependencies (reinstall with `npm install`) |
| `*.log`, `*.sock` | Runtime artifacts |
| `gcal-notify-state.json` | Notification dedup state |

## Customization

### Adding a New Machine

1. Create a preset directory:
   ```bash
   mkdir -p machines/my-machine/{hypr,pipewire}
   ```
2. Copy hardware-specific configs into it
3. Run: `./install.sh --my-machine`
4. Add the flag to `install.sh`'s `case` statement

### Updating the Plugin

The Google Calendar plugin is tracked directly. To update:

```bash
cd ~/.config/omarchy/plugins/0xrichardh.gcal-events
git pull origin main
omarchy-shell shell rescanPlugins
```

Or re-clone from upstream:

```bash
omarchy plugin remove 0xrichardh.gcal-events
omarchy plugin add https://github.com/0xRichardH/omarchy-gcal-events.git --enable
```

## License

Personal configuration — not a standalone project. Use freely.
