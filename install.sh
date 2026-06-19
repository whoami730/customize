#!/bin/bash

set -e

INSTALL_DIR="$HOME/customize"
BASHRC="$HOME/.bashrc"
SOURCE_LINE=". \"\$HOME/customize/functions.sh\""

if [ -d "$INSTALL_DIR" ]; then
    echo "Already exists at $INSTALL_DIR — pulling latest..."
    git -C "$INSTALL_DIR" pull
else
    git clone https://github.com/whoami730/customize.git "$INSTALL_DIR"
fi

if ! grep -qF "$SOURCE_LINE" "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo "# Custom shell functions" >> "$BASHRC"
    echo "$SOURCE_LINE" >> "$BASHRC"
    echo "Added source line to $BASHRC"
else
    echo "Already sourced in $BASHRC — skipping"
fi

echo "Done. Run: source ~/.bashrc"
