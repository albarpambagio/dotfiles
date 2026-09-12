#!/usr/bin/env bash
# install.sh — Symlink dotfiles into ~/.config and set up the environment.
#
# Usage:
#   ./install.sh              # Universal configs only
#   ./install.sh --laptop     # Universal + laptop-specific presets
#
# Existing files are backed up with a .bak.<timestamp> suffix before
# overwriting. The script never deletes anything — it only creates
# symlinks and backup copies.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"
LOCAL_BIN="${HOME}/.local/bin"

# ── Helpers ──────────────────────────────────────────────────────────

info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[ok]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$*"; }
err()   { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

backup_and_link() {
  local src="$1" dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ] || [ -d "$dst" ]; then
    local bak="${dst}.bak.$(date +%s)"
    warn "Backing up existing $dst → $bak"
    mv "$dst" "$bak"
  fi

  ln -sf "$src" "$dst"
}

# ── Parse args ───────────────────────────────────────────────────────

MACHINE=""
for arg in "$@"; do
  case "$arg" in
    --laptop)  MACHINE="laptop" ;;
    --desktop) MACHINE="desktop" ;;
    --help|-h)
      echo "Usage: $0 [--laptop|--desktop]"
      exit 0
      ;;
    *)
      err "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

# ── Pre-flight ───────────────────────────────────────────────────────

if [ ! -d "$DOTFILES_DIR/hypr" ]; then
  err "Dotfiles directory not found: $DOTFILES_DIR"
  exit 1
fi

info "Installing dotfiles from $DOTFILES_DIR"
[ -n "$MACHINE" ] && info "Machine preset: $MACHINE"

mkdir -p "$CONFIG_DIR" "$LOCAL_BIN"

# ── Universal configs ────────────────────────────────────────────────

info "Linking universal configs..."

# Hyprland
backup_and_link "$DOTFILES_DIR/hypr/autostart.lua"    "$CONFIG_DIR/hypr/autostart.lua"
backup_and_link "$DOTFILES_DIR/hypr/hyprsunset.conf"   "$CONFIG_DIR/hypr/hyprsunset.conf"
backup_and_link "$DOTFILES_DIR/hypr/hypr-persist.toml" "$CONFIG_DIR/hypr/hypr-persist.toml"

# Omarchy shell, defaults, hooks
backup_and_link "$DOTFILES_DIR/omarchy/shell.json"  "$CONFIG_DIR/omarchy/shell.json"
mkdir -p "$CONFIG_DIR/omarchy/defaults"
backup_and_link "$DOTFILES_DIR/omarchy/defaults/agent" "$CONFIG_DIR/omarchy/defaults/agent"

# Hooks
mkdir -p "$CONFIG_DIR/omarchy/hooks/post-update.d" "$CONFIG_DIR/omarchy/hooks/theme-set.d"
for hook in install-voxtype.hook setup-agent.hook setup-fingerprint.hook; do
  backup_and_link "$DOTFILES_DIR/omarchy/hooks/post-update.d/$hook" \
                  "$CONFIG_DIR/omarchy/hooks/post-update.d/$hook"
done
backup_and_link "$DOTFILES_DIR/omarchy/hooks/theme-set.d/omazed" \
                "$CONFIG_DIR/omarchy/hooks/theme-set.d/omazed"

# Plugins
mkdir -p "$CONFIG_DIR/omarchy/plugins"
backup_and_link "$DOTFILES_DIR/omarchy/plugins/0xrichardh.gcal-events" \
                "$CONFIG_DIR/omarchy/plugins/0xrichardh.gcal-events"

# Themes
mkdir -p "$CONFIG_DIR/omarchy/themes"
backup_and_link "$DOTFILES_DIR/omarchy/themes/wallhaven-d8dokj" \
                "$CONFIG_DIR/omarchy/themes/wallhaven-d8dokj"

# Terminals
backup_and_link "$DOTFILES_DIR/foot/foot.ini" "$CONFIG_DIR/foot/foot.ini"

# Git
backup_and_link "$DOTFILES_DIR/git/config" "$CONFIG_DIR/git/config"

# Neovim
mkdir -p "$CONFIG_DIR/nvim"
backup_and_link "$DOTFILES_DIR/nvim/init.lua" "$CONFIG_DIR/nvim/init.lua"
backup_and_link "$DOTFILES_DIR/nvim/lua"      "$CONFIG_DIR/nvim/lua"
[ -d "$DOTFILES_DIR/nvim/plugin" ] && backup_and_link "$DOTFILES_DIR/nvim/plugin" "$CONFIG_DIR/nvim/plugin"

# OpenCode
mkdir -p "$CONFIG_DIR/opencode/plugins"
backup_and_link "$DOTFILES_DIR/opencode/opencode.json"       "$CONFIG_DIR/opencode/opencode.json"
backup_and_link "$DOTFILES_DIR/opencode/tui.json"            "$CONFIG_DIR/opencode/tui.json"
backup_and_link "$DOTFILES_DIR/opencode/tui.jsonc"           "$CONFIG_DIR/opencode/tui.jsonc"
backup_and_link "$DOTFILES_DIR/opencode/package.json"        "$CONFIG_DIR/opencode/package.json"
backup_and_link "$DOTFILES_DIR/opencode/.gitignore"          "$CONFIG_DIR/opencode/.gitignore"
backup_and_link "$DOTFILES_DIR/opencode/herdr-tui-session.js" "$CONFIG_DIR/opencode/herdr-tui-session.js"
backup_and_link "$DOTFILES_DIR/opencode/plugins/herdr-agent-state.js" "$CONFIG_DIR/opencode/plugins/herdr-agent-state.js"

# Zed
mkdir -p "$CONFIG_DIR/zed/themes"
backup_and_link "$DOTFILES_DIR/zed/settings.json"  "$CONFIG_DIR/zed/settings.json"
backup_and_link "$DOTFILES_DIR/zed/themes/omazed.json" "$CONFIG_DIR/zed/themes/omazed.json"

# Herdr
backup_and_link "$DOTFILES_DIR/herdr/config.toml" "$CONFIG_DIR/herdr/config.toml"

# Mise
backup_and_link "$DOTFILES_DIR/mise/config.toml" "$CONFIG_DIR/mise/config.toml"

# Fonts
mkdir -p "$CONFIG_DIR/fontconfig"
backup_and_link "$DOTFILES_DIR/fontconfig/fonts.conf" "$CONFIG_DIR/fontconfig/fonts.conf"

# Aether
mkdir -p "$CONFIG_DIR/aether"
backup_and_link "$DOTFILES_DIR/aether" "$CONFIG_DIR/aether"

# Btop
backup_and_link "$DOTFILES_DIR/btop/btop.conf" "$CONFIG_DIR/btop/btop.conf"

# Voxtype
mkdir -p "$CONFIG_DIR/voxtype"
backup_and_link "$DOTFILES_DIR/voxtype/config.toml" "$CONFIG_DIR/voxtype/config.toml"

# Tmux
mkdir -p "$CONFIG_DIR/tmux"
backup_and_link "$DOTFILES_DIR/tmux/tmux.conf" "$CONFIG_DIR/tmux/tmux.conf"

# XDG
backup_and_link "$DOTFILES_DIR/mimeapps.list"    "$CONFIG_DIR/mimeapps.list"
backup_and_link "$DOTFILES_DIR/xdg-terminals.list" "$CONFIG_DIR/xdg-terminals.list"

# nwg-look
mkdir -p "$CONFIG_DIR/nwg-look"
backup_and_link "$DOTFILES_DIR/nwg-look/config" "$CONFIG_DIR/nwg-look/config"

# Systemd user services
mkdir -p "$CONFIG_DIR/systemd/user"
for svc in omarchy-gcal-notify.service omarchy-gcal-notify.timer \
           telegram-autostart.service telegram-autostart.timer \
           voxtype.service; do
  backup_and_link "$DOTFILES_DIR/systemd/user/$svc" \
                  "$CONFIG_DIR/systemd/user/$svc"
done

# Custom scripts in ~/.local/bin
backup_and_link "$DOTFILES_DIR/local/bin/omarchy-gcal-notify" \
                "$LOCAL_BIN/omarchy-gcal-notify"

ok "Universal configs linked."

# ── Machine-specific configs ─────────────────────────────────────────

if [ -n "$MACHINE" ]; then
  MACHINE_DIR="$DOTFILES_DIR/machines/$MACHINE"
  if [ ! -d "$MACHINE_DIR" ]; then
    err "No preset directory for machine: $MACHINE_DIR"
    exit 1
  fi

  info "Linking $MACHINE machine-specific configs..."

  # Hyprland (overrides universal defaults)
  for f in monitors.lua input.lua bindings.lua; do
    [ -f "$MACHINE_DIR/hypr/$f" ] && \
      backup_and_link "$MACHINE_DIR/hypr/$f" "$CONFIG_DIR/hypr/$f"
  done

  # PipeWire speaker EQ
  if [ -f "$MACHINE_DIR/pipewire/speaker-eq.conf" ]; then
    mkdir -p "$CONFIG_DIR/pipewire"
    backup_and_link "$MACHINE_DIR/pipewire/speaker-eq.conf" \
                    "$CONFIG_DIR/pipewire/speaker-eq.conf"
  fi

  # Speaker EQ systemd service
  if [ -f "$MACHINE_DIR/systemd/user/speaker-eq.service" ]; then
    backup_and_link "$MACHINE_DIR/systemd/user/speaker-eq.service" \
                    "$CONFIG_DIR/systemd/user/speaker-eq.service"
  fi

  # EasyEffects
  if [ -f "$MACHINE_DIR/easyeffects/db/easyeffectsrc" ]; then
    mkdir -p "$CONFIG_DIR/easyeffects/db"
    backup_and_link "$MACHINE_DIR/easyeffects/db/easyeffectsrc" \
                    "$CONFIG_DIR/easyeffects/db/easyeffectsrc"
  fi

  ok "$MACHINE machine-specific configs linked."
fi

# ── Post-install notes ──────────────────────────────────────────────

echo ""
info "Installation complete!"
echo ""
echo "  Next steps:"
echo "    1. Restart the shell:   omarchy restart shell"
echo "    2. Reload systemd:      systemctl --user daemon-reload"
echo "    3. Enable notify timer: systemctl --user enable --now omarchy-gcal-notify.timer"
echo "    4. Paste your Google Calendar feed URL into:"
echo "       ~/.local/state/omarchy/plugins/0xrichardh.gcal-events/feed-url.txt"
echo ""
