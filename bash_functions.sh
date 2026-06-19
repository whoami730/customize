#!/bin/bash

#
# System Updates
#

function mini_system_update() {
    echo "Starting mini system update..."
    sudo apt update
    sudo apt upgrade -y
    echo "Updated apt packages"
    echo "Mini system update completed."
}

function addn_system_update() {
    echo "Starting additional updates..."
    if command -v atuin &>/dev/null; then
        atuin-update
        echo "Updated atuin"
    else
        echo "atuin not found, skipping"
    fi
    if command -v rustup &>/dev/null; then
        rustup update
        echo "Updated rust toolchain"
    else
        echo "rustup not found, skipping"
    fi
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

#
# Navigation
#

# mkdir + cd in one step
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# cd up N directories (default 1)
function up() {
    local d="" n=${1:-1}
    for ((i=0; i<n; i++)); do d="../$d"; done
    cd "${d:-.}"
}

#
# Files & Archives
#

# universal archive extractor
function extract() {
    if [[ ! -f "$1" ]]; then
        echo "'$1' is not a valid file"
        return 1
    fi
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.tar.zst) tar --zstd -xf "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.zip)     unzip "$1" ;;
        *.7z)      7z x "$1" ;;
        *.rar)     unrar x "$1" ;;
        *.xz)      xz --decompress "$1" ;;
        *.zst)     zstd --decompress "$1" ;;
        *)         echo "'$1' cannot be extracted"; return 1 ;;
    esac
}

# hex byte-level diff between two binary files
function bdiff() {
    diff <(od -An -tx1 -w1 -v "$1") \
         <(od -An -tx1 -w1 -v "$2")
}

#
# Network
#

# kill whatever process is listening on a given port
function port_kill() {
    local port=${1:?Usage: port_kill <port>}
    local pids
    pids=$(lsof -ti :"$port") || { echo "Nothing on port $port"; return 1; }
    echo "$pids" | xargs kill -9
    echo "Killed PID(s) $pids on port $port"
}
