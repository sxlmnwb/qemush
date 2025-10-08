#!/usr/bin/env bash
# ===============================================
# qemush - config/env.sh
# Setting your VM configuration variables
# Author: @sxlmnwb <sxlmnwb.dev@gmail.com>
# ===============================================

#IMAGE CONFIGURATION
export VM_DIR="$(pwd)/qemush-vm"
export IMG_URL="https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"
export IMG_FILE="$VM_DIR/images.qcow2"
export DATA_DISK="$VM_DIR/data-disk.qcow2"
export SEED_FILE="$VM_DIR/seed.iso"

#SYSTEM CONFIGURATION
export MEMORY=8G
export SWAP_SIZE=2G
export CPUS=4
export SSH_PORT=2222

#DISK CONFIGURATION
export ROOT_DISK_SIZE=16G
export DATA_DISK_SIZE=64G

#USER CONFIGURATION
export HOSTNAME="qemush"
export USERNAME="qemush"
export PASSWORD="qemush"
