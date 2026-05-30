#!/usr/bin/env bash
# ===================================================================
# 🛡️ Knowledge Security Tools – Blue Team & Threat Intel Installer v4.0
# Author: The MadDoG.tmdg
# Optimized with TUI Edition (fzf)
# ===================================================================
set -euo pipefail

# 🎨 Colors
RED="\033[0;31m"; GRN="\033[0;32m"; YLW="\033[1;33m"; BLU="\033[0;34m"; CYN="\033[0;36m"; NC="\033[0m"

# 📁 Logs
LOGFILE="${LOGFILE:-$HOME/kst-blueteam-install.log}"
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

install_pip() {
  local pkg="$1"
  pip3 show "$pkg" &>/dev/null && skip "$pkg" && return
  pip3 install --break-system-packages "$pkg" &>/dev/null && ok "$pkg (pip)" || fail "$pkg (pip)"
}

install_go() {
  local mod="$1" name="$2"
  command -v go &>/dev/null || { fail "$name (go missing)"; return; }
  command -v "$name" &>/dev/null && skip "$name" && return
  go install "${mod}@latest" &>/dev/null && ok "$name (go)" || fail "$name (go)"
}

install_git() {
  local repo="$1" dst="$2"
  mkdir -p /opt/kst-blueteam
  [[ -d "/opt/kst-blueteam/$dst" ]] && skip "$dst" && return
  git clone --depth=1 "$repo" "/opt/kst-blueteam/$dst" &>/dev/null && ok "$dst (git)" || fail "$dst (git)"
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
  export PATH="$PATH:/root/go/bin:$HOME/go/bin"
}

print_summary() {
  echo -e "\n============================================="
  echo -e "  Installed: ${GRN}$INSTALLED${NC}"
  echo -e "  Skipped:   ${YLW}$SKIPPED${NC}"
  echo -e "  Failed:    ${RED}$FAILED${NC}"
  echo -e "============================================="
  ((FAILED>0)) && echo -e "${RED}Failed tools:${NC} ${FAILED_TOOLS[*]}" && echo "See $LOGFILE"
}

# ===================================================================
# 🧠 TUI Selection (fzf)
# ===================================================================
select_tools() {
  say "Select Blue Team / Threat Intel tools to install:"
  local choices tools

  choices=$(cat <<EOF
OpenCTI (Docker)
Yeti (Git)
Atomic Red Team (Git)
Chainsaw (Git)
Cortex (Docker)
Elastic Stack (Docker)
Falco (Git)
Graylog (Docker)
Hayabusa (Git)
Loki (Git)
Caldera (Git)
osquery (pkg)
RITA (Git)
Sigma (Git)
sigma-cli (pip)
Snort (pkg)
Suricata (pkg)
TheHive (Docker)
Tracee (Git)
Velociraptor (Git)
Wazuh (Git)
Zeek (pkg)
Linux for OSINT (Git)
Python for OSINT (Git)
EyeWitness (Git + internal setup)
OpenCV Headless (pip)
TruffleHog (Go)
ALL TOOLS
EOF
)

  tools=$(echo "$choices" | fzf --multi --border --prompt="Blue Team > " --header="Select tools to install" --height=25 --reverse)

  [[ -z "$tools" ]] && { echo "No selection made."; exit 0; }
  echo "$tools"
}

# ===================================================================
# 🚀 Main Execution
# ===================================================================
require_root
check_network
detect_distro
bootstrap_basics

selected=$(select_tools)

say "Installing selected tools..."
for tool in $selected; do
  case "$tool" in
    "OpenCTI (Docker)") install_docker opencti/platform OpenCTI ;;
    "Yeti (Git)") install_git https://github.com/yeti-platform/yeti.git yeti ;;
    "Atomic Red Team (Git)") install_git https://github.com/redcanaryco/atomic-red-team.git atomic-red-team ;;
    "Chainsaw (Git)") install_git https://github.com/WithSecureLabs/chainsaw.git chainsaw ;;
    "Cortex (Docker)") install_docker thehiveproject/cortex:latest Cortex ;;
    "Elastic Stack (Docker)") install_docker docker.elastic.co/elasticsearch/elasticsearch:latest ELK ;;
    "Falco (Git)") install_git https://github.com/falcosecurity/falco.git falco ;;
    "Graylog (Docker)") install_docker graylog/graylog:latest Graylog ;;
    "Hayabusa (Git)") install_git https://github.com/Yamato-Security/hayabusa.git hayabusa ;;
    "Loki (Git)") install_git https://github.com/Neo23x0/Loki.git Loki ;;
    "Caldera (Git)") install_git https://github.com/mitre/caldera.git caldera ;;
    "osquery (pkg)") pkg_install osquery ;;
    "RITA (Git)") install_git https://github.com/activecm/rita.git rita ;;
    "Sigma (Git)") install_git https://github.com/SigmaHQ/sigma.git sigma ;;
    "sigma-cli (pip)") install_pip sigma-cli ;;
    "Snort (pkg)") pkg_install snort ;;
    "Suricata (pkg)") pkg_install suricata ;;
    "TheHive (Docker)") install_docker strangebee/thehive:latest TheHive ;;
    "Tracee (Git)") install_git https://github.com/aquasecurity/tracee.git tracee ;;
    "Velociraptor (Git)") install_git https://github.com/Velocidex/velociraptor.git velociraptor ;;
    "Wazuh (Git)") install_git https://github.com/wazuh/wazuh.git wazuh ;;
    "Zeek (pkg)") pkg_install zeek ;;
    "Linux for OSINT (Git)") install_git https://github.com/cipher387/linux-for-OSINT-21-days.git linux-for-OSINT ;;
    "Python for OSINT (Git)") install_git https://github.com/cipher387/python-for-OSINT-21-days.git python-for-OSINT ;;
    "EyeWitness (Git + internal setup)")
      install_git https://github.com/RedSiege/EyeWitness.git EyeWitness
      bash /opt/kst-blueteam/EyeWitness/Python/setup/setup.sh -y &>/dev/null && ok "EyeWitness (compiled)" || fail "EyeWitness setup"
      ;;
    "OpenCV Headless (pip)") install_pip opencv-python-headless ;;
    "TruffleHog (Go)") install_go github.com/trufflesecurity/trufflehog/v3 trufflehog ;;
    "ALL TOOLS")
      say "Installing ALL tools..."
      # Re-run script with all entries
      exec bash "$0" --all
      ;;
  esac
done

print_summary
