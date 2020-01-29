#!/bin/sh
# (C) 2019 Ronsor Labs, the ra1nstorm contributors, et al.

# Fixes internationalization woes
export LANG=C
ID="$(id -u)"
STARTDIR="$(pwd)"
DISTRO=""

echo $USER_AT_START

if [ "$ID" != 0 ]; then
	echo "ra1nstorm must be run as root"
	which sudo 2>&1 >/dev/null && exec sudo $0
	echo "enter root password below"
	exec su -c $0
fi
echo "Checking if zenity and gawk are installed..."
# Determine Distro
if apt -h; then
	DISTRO="DEBIAN"
	which gawk 2>&1 >/dev/null || apt install -y gawk
	which zenity 2>&1 >/dev/null || apt install -y zenity
elif pacman -h; then
	DISTRO="ARCH"
	which gawk 2>&1 >/dev/null || pacman -Sy --noconifrm gawk
	which zenity 2>&1 >/dev/null || pacman -Sy --noconifrm zenity
else
	echo "Error. Unsupported Distro"
	exit
fi
echo "Launching setup..."
gawk -v origUser="$SUDO_USER" -v dist="$DISTRO" -f main.awk 2>&1 | tee -a /tmp/ra1nstorm.log
