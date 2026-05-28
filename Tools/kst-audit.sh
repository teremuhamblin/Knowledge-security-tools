#!/usr/bin/env bash
#
#  Knowledge Security Tools - Audit Express
#  Auteur : The MadDoG.tmdg 
#  Version : 1.0
#
#  Description :
#    Script d’audit rapide pour analyser un système,
#    détecter les mauvaises configurations,
#    générer un score de sécurité
#    et produire un rapport Markdown complet.
#

set -e

### ─────────────────────────────────────────────
###  CONFIGURATION
### ─────────────────────────────────────────────
REPORT="kst-report-$(date +%Y%m%d-%H%M).md"
SCORE=0
MAX_SCORE=0

### ─────────────────────────────────────────────
###  FONCTIONS UTILITAIRES
### ─────────────────────────────────────────────

banner() {
  echo -e "\n🔐 Knowledge Security Tools — Audit Express\n"
}

add_check() {
  local description="$1"
  local command="$2"
  local weight="$3"

  MAX_SCORE=$((MAX_SCORE + weight))

  echo -n "• $description ... "

  if eval "$command" &>/dev/null; then
    echo "OK"
    SCORE=$((SCORE + weight))
    echo "- [x] $description" >> "$REPORT"
  else
    echo "❌"
    echo "- [ ] $description" >> "$REPORT"
  fi
}

### ─────────────────────────────────────────────
###  TESTS DE SÉCURITÉ
### ─────────────────────────────────────────────

run_checks() {
  echo "## 🔍 Audit de sécurité" >> "$REPORT"
  echo "" >> "$REPORT"

  add_check "Firewall actif" "systemctl is-active ufw" 10
  add_check "SSH root désactivé" "grep -q '^PermitRootLogin no' /etc/ssh/sshd_config" 10
  add_check "Mises à jour disponibles" "! apt list --upgradable 2>/dev/null | grep -q upgradable" 5
  add_check "Mot de passe fort pour l’utilisateur" "grep -q 'minlen = 12' /etc/security/pwquality.conf" 5
  add_check "Ports critiques fermés (23, 3389)" "! ss -tuln | grep -E ':23|:3389'" 10
}

### ─────────────────────────────────────────────
###  GÉNÉRATION DU RAPPORT
### ─────────────────────────────────────────────

generate_report() {
  echo "" >> "$REPORT"
  echo "## 🧮 Score de sécurité" >> "$REPORT"
  PERCENT=$((100 * SCORE / MAX_SCORE))
  echo "- Score : **$SCORE / $MAX_SCORE**" >> "$REPORT"
  echo "- Niveau : **$PERCENT%**" >> "$REPORT"

  echo "" >> "$REPORT"
  echo "## 📄 Informations système" >> "$REPORT"
  uname -a >> "$REPORT"
}

### ─────────────────────────────────────────────
###  MAIN
### ─────────────────────────────────────────────

banner
echo "# Rapport d’audit — Knowledge Security Tools" > "$REPORT"
echo "" >> "$REPORT"

run_checks
generate_report

echo -e "\n📁 Rapport généré : $REPORT"
echo "✔ Audit terminé"
