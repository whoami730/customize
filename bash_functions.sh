#!/bin/bash

function mini_system_update() {
    echo "Starting mini system update..."
    sudo apt update
    sudo apt upgrade -y
    echo "Updated apt packages"
    echo "Mini system update completed."
}

function addn_system_update() {
    echo "Starting additional updates..."
    atuin-update
    echo "Updated atuin"
    rustup update
    echo "Updated rust toolchain"
    # Add python pip upgrades
    echo "Additional updates completed."
}

function system_update() {
    echo "Starting system update..."
    mini_system_update
    sudo apt full-upgrade -y
    sudo apt autoremove -y
    addn_system_update
    echo "System update completed."
}

function bdiff() {
  diff <(od -An -tx1 -w1 -v "$1") \
       <(od -An -tx1 -w1 -v "$2")
}
