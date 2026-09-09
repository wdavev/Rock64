#!/bin/bash
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this installer with sudo: sudo bash install.sh"
  exit 1
fi

REAL_USER="${SUDO_USER:-root}"
if [ "$REAL_USER" = "root" ]; then
  USER_HOME="/root"
else
  USER_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RA_DIR="$USER_HOME/.config/retroarch"
AUTOCONFIG_DIR="$RA_DIR/autoconfig/udev"
CFG="$RA_DIR/retroarch.cfg"
ROMS="$USER_HOME/roms"

echo "ROCK64 Game Console setup"
echo "User: $REAL_USER"
echo "Home: $USER_HOME"

apt-get update
apt-get install -y retroarch joystick git

mkdir -p "$AUTOCONFIG_DIR"
cp "$SCRIPT_DIR/retroarch/autoconfig/udev/GC201 Controller1.00.cfg" "$AUTOCONFIG_DIR/GC201 Controller1.00.cfg"

mkdir -p "$ROMS"/{atari2600,gb,gbc,gba,genesis,nes,snes,ps1}

mkdir -p "$RA_DIR"
touch "$CFG"

set_cfg() {
  local key="$1"
  local value="$2"
  if grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$CFG"; then
    sed -i -E "s|^[[:space:]]*${key}[[:space:]]*=.*|${key} = \"${value}\"|" "$CFG"
  else
    printf '%s = "%s"\n' "$key" "$value" >> "$CFG"
  fi
}

set_cfg input_joypad_driver udev
set_cfg joypad_autoconfig_dir "$RA_DIR/autoconfig"
set_cfg rgui_browser_directory "$ROMS"

if [ "$REAL_USER" != "root" ]; then
  chown -R "$REAL_USER:$REAL_USER" "$RA_DIR" "$ROMS"
fi

echo
echo "Installed GC201 controller configuration:"
cat "$AUTOCONFIG_DIR/GC201 Controller1.00.cfg"
echo
echo "ROM folders created under: $ROMS"
echo "Setup complete. Start RetroArch and test the controller."
