#!/usr/bin/env bash
#
# system-setup.sh
# Provision d’un environnement complet d’ingénierie système
# - Installation logiciels
# - Dépendances
# - Utilitaires
# - Plugins / wrappers d’exécution de scripts (bash, C, Python, etc.)
#
# Usage :
#   ./system-setup.sh [options]
#
# Options principales :
#   -a, --all              Tout installer (full stack)
#   -s, --software         Installer logiciels d’ingénierie système
#   -d, --deps             Installer dépendances (build, libs, headers)
#   -u, --utils            Installer utilitaires avancés
#   -p, --plugins          Installer plugins / wrappers d’exécution de scripts
#   -c, --check            Afficher l’état (ce qui est installé / manquant)
#   -y, --yes              Ne pas poser de questions (mode non interactif)
#   -l, --log FILE         Loguer la sortie dans FILE
#   -h, --help             Afficher l’aide
#
# Exemples :
#   ./system-setup.sh -a -y
#   ./system-setup.sh --software --utils
#   ./system-setup.sh --plugins
#

set -euo pipefail

#######################################
# Variables globales
#######################################

LOG_FILE=""
ASSUME_YES="false"

PKG_MGR=""
PKG_UPDATE_CMD=""
PKG_INSTALL_CMD=""

#######################################
# Helpers d’affichage
#######################################

color() {
  local code="$1"; shift
  echo -e "\e[${code}m$*\e[0m"
}

info()  { color "34" "[INFO] $*"; }
ok()    { color "32" "[ OK ] $*"; }
warn()  { color "33" "[WARN] $*"; }
err()   { color "31" "[ERR ] $*" >&2; }

confirm() {
  local msg="$1"
  if [[ "$ASSUME_YES" == "true" ]]; then
    return 0
  fi
  read -rp "$msg [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

log_wrap() {
  if [[ -n "$LOG_FILE" ]]; then
    "$@" 2>&1 | tee -a "$LOG_FILE"
  else
    "$@"
  fi
}

#######################################
# Détection du gestionnaire de paquets
#######################################

detect_pkg_mgr() {
  if command -v apt-get >/dev/null 2>&1; then
    PKG_MGR="apt"
    PKG_UPDATE_CMD="sudo apt-get update"
    PKG_INSTALL_CMD="sudo apt-get install -y"
  elif command -v dnf >/dev/null 2>&1; then
    PKG_MGR="dnf"
    PKG_UPDATE_CMD="sudo dnf makecache"
    PKG_INSTALL_CMD="sudo dnf install -y"
  elif command -v yum >/dev/null 2>&1; then
    PKG_MGR="yum"
    PKG_UPDATE_CMD="sudo yum makecache"
    PKG_INSTALL_CMD="sudo yum install -y"
  elif command -v pacman >/dev/null 2>&1; then
    PKG_MGR="pacman"
    PKG_UPDATE_CMD="sudo pacman -Sy"
    PKG_INSTALL_CMD="sudo pacman -S --noconfirm"
  else
    err "Aucun gestionnaire de paquets supporté détecté (apt, dnf, yum, pacman)."
    exit 1
  fi
  info "Gestionnaire de paquets détecté : $PKG_MGR"
}

pkg_update() {
  info "Mise à jour des index de paquets..."
  log_wrap bash -c "$PKG_UPDATE_CMD"
  ok "Index de paquets mis à jour."
}

pkg_install() {
  local pkgs=("$@")
  info "Installation des paquets : ${pkgs[*]}"
  log_wrap bash -c "$PKG_INSTALL_CMD ${pkgs[*]}"
  ok "Installation terminée : ${pkgs[*]}"
}

#######################################
# 1. Logiciels d’ingénierie système
#######################################

install_software() {
  info "Installation des logiciels d’ingénierie système..."

  local base_tools=(
    git
    make
    cmake
    gcc
    g++
    clang
    gdb
    valgrind
  )

  local sys_eng_tools=(
    strace
    ltrace
    perf
    sysstat
    tcpdump
    nmap
    wireshark
    lsof
    net-tools
  )

  local containers=(
    docker.io
    docker-compose
  )

  pkg_install "${base_tools[@]}" || true
  pkg_install "${sys_eng_tools[@]}" || true
  pkg_install "${containers[@]}" || true

  ok "Logiciels d’ingénierie système installés."
}

#######################################
# 2. Dépendances complètes
#######################################

install_deps() {
  info "Installation des dépendances (build & libs)..."

  local build_deps=(
    build-essential
    pkg-config
    autoconf
    automake
    libtool
  )

  local dev_libs=(
    libssl-dev
    zlib1g-dev
    libffi-dev
    libreadline-dev
    libncurses5-dev
    libncursesw5-dev
  )

  pkg_install "${build_deps[@]}" || true
  pkg_install "${dev_libs[@]}" || true

  ok "Dépendances d’ingénierie système installées."
}

#######################################
# 3. Utilitaires complets
#######################################

install_utils() {
  info "Installation des utilitaires avancés..."

  local utils=(
    htop
    tmux
    tree
    ripgrep
    fd-find
    jq
    curl
    wget
    unzip
    zip
    bat
  )

  pkg_install "${utils[@]}" || true

  ok "Utilitaires installés."
}

#######################################
# 4. Plugins / wrappers d’exécution de scripts
#######################################

install_plugins() {
  info "Installation des plugins / environnements pour scripts..."

  # Python
  local python_pkgs=(
    python3
    python3-pip
    python3-venv
  )
  pkg_install "${python_pkgs[@]}" || true

  # Outils d’exécution / watchers
  local script_tools=(
    entr
  )
  pkg_install "${script_tools[@]}" || true

  # Création d’un répertoire de scripts et d’un wrapper
  local bin_dir="$HOME/.local/bin"
  mkdir -p "$bin_dir"

  cat > "$bin_dir/run-any" << 'EOF'
#!/usr/bin/env bash
# run-any : wrapper pour exécuter différents types de scripts
# Usage :
#   run-any fichier.ext [args...]

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: run-any <script> [args...]" >&2
  exit 1
fi

script="$1"; shift || true

if [[ ! -f "$script" ]]; then
  echo "Fichier introuvable : $script" >&2
  exit 1
fi

case "$script" in
  *.sh)
    bash "$script" "$@"
    ;;
  *.py)
    python3 "$script" "$@"
    ;;
  *.c)
    tmp_bin="/tmp/$(basename "$script" .c)-$$"
    gcc "$script" -o "$tmp_bin"
    "$tmp_bin" "$@"
    rm -f "$tmp_bin"
    ;;
  *.cpp)
    tmp_bin="/tmp/$(basename "$script" .cpp)-$$"
    g++ "$script" -o "$tmp_bin"
    "$tmp_bin" "$@"
    rm -f "$tmp_bin"
    ;;
  *.go)
    go run "$script" "$@"
    ;;
  *)
    echo "Type de fichier non géré : $script" >&2
    exit 1
    ;;
esac
EOF

  chmod +x "$bin_dir/run-any"

  # Ajout au PATH si nécessaire
  if ! grep -q "$bin_dir" <<< "$PATH"; then
    warn "Le répertoire $bin_dir n’est pas dans le PATH."
    echo "export PATH=\"$bin_dir:\$PATH\"" >> "$HOME/.bashrc"
    ok "Ligne ajoutée à ~/.bashrc : export PATH=\"$bin_dir:\$PATH\""
  fi

  ok "Plugins / wrappers d’exécution installés (run-any)."
}

#######################################
# 5. Check / état
#######################################

check_status() {
  info "Vérification rapide de l’environnement :"

  for cmd in git gcc g++ clang gdb valgrind python3 docker tmux htop run-any; do
    if command -v "$cmd" >/dev/null 2>&1; then
      ok "$cmd : présent"
    else
      warn "$cmd : manquant"
    fi
  done
}

#######################################
# Aide
#######################################

usage() {
  cat <<EOF
Usage: $0 [options]

Options :
  -a, --all              Tout installer (logiciels, deps, utils, plugins)
  -s, --software         Installer logiciels d’ingénierie système
  -d, --deps             Installer dépendances complètes
  -u, --utils            Installer utilitaires
  -p, --plugins          Installer plugins / wrappers d’exécution
  -c, --check            Vérifier l’état de l’environnement
  -y, --yes              Ne pas poser de questions (mode non interactif)
  -l, --log FILE         Loguer la sortie dans FILE
  -h, --help             Afficher cette aide

Exemples :
  $0 -a -y
  $0 --software --utils
  $0 --plugins
EOF
}

#######################################
# Parsing des options
#######################################

DO_SOFTWARE="false"
DO_DEPS="false"
DO_UTILS="false"
DO_PLUGINS="false"
DO_CHECK="false"
DO_ALL="false"

ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--all)      DO_ALL="true"; shift ;;
    -s|--software) DO_SOFTWARE="true"; shift ;;
    -d|--deps)     DO_DEPS="true"; shift ;;
    -u|--utils)    DO_UTILS="true"; shift ;;
    -p|--plugins)  DO_PLUGINS="true"; shift ;;
    -c|--check)    DO_CHECK="true"; shift ;;
    -y|--yes)      ASSUME_YES="true"; shift ;;
    -l|--log)      LOG_FILE="$2"; shift 2 ;;
    -h|--help)     usage; exit 0 ;;
    --)            shift; break ;;
    *)             ARGS+=("$1"); shift ;;
  esac
done

if [[ "$DO_ALL" == "true" ]]; then
  DO_SOFTWARE="true"
  DO_DEPS="true"
  DO_UTILS="true"
  DO_PLUGINS="true"
fi

if [[ "$DO_SOFTWARE" == "false" && "$DO_DEPS" == "false" && \
      "$DO_UTILS" == "false" && "$DO_PLUGINS" == "false" && \
      "$DO_CHECK" == "false" ]]; then
  usage
  exit 1
fi

#######################################
# Main
#######################################

detect_pkg_mgr
pkg_update

if [[ "$DO_SOFTWARE" == "true" ]]; then
  confirm "Installer les logiciels d’ingénierie système ?" && install_software || info "Skip logiciels."
fi

if [[ "$DO_DEPS" == "true" ]]; then
  confirm "Installer les dépendances complètes ?" && install_deps || info "Skip dépendances."
fi

if [[ "$DO_UTILS" == "true" ]]; then
  confirm "Installer les utilitaires ?" && install_utils || info "Skip utilitaires."
fi

if [[ "$DO_PLUGINS" == "true" ]]; then
  confirm "Installer les plugins / wrappers d’exécution ?" && install_plugins || info "Skip plugins."
fi

if [[ "$DO_CHECK" == "true" ]]; then
  check_status
fi

ok "Provision d’environnement d’ingénierie système terminée."
