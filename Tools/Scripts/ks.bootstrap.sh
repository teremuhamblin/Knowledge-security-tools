#!/usr/bin/env bash
# file: ks_bootstrap.sh
# Usage: sudo bash ks_bootstrap.sh
# Script Bash pour mise à jour + installation des outils
# Ce script :
# - met à jour les dépôts,
# - installe les outils de base pour ton projet knowledge-security-tools,
# - prépare un venv Python optionnel.

set -euo pipefail

PROJECT_NAME="knowledge-security-tools"
PROJECT_DIR="$HOME/$PROJECT_NAME"

echo "=== $PROJECT_NAME : Bootstrap environnement (Debian/Ubuntu) ==="

echo ">> Mise a jour des depots..."
apt update -y

echo ">> Mise a niveau des paquets..."
apt upgrade -y

echo ">> Installation des outils de base..."
apt install -y \
  build-essential \
  git \
  python3 \
  python3-pip \
  python3-venv \
  nmap \
  lynis \
  curl \
  wget \
  cmake \
  pkg-config \
  libssl-dev

echo ">> Creation du dossier projet : $PROJECT_DIR"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo ">> Initialisation Git (si non present)..."
if [ ! -d ".git" ]; then
  git init
fi

echo ">> Creation d'un environnement virtuel Python..."
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi

echo ">> Activation de l'environnement virtuel et installation de dependances Python..."
# Exemple de dependances, a adapter a ton projet
source venv/bin/activate
pip install --upgrade pip
pip install \
  requests \
  psutil \
  rich

deactivate

echo ">> Resume :"
echo "  - Projet : $PROJECT_NAME"
echo "  - Dossier : $PROJECT_DIR"
echo "  - Outils systeme installes : build-essential, git, python3, nmap, lynis, etc."
echo "  - Environnement Python : $PROJECT_DIR/venv"

echo "=== Bootstrap termine. Tu peux commencer a coder tes outils de securite. ==="
