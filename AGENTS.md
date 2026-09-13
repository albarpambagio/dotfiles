# AGENTS.md

Dotfiles repo for Omarchy (Arch Linux + Hyprland). Symlinks configs into `~/.config/` — no build, test, or lint pipeline.

## Key Facts

- `install.sh --laptop` creates symlinks from this repo to `~/.config/`. It backs up existing files but never deletes.
- `machines/laptop/` contains hardware-specific configs (monitors, touchpad, speaker EQ, AMD GPU). These override universal configs when `--laptop` is passed.
- `feed-url.txt` (Google Calendar secret) is excluded by `.gitignore`. Never commit it.
- `git/config` has placeholder name/email — users set their own post-install.
- hyprsunset is managed by systemd (`systemd/user/hyprsunset.service`), not Hyprland autostart.

## Scripts

| Script | Language | Purpose |
|--------|----------|---------|
| `local/bin/omarchy-gcal-notify` | Python | Desktop notifications for upcoming calendar events |
| `local/bin/omarchy-monitor-scale` | Bash | SUPER+/- dual-monitor scaling (persists to monitors.lua) |
| `local/bin/omarchy-workspace-switch` | Bash | Per-monitor SUPER+1-9 workspace routing |
| `local/bin/telegram-autostart.sh` | Bash | Systemd timer companion for Telegram launch |

These scripts are referenced by other configs (bindings.lua, systemd services). If you rename or move one, update all references.

## Conventions

- **Commit messages**: Follow the [7 rules](https://cbea.ms/git-commit/) — imperative mood, ≤50 char subject, body explains what/why.
- **Hyprland config**: Lua syntax (`hl.monitor(...)`, `o.bind(...)`, `hl.config({...})`). Not plain text.
- **Shell JSON**: `omarchy/shell.json` controls bar layout and widget placement. Widget IDs use `namespace.name` format (e.g., `0xrichardh.gcal-events`).
- **Systemd services**: All user-level, in `systemd/user/`. After install, run `systemctl --user daemon-reload`.

## Public Repo

This is a public repo. Before committing, verify:
- No personal emails, IPs, Tailscale addresses, or hardware-specific ALSA paths in modified files
- `git/config` must keep placeholder values (`<your-name>`, `<your-email>`)
- `zed/settings.json` must not contain SSH connections
- `.gitignore` excludes `**/feed-url.txt`, `**/*.secret`, `**/*.key`, `*.env`
