#!/bin/bash

set -e

THEME_DIR="/usr/share/plymouth/themes/dorian"

sudo mkdir -p "$THEME_DIR"

sudo cp splash.png "$THEME_DIR/"
sudo cp dorian.plymouth "$THEME_DIR/"
sudo cp dorian.script "$THEME_DIR/"

sudo update-alternatives --install 
/usr/share/plymouth/themes/default.plymouth 
default.plymouth 
"$THEME_DIR/dorian.plymouth" 
100

sudo update-alternatives --set 
default.plymouth 
"$THEME_DIR/dorian.plymouth"

sudo update-initramfs -u

echo "Dorian Plymouth installed."
