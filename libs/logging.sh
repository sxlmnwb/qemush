#!/usr/bin/env bash
# ===============================================
# qemush - libs/logging.sh
# Shared logging utility for shell scripts
# Provides timestamped, colorized, and leveled logs
# Author: @sxlmnwb <sxlmnwb.dev@gmail.com>
# ===============================================

# --- Configuration ---
LOG_LEVEL="${LOG_LEVEL:-INF}"   # Default: show info and above
LOG_FILE_PATH="${LOG_FILE_PATH:-/tmp/qemush.log}"  # Optional file output

# --- Colors ---
_color_reset="\e[0m"
_color_dbg="\e[36m"   # Cyan
_color_inf="\e[34m"   # Blue
_color_ok="\e[92m"    # Bright green (OK)
_color_warn="\e[33m"  # Yellow
_color_err="\e[31m"   # Red

# --- Convert log level to numeric value for filtering ---
__log_level_value() {
    case "$1" in
        DBG) echo 0 ;;
        INF|OK) echo 1 ;;
        WARN) echo 2 ;;
        ERR) echo 3 ;;
        *) echo 1 ;;  # Default = INF
    esac
}

# --- Core logging function ---
log() {
    local level="$1"; shift
    local msg="$*"

    local level_value="$(__log_level_value "$level")"
    local current_value="$(__log_level_value "$LOG_LEVEL")"

    # Skip messages below current log level
    if (( level_value < current_value )); then
        return
    fi

    local color="$_color_reset"
    case "$level" in
        DBG) color="$_color_dbg" ;;
        INF) color="$_color_inf" ;;
        OK)  color="$_color_ok" ;;
        WARN) color="$_color_warn" ;;
        ERR) color="$_color_err" ;;
    esac

    local timestamp
    timestamp="$(date +"%Y-%m-%dT%H:%M:%S.%3N")"

    # Print to stdout with color
    echo -e "${timestamp} ${color}${level}${_color_reset} ${msg}"

    # Save to file (no color)
    if [[ -n "$LOG_FILE_PATH" ]]; then
        echo "${timestamp} ${level} ${msg}" >> "$LOG_FILE_PATH"
    fi
}

# --- Convenience helpers ---
log_dbg()  { log DBG "$@"; }
log_inf()  { log INF "$@"; }
log_ok()   { log OK "$@"; }
log_warn() { log WARN "$@"; }
log_err()  { log ERR "$@"; }
