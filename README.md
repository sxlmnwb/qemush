# Qemush - Virtualization Machine

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/platform-linux-blue.svg)
![Shell](https://img.shields.io/badge/shell-bash-green.svg)
![Status](https://img.shields.io/badge/status-active-success.svg)
![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)

Qemush is a lightweight and portable shell-based utility to quickly set up, configure, and launch QEMU virtual machines on any Linux distribution.  
It automatically verifies required dependencies, prepares cloud images, and boots your VM with minimal user intervention.

### 📑 Table of Contents
- [📂 Project Structure](#-project-structure)
  - [🚀 Features](#-features)
  - [⚡ Getting Started](#-getting-started)
    - [1. Clone the repository](#1-clone-the-repository)
    - [2. Make scripts executable](#2-make-scripts-executable)
    - [3. And launch startx](#3-and-launch-startx)
  - [⚙️ Configuration](#️-configuration)
  - [🧰 Requirements](#-requirements)
  - [📜 License](#-license)
  - [🖊️ Contribution](#-contribution)
    - [1. Code Style](#1-code-style)
    - [2. Submit Your Contribution](#2-submit-your-contribution)
    - [3. Need Help?](#3-need-help)
  - [🔮 Future Enhancements](#-future-enhancements)

---

### 📂 Project Structure

```
qemush/
├── config/
│   └── env.sh              # VM environment configuration
├── libs/
│   ├── check-tools.sh      # Install dependency and checker
│   └── logging.sh          # Logging utilities
└── startx                  # Main launcher script

```

### 🚀 Features

- Cross-distro support — works on Debian, Fedora, Arch, RHEL, SUSE, Alpine, and more.  
- Automatic dependency installation — installs QEMU, Cloud-Init, and utilities if missing.  
- Modular configuration — easily customize CPU, RAM, disk, and SSH port in config/env.sh.  
- Cloud-image ready — automatically downloads and converts Debian cloud images.  
- Simple QEMU integration — starts the VM with one command.  
- Snap/Flatpak fallback — supports package managers beyond APT/YUM/Pacman.

---

### ⚡ Getting Started

#### 1. Clone the repository
```bash
git clone https://github.com/sxlmnwb/qemush.git
cd qemush
```
#### 2. Make scripts executable
```bash
chmod +x startx libs/*.sh
```
#### 3. And launch startx
```bash
./startx
```

---

### ⚙️ Configuration

All VM parameters are stored in config/env.sh.  
You can edit this file or override variables at runtime.

Variable | Description | Default
--------- | ------------ | --------
VM_DIR | Directory VM files are stored | $(pwd)/qemush-vm
IMG_URL | Image of URL | https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2
IMG_FILE | Root disk | $(pwd)/qemush-vm/images.qcow2
DATA_DISK | Secondary disk | $(pwd)/qemush-vm/data-disk.qcow2
SEED_FILE | cloud-init seed ISO file | $(pwd)/qemush-vm/seed.iso
MEMORY | VM RAM size | 8G
SWAP_SIZE | Size of swap | 2G
CPUS | Number of CPUs | 4
SSH_PORT | Host SSH forwarding port | 2222
ROOT_DISK_SIZE | Size of root system disk | 16G
DATA_DISK_SIZE | Size of secondary data disk | 64G
HOSTNAME | VM hostname | qemush
USERNAME | VM user | qemush
PASSWORD | VM password | qemush
---

### 🧰 Requirements

- Any modern Linux distribution
- Root privileges
- Internet connection
- Have a balls lmao

### 📜 License

Qemush is distributed under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](https://github.com/sxlmnwb/qemush/blob/master/LICENSE) file for more details.

---

### 🖊️ Contribution
Contributions are always welcome!  
Whether it's fixing a typo, improving documentation, or adding new features — every contribution helps make **Qemush** better.

#### 1. Code Style
- Use **Bash best practices** (proper quoting, consistent indentation).  
- Keep functions **modular**, **clean**, and **reusable**.  
- All scripts must start with:
  ```bash
  #!/usr/bin/env bash
  ```
- Use clear and descriptive commit messages:
  ```
  feat: add new qemu configuration options
  fix: correct missing dependency installation
  docs: update README with setup instructions
  ```

#### 2. Submit Your Contribution
- 💡 **Open an Issue:**  
  Found a bug or have an idea? Create one here → [New Issue](https://github.com/sxlmnwb/qemush/issues/new)
  
- 🔁 **Submit a Pull Request:**  
  Ready to contribute your fix or feature? Create a PR here → [New Pull Request](https://github.com/sxlmnwb/qemush/pulls)

#### 3. Need Help?
For questions or guidance, feel free to reach out to [@sxlmnwb](https://github.com/sxlmnwb)  
or start a discussion in the [Issues section](https://github.com/sxlmnwb/qemush/issues).

---

### 🔮 Future Enhancements
- [ ] Advanced networking (bridge, NAT, TUN/TAP)  
- [ ] Snapshot management
- [ ] CLI arguments for quick config overrides  
- [ ] Image caching and compression optimization  

---

"Qemush aims to make QEMU virtualization fast, consistent, and universal across all Linux systems."
