#!/bin/bash

export WAYLAND_DISPLAY=wayland-1
export DISPLAY=:0
export XDG_RUNTIME_DIR=/run/user/1000
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

LOG=/tmp/telegram-autostart.log

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"
}

log "Starting telegram-autostart"

if pgrep -x Telegram >/dev/null 2>&1; then
  log "Telegram already running, exiting"
  exit 0
fi

WAYLAND_SOCKET="$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
TIMEOUT=60
ELAPSED=0

while [ ! -S "$WAYLAND_SOCKET" ]; do
  if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
    log "Timed out waiting for Wayland socket at $WAYLAND_SOCKET"
    exit 1
  fi
  log "Waiting for Wayland socket... ($ELAPSED/${TIMEOUT}s)"
  sleep 2
  ELAPSED=$((ELAPSED + 2))
done

log "Wayland socket found, launching Telegram"
/usr/bin/Telegram &
TELEGRAM_PID=$!
log "Telegram launched with PID $TELEGRAM_PID"

sleep 3
if kill -0 "$TELEGRAM_PID" 2>/dev/null; then
  log "Telegram is running"
else
  log "Telegram exited prematurely"
fi
