#!/usr/bin/env bash
# ===============================================
# qemush - libs/check-tools.sh
# Verify and install required system tools
# Supports all major Linux ecosystems + Snap/Flatpak fallback
# Author: @sxlmnwb <sxlmnwb.dev@gmail.com>
# ===============================================

set -e

LOG_FILE="./libs/logging.sh"

# --- Verify helper files ---
if [[ ! -f "$LOG_FILE" ]]; then
    echo -e "$(date +"%Y-%m-%dT%H:%M:%S.%3N") \e[31mERR\e[0m missing file=$LOG_FILE"
    exit 1
fi
source "$LOG_FILE"

# --- Required tools ---
TOOLS=(
    qemu-system
    qemu-img
    cloud-localds
    wget
)

# --- Detect Linux distribution and package manager ---
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        PRETTY_NAME=${PRETTY_NAME,,}
        ID=${ID,,}
        ID_LIKE=${ID_LIKE,,}
    fi

    case "$ID" in
        debian|ubuntu|kali|pop|linuxmint|raspbian)
            OS="debian"
            PKG_UPDATE="apt-get update -y"
            PKG_INSTALL="apt-get install -y"
            ;;
        fedora)
            OS="fedora"
            PKG_UPDATE="dnf update -y"
            PKG_INSTALL="dnf install -y"
            ;;
        centos|rhel|rocky|alma|ol|redhat)
            OS="rhel"
            PKG_UPDATE="yum update -y"
            PKG_INSTALL="yum install -y"
            ;;
        arch|manjaro|endeavouros|garuda)
            OS="arch"
            PKG_UPDATE="pacman -Sy"
            PKG_INSTALL="pacman -S --noconfirm"
            ;;
        gentoo)
            OS="gentoo"
            PKG_UPDATE="emerge --sync"
            PKG_INSTALL="emerge --ask=n"
            ;;
        opensuse*|sles)
            OS="suse"
            PKG_UPDATE="zypper refresh"
            PKG_INSTALL="zypper install -y"
            ;;
        alpine)
            OS="alpine"
            PKG_UPDATE="apk update"
            PKG_INSTALL="apk add --no-cache"
            ;;
        *)
            OS="unknown"
            ;;
    esac
}

# --- Helper: detect any qemu-system-* binary ---
has_qemu_system() {
    if command -v qemu-system &>/dev/null; then
        return 0
    fi
    if compgen -c | grep -q '^qemu-system-'; then
        return 0
    fi
    return 1
}

# --- Fallback installers ---
install_with_snap() {
    local tool="$1"
    if command -v snap &>/dev/null; then
        log_warn "attempting snap install for $tool"
        snap install "$tool" &>/dev/null && return 0 || return 1
    fi
    return 1
}

install_with_flatpak() {
    local tool="$1"
    if command -v flatpak &>/dev/null; then
        log_warn "attempting flatpak install for $tool"
        flatpak install -y flathub "$tool" &>/dev/null && return 0 || return 1
    fi
    return 1
}

# --- Install missing tools ---
install_tools() {
    log_inf "detected operation system $PRETTY_NAME ID_LIKE=$OS"

    if [ "$OS" = "unknown" ]; then
        log_warn "unknown operation system detected — trying fallback via snap/flatpak if available"
    else
        log_inf "updating package repositories"
        eval "$PKG_UPDATE"
    fi

    for tool in "${TOOLS[@]}"; do
        # --- Special detection for qemu-system ---
        if [ "$tool" = "qemu-system" ]; then
            if has_qemu_system; then
                log_inf "qemu-system (any variant) already installed"
                continue
            fi
        elif command -v "$tool" &>/dev/null; then
            log_inf "$tool is already installed"
            continue
        fi

        log_warn "$tool not found, attempting installation"

        if [ "$OS" != "unknown" ]; then
            case "$tool" in
                qemu-system)
                    case "$OS" in
                        debian) eval "$PKG_INSTALL qemu-system" ;;
                        fedora) eval "$PKG_INSTALL @virtualization" ;;
                        rhel) eval "$PKG_INSTALL qemu-kvm" ;;
                        arch) eval "$PKG_INSTALL qemu-full qemu-img" ;;
                        gentoo) eval "$PKG_INSTALL app-emulation/qemu" ;;
                        suse) eval "$PKG_INSTALL qemu qemu-kvm" ;;
                        alpine) eval "$PKG_INSTALL qemu qemu-img qemu-system-x86_64" ;;
                        *) eval "$PKG_INSTALL qemu-system || $PKG_INSTALL qemu-full" ;;
                    esac
                    ;;
                qemu-img)
                    case "$OS" in
                        alpine) eval "$PKG_INSTALL qemu-img" ;;
                        *) eval "$PKG_INSTALL qemu-utils || true" ;;
                    esac
                    ;;
                cloud-localds)
                    case "$OS" in
                        debian) eval "$PKG_INSTALL cloud-image-utils" ;;
                        fedora|rhel) eval "$PKG_INSTALL cloud-utils-growpart" ;;
                        arch|alpine|suse|gentoo) eval "$PKG_INSTALL cloud-utils" ;;
                        *) eval "$PKG_INSTALL cloud-utils" ;;
                    esac
                    ;;
                wget)
                    eval "$PKG_INSTALL wget"
                    ;;
            esac
        fi

        # --- Verify again ---
        if [ "$tool" = "qemu-system" ]; then
            has_qemu_system && { log_ok "qemu-system installed successfully"; continue; }
        elif command -v "$tool" &>/dev/null; then
            log_ok "$tool installed successfully"
            continue
        fi

        # --- Try Snap or Flatpak fallback ---
        if install_with_snap "$tool" || install_with_flatpak "$tool"; then
            log_inf "$tool installed via snap/flatpak"
        else
            log_err "failed to install $tool — please install manually"
            exit 1
        fi
    done
}

# --- Run checks ---
detect_os
install_tools

log_inf "all required tools are installed or verified"
