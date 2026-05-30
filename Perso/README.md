###### README.md >> markdown 
# 🧰 Scripts Perso
- Knowledge Security Tools
```md
- Ce dossier regroupe trois scripts spécialisés permettant :
   - d’installer, configurer et provisionner des environnements complets dédiés à l’OSINT,
   - à la Forensic et aux outils complémentaires.  
   - Ils sont conçus pour fonctionner sur les distributions Linux basées sur APT, Pacman et DNF.
```

---

### 📁 Scripts inclus
#### 1. 🕵️ labs.sh
> Installation des environnements OSINT
Ce script installe automatiquement un ensemble d’outils OSINT essentiels, ainsi que plusieurs labs d’entraînement :
```text
- DVWA  
- Juice Shop  
- WebGoat  
- PwnedHub  
- Photon  
- Sherlock  
- SpiderFoot  
- TheHarvester  
- Recon-ng  
- Holehe  
- Sublist3r  
- GHunt  
```
- Il détecte automatiquement l’OS, installe les dépendances nécessaires et configure Docker si requis.

---

### 2. 🧪 forensics.sh
>Environnement Forensic & Blue Team
Ce script provisionne un environnement complet d’analyse forensic :
```text
- Autopsy  
- Sleuthkit  
- Volatility / Volatility3  
- Binwalk  
- Strings / Radare2  
- Outils de carving et d’analyse mémoire  
- Outils de Threat Intelligence (TruffleHog, YARA, Sigma, etc.)
```
- Il inclut également des modules d’analyse avancée et des dépendances spécifiques (Python, Go, libs forensic).

---

### 3. 🛠️ extras.sh
>Outils complémentaires & utilitaires
Ce script installe des outils supplémentaires utiles pour l’ingénierie système, la sécurité et l’automatisation :
```text
- jq, fzf, ripgrep  
- outils réseau (nmap, netcat, dnsutils, whois)  
- outils de compilation (gcc, make, cmake, pkg-config)  
- outils Python (pip, venv, rich, colorama, requests)  
- outils divers (curl, wget, unzip, git)
```
- Il sert de base commune aux deux autres scripts.

---

### 🚀 Exécution manuelle
```bash
sudo bash labs.sh
sudo bash forensics.sh
sudo bash extras.sh
```

---

### ⚙️ Installation automatique
- Recommandée
Utilisez le script `install.sh` situé à la racine du projet pour installer les trois scripts automatiquement dans /usr/local/bin/.
```bash
sudo bash install.sh
```

Vous pourrez ensuite exécuter les scripts directement :

```bash
labs
forensics
extras
```

---

### 📌 Notes
- Tous les scripts sont compatibles Debian/Ubuntu/Kali/Parrot/Mint, Arch, Fedora, RHEL.  
- Les logs sont générés automatiquement dans ~/kst-install.log.  
- Les scripts sont conçus pour être modulaires, robustes et maintenables.

---
