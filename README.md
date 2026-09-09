# ROCK64 Game Console

Setup files for turning a 1 GB PINE64 ROCK64 running Armbian Debian Trixie into a RetroArch-based game console.

## Current hardware

- PINE64 ROCK64 (RK3328)
- 1 GB RAM
- 32 GB microSD
- Armbian Debian Trixie minimal
- RetroArch 1.20.0
- GC201 Controller1.00 USB gamepad

## Quick install

On the ROCK64, run:

```bash
git clone https://github.com/wdavev/Rock64.git
cd Rock64
sudo bash install.sh
```

The installer currently:

- installs the GC201 RetroArch autoconfig profile
- creates a ROM folder structure
- ensures RetroArch is configured to use udev joypads

More console setup will be added as we test it.
