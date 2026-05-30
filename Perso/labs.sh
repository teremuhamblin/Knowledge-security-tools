#!/usr/bin/env bash
# ===================================================================
# 🧠 Knowledge Security Tools – Labs Installer v3.5 (TUI Edition)
# Author: The MadDoG.tmdg
# ===================================================================
set -euo pipefail

# 🎨 Colors
RED="\033[0;31m"; GRN="\033[0;32m"; YLW="\033[1;33m"; BLU="\033[0;34m"; CYN="\033[0;36m"; NC="\033[0m"

# 📁 Logs
LOGFILE="${LOGFILE:-$HOME/kst-labs-install.log}"
mkdir -p "$(dirname "$LOGFILE")"

# 📊 Counters
INSTALLED=0; SKIPPED=0; FAILED=0
declare -ga FAILED_TOOLS=()

# 🧩 Utility functions
say()   { echo -e "${BLU}[*]${NC} $*"; }
ok()    { echo -e "${GRN}[✓]${NC} $*"; INSTALLED=$((INSTALLED+1)); }
skip()  { echo -e "${YLW}[~]${NC} $*"; SKIPPED=$((SKIPPED+1)); }
fail()  { echo -e "${RED}[✗]${NC} $*"; FAILED=$((FAILED+1)); FAILED_TOOLS+=("$1"); echo "$(date '+%F %T') FAIL: $*" >>"$LOGFILE"; }

require_root() { [[ $EUID -eq 0 ]] || { echo "Run as root: sudo bash $0"; exit 1; }; }
check_network() { ping -c1 1.1.1.1 >/dev/null 2>&1 || { fail "No network connectivity"; exit 1; }; }

detect_distro() {
  [[ -f /etc/os-release ]] && . /etc/os-release || ID="unknown"
  case "${ID,,}" in
    kali|debian|ubuntu|parrot|linuxmint|pop|elementary) PKG="apt" ;;
    arch|manjaro|endeavouros|garuda|artix) PKG="pacman" ;;
    fedora|rhel|centos|rocky|almalinux|ol) PKG="dnf" ;;
    *) PKG="unknown" ;;
  esac
  echo -e "${CYN}[i]${NC} Detected: $PKG"
}

pkg_install() {
  local pkg="$1"
  case "$PKG" in
    apt) dpkg -s "$pkg" &>/dev/null && skip "$pkg" || apt install -y "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg" ;;
    pacman) pacman -Qi "$pkg" &>/dev/null && skip "$pkg" || pacman -S --noconfirm --needed "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg" ;;
    dnf) rpm -q "$pkg" &>/dev/null && skip "$pkg" || dnf install -y "$pkg" &>/dev/null && ok "$pkg" || fail "$pkg" ;;
    *) fail "$pkg (unknown pkg manager)" ;;
  esac
}

install_git() {
  local repo="$1" dst="$2"
  mkdir -p /opt/kst-labs
  [[ -d "/opt/kst-labs/$dst" ]] && skip "$dst" && return
  git clone --depth=1 "$repo" "/opt/kst-labs/$dst" &>/dev/null && ok "$dst (git)" || fail "$dst (git)"
}

install_docker() {
  local image="$1" name="$2"
  command -v docker &>/dev/null || { fail "$name (docker missing)"; return; }
  docker image inspect "$image" &>/dev/null && skip "$name" && return
  docker pull "$image" &>/dev/null && ok "$name (docker)" || fail "$name (docker)"
}

bootstrap_basics() {
  say "Installing base dependencies..."
  case "$PKG" in
    apt) apt update -y &>/dev/null; apt install -y python3 python3-pip git curl wget golang-go docker.io fzf &>/dev/null ;;
    pacman) pacman -Sy --noconfirm &>/dev/null; pacman -S --noconfirm --needed python python-pip git curl wget go docker fzf &>/dev/null ;;
    dnf) dnf install -y python3 python3-pip git curl wget golang docker fzf &>/dev/null ;;
  esac
}

print_summary() {
  echo -e "\n============================================="
  echo -e "  Installed: ${GRN}$INSTALLED${NC}"
  echo -e "  Skipped:   ${YLW}$SKIPPED${NC}"
  echo -e "  Failed:    ${RED}$FAILED${NC}"
  echo -e "============================================="
  ((FAILED>0)) && echo -e "${RED}Failed tools:${NC} ${FAILED_TOOLS[*]}" && echo "See $LOGFILE"
}

# 🧠 Interactive TUI selection
select_labs() {
  say "Select labs to install (use TAB to select multiple, ENTER to confirm):"
  local choices labs
  choices=$(printf "DVWA\nOWASP Juice Shop\nOWASP WebGoat\nPwnedHub\nAll Labs")
  labs=$(echo "$choices" | fzf --multi --border --prompt="Labs > " --header="Select training labs to install" --height=15 --reverse)
  [[ -z "$labs" ]] && { echo "No selection made."; exit 0; }
  echo "$labs"
}

# 🚀 Main
require_root
check_network
detect_distro
bootstrap_basics

selected=$(select_labs)

say "Installing selected labs..."
for lab in $selected; do
  case "$lab" in
    "DVWA") install_git https://github.com/digininja/DVWA.git DVWA ;;
    "OWASP Juice Shop") install_docker bkimminich/juice-shop "OWASP Juice Shop" ;;
    "OWASP WebGoat") install_docker webgoat/webgoat "OWASP WebGoat" ;;
    "PwnedHub") install_git https://github.com/practisec/pwnedhub.git PwnedHub ;;
    "All Labs")
      install_git https://github.com/digininja/DVWA.git DVWA
      install_docker bkimminich/juice-shop "OWASP Juice Shop"
      install_docker webgoat/webgoat "OWASP WebGoat"
      install_git https://github.com/practisec/pwnedhub.git PwnedHub
      ;;
  esac
done

print_summary
