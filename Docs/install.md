###### install.md >> markdown 
# 🟩 🛠️ install.sh
- Installeur Automatique (All‑in‑One)

Le script install.sh est un installeur complet permettant de déployer automatiquement les trois modules principaux du projet :
```text
- labs.sh — Environnements OSINT & labs vulnérables  
- forensics.sh — Suite forensic & outils Blue Team  
- extras.sh — Outils complémentaires & utilitaires système
```

### 🔧 Fonctionnalités principales
```text
- Détection automatique de l’OS (APT, Pacman, DNF)
- Mise à jour complète du système
- Ajout de dépôts supplémentaires (Universe, Multiverse, EPEL…)
- Installation des dépendances essentielles (Python, Docker, build tools…)
- Installation des plugins Python nécessaires
- Interface TUI (fzf) permettant de choisir les scripts à installer
- Copie automatique des scripts depuis Perso/ vers /usr/local/bin/
- Attribution des permissions d’exécution
- Génération d’un log détaillé : ~/kst-install.log
```

### 🚀 Utilisation
```bash
sudo bash install.sh
```

Une interface interactive vous permettra de sélectionner :
- labs.sh
- forensics.sh
- extras.sh
- ou ALL pour tout installer.

>Une fois installés, les scripts deviennent accessibles globalement :

```bash
labs
forensics
extras
```

### 📍 Emplacement des scripts installés
```text
/usr/local/bin/
```

### 📄 Log d’installation
```text
~/kst-install.log
```

---

>Ce script constitue la méthode la plus simple, rapide et fiable pour installer l’ensemble des outils du projet Knowledge Security Tools.

---
