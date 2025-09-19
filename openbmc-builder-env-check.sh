#!/usr/bin/env bash

set -e

USER_ID=${LOCAL_UID:-1000}
GROUP_ID=${LOCAL_GID:-1000}
USER_NAME=${LOCAL_USER:-builder}
USER_HOME="/home/${USER_NAME}"

# List of required packages
REQUIRED_PKGS=(
  git
  python3
  gcc
  g++
  make
  file
  wget
  gawk
  diffstat
  bzip2
  cpio
  chrpath
  zstd
  lz4
  locales
)

function checking_packages() {
    echo
    echo "Checking if the following packages are installed:"
    echo

    for pkg in "${REQUIRED_PKGS[@]}"; do
        if dpkg -s "$pkg" &> /dev/null; then
            version=$(dpkg -s "$pkg" | awk -F': ' '/^Version:/ {print $2}')
            echo "Installed: $pkg (version: $version)"
        else
            echo "Missing: $pkg"
            MISSING+=("$pkg")
        fi
    done

    if [ ${#MISSING[@]} -gt 0 ]; then
        echo
        echo "Installing missing packages: ${MISSING[*]}"
        sudo apt-get update
        sudo apt-get install -yy "${MISSING[@]}"
    else
        echo
        echo "All required packages are already installed!"
    fi
}

function create_group_user() {
    # Create group & user (if not exists)
    if ! getent group $GROUP_ID > /dev/null 2>&1; then
        groupadd -g $GROUP_ID $USER_NAME
    fi

    if ! id -u $USER_ID > /dev/null 2>&1; then
        useradd -u $USER_ID -g $GROUP_ID -s /bin/bash $USER_NAME
    fi

    # export $HOME and change to $HOME folder
    export HOME=$USER_HOME
    cd $HOME
}

function checking_system() {
    echo
    echo "Checking system resources:"
    echo

    # OS version
    OS_NAME=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
    OS_VERSION=$(grep '^VERSION=' /etc/os-release | cut -d= -f2 | tr -d '"')
    echo "$OS_NAME $OS_VERSION"

    # CPU check
    CPU_CORES=$(nproc)
    echo "Number of CPU cores: $CPU_CORES"
    if [ "$CPU_CORES" -lt 4 ]; then
        echo "[WARNING] Recommended: at least 4 CPU cores for OpenBMC build"
    fi

    # Memory check (in GB)
    TOTAL_MEM_GB=$(free -g | awk '/^Mem:/ {print $2}')
    echo "Total memory: ${TOTAL_MEM_GB} GB"
    if [ -z "$TOTAL_MEM_GB" ] || [ "$TOTAL_MEM_GB" -lt 8 ]; then
        echo "[WARNING] Recommended: at least 8 GB RAM for OpenBMC build"
    fi

    # Disk space check (in GB, current directory)
    DISK_AVAIL_GB=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    echo "Disk space available: ${DISK_AVAIL_GB} GB Mounted on $(df -h . | awk 'NR==2 {print $6}')"
    if [ "$DISK_AVAIL_GB" -lt 100 ]; then
        echo "[WARNING] Recommended: at least 100 GB free disk space"
    fi
}

function usage() {
    cat <<EOF
Usage: $0 [docker]

Environment checker for OpenBMC builder.

Without arguments:
  Checks if the host machine has all necessary tools and dependencies installed
  to build OpenBMC.

With 'docker' argument:
  Intended to run **inside Docker container**. Performs additional setup checks
  required for containerized builds (e.g., UID/GID sync, volume permissions, etc).

Examples:
  $0            # Check host environment
  $0 docker     # Check Docker container environment

EOF
}

# Handle help flag
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    usage
    exit 0
fi

# Main logic
if [[ "$1" == "docker" ]]; then
    echo "[INFO] Running in Docker mode..."
    # Docker-specific checks go here
    checking_packages
    create_group_user
    checking_system
    echo
    echo "[OK] Environment check complete."
    echo
    echo "==================================================="
    echo "|  Welcome to openbmc builder docker container!!  |"
    echo "==================================================="
    echo

    # Switch user
    exec su -s /bin/bash $USER_NAME
else
    echo "[INFO] Running in host mode..."
    # Host environment checks go here
    checking_packages
    checking_system
    echo
    echo "[OK] Environment check complete."
    echo
fi

