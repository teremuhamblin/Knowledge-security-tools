#!/usr/bin/env bash
# ===================================================================
# 🔧 install.sh – Provision OSINT / Forensic / Extras
# Projet : Knowledge Security Tools
# Auteur : The MadDoG.tmdg 
# ===================================================================

set -euo pipefail

# ----------------------------- COLORS --------------------------------
RED="\033[0;31m"; GRN="\033[0;32m"; YLW="\033[1;33m"
BLU="\033[0;34m"; CYN="\033[0;36m"; NC="\033[0m"

LOGFILE="$HOME/kst-install.log"
touch "$LOGFILE"

# ----------------------------- LOGGING --------------------------------
log()   { echo -e "${CYN}[INFO]${NC} $*" | tee -a "$LOGFILE"; }
ok()    { echo -e "${GRN}[OK]${NC} $*"  | tee -a "$LOGFILE"; }
warn()  { echo -e "${YLW}[WARN]${NC} $*"| tee -a "$LOGFILE"; }
err()   { echo -e "${RED}[ERR]${NC} $*" | tee -a "$LOGFILE"; }

# ----------------------------- ROOT CHECK ------------------------------
if [[ $EUID -ne 0 ]]; then
  err "Ce script doit être exécuté en root."
  exit 1
fi

# ----------------------------- OS DETECTION ----------------------------
detect_os() {
  if [[ -f /etc/debian_version ]]; then PKG="apt"
  elif [[ -f /etc/arch-release ]]; then PKG="pacman"
  elif [[ -f /etc/fedora-release ]]; then PKG="dnf"
  else err "OS non supporté."; exit 1
  fi
  ok "OS détecté : $PKG"
}

# ----------------------------- UPDATE SYSTEM ---------------------------
update_system() {
  log "Mise à jour complète du système…"
  case "$PKG" in
    apt)
      apt update -y
      apt full-upgrade -y
      apt autoremove -y
      apt autoclean -y
      ;;
    pacman)
      pacman -Syu --noconfirm
      ;;
    dnf)
      dnf upgrade -y
      ;;
  esac
  ok "Système mis à jour."
}

# ----------------------------- EXTRA REPOS -----------------------------
add_repos() {
  log "Ajout des dépôts supplémentaires…"

  case "$PKG" in
    apt)
      apt install -y software-properties-common gnupg2
      add-apt-repository universe || true
      add-apt-repository multiverse || true
      add-apt-repository restricted || true
      ;;
    pacman)
      sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
      ;;
    dnf)
      dnf install -y epel-release
      ;;
  esac

  ok "Dépôts supplémentaires ajoutés."
}

# ----------------------------- DEPENDENCIES ----------------------------
install_dependencies() {
  log "Installation des dépendances…"

  case "$PKG" in
    apt)
      apt install -y \
        git curl wget python3 python3-pip python3-venv \
        build-essential cmake pkg-config \
        jq fzf unzip net-tools dnsutils \
        docker.io docker-compose
      ;;
    pacman)
      pacman -Sy --noconfirm \
        git curl wget python python-pip \
        base-devel cmake pkgconf \
        jq fzf unzip bind docker docker-compose
      ;;
    dnf)
      dnf install -y \
        git curl wget python3 python3-pip \
        gcc gcc-c++ make cmake pkgconf \
        jq fzf unzip bind-utils docker docker-compose
      ;;
  esac

  systemctl enable --now docker || true

  ok "Dépendances installées."
}

# ----------------------------- PLUGINS --------------------------------
install_plugins() {
  log "Installation des plugins nécessaires…"

  pip3 install --upgrade pip setuptools wheel
  pip3 install rich colorama requests

  ok "Plugins Python installés."
}

# ----------------------------- TUI (fzf) -------------------------------
select_scripts() {
  log "Sélection des scripts à installer…"

  if ! command -v fzf >/dev/null; then
    install_dependencies
  fi

  CHOICES=$(printf "labs.sh\nforensics.sh\nextras.sh\nALL\n" | fzf -m --prompt="Choisis les modules à installer : ")

  if [[ -z "$CHOICES" ]]; then
    warn "Aucun module sélectionné."
    exit 0
  fi

  SELECTED=()
  for s in $CHOICES; do
    SELECTED+=("$s")
  done
}

# ----------------------------- INSTALL SCRIPTS -------------------------
install_scripts() {
  log "Installation des scripts sélectionnés…"

  SRC_DIR="$HOME/Knowledge-security-tools/Perso"

  if [[ ! -d "$SRC_DIR" ]]; then
    err "Le dossier $SRC_DIR n'existe pas."
    exit 1
  fi

  for script in "${SELECTED[@]}"; do
    case "$script" in
      labs.sh)
        cp "$SRC_DIR/labs.sh" /usr/local/bin/labs
        chmod +x /usr/local/bin/labs
        ok "labs.sh installé."
        ;;
      forensics.sh)
        cp "$SRC_DIR/forensics.sh" /usr/local/bin/forensics
        chmod +x /usr/local/bin/forensics
        ok "forensics.sh installé."
        ;;
      extras.sh)
        cp "$SRC_DIR/extras.sh" /usr/local/bin/extras
        chmod +x /usr/local/bin/extras
        ok "extras.sh installé."
        ;;
      ALL)
        cp "$SRC_DIR/labs.sh" /usr/local/bin/labs
        cp "$SRC_DIR/forensics.sh" /usr/local/bin/forensics
        cp "$SRC_DIR/extras.sh" /usr/local/bin/extras
        chmod +x /usr/local/bin/{labs,forensics,extras}
        ok "Tous les scripts installés."
        ;;
    esac
  done
}

# ----------------------------- SUMMARY ---------------------------------
summary() {
  echo -e "\n${GRN}=== Installation terminée ===${NC}"
  echo "Log complet : $LOGFILE"
  echo "Scripts installés dans : /usr/local/bin/"
}

# ----------------------------- MAIN ------------------------------------
detect_os
update_system
add_repos
install_dependencies
install_plugins
select_scripts
install_scripts
summary
