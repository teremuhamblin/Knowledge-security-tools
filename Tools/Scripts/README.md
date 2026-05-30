###### README.md >> markdown 
# ⚙️ Scripts
- Knowledge Security Tools

Ce dossier contient les scripts utilisés pour analyser, auditer ou automatiser des actions liées à la sécurité du système.

### 🎯 Objectif
>Fournir des outils exécutables simples et efficaces pour :
- collecter des informations,
- effectuer des vérifications,
- générer des rapports.

### 📌 Format
>Chaque script est autonome, documenté en en-tête et exécutable directement.Voici une description propre, claire et professionnelle des trois scripts (C, Python, Bash) pour ton README.md dans le dossier scripts/.  
Format court, efficace, technique — exactement comme tu l’aimes.

---

### 📁 Scripts/
>Description des outils
#### 🧩 1. kssyscheck.c
```md
>> Analyse système & préparation de l’environnement
   - Ce programme en C réalise une analyse complète du système afin de préparer l’environnement pour le projet knowledge-security-tools.  
   - Il collecte les informations essentielles (OS, CPU, RAM, stockage), vérifie la présence des outils critiques (compilateur, Python, Git, outils de sécurité) et propose
>> l’installation automatique des dépendances nécessaires via apt.
>> Fonctionnalités principales
   - Détection du système (kernel, distribution, architecture).  
   - Inspection CPU, mémoire et espace disque.  
   - Vérification de la présence des outils essentiels (gcc, make, git, python3, pip, nmap, lynis…).  
   - Installation guidée des dépendances du projet.  
   - Préparation de l’environnement de développement.
```

---

### 🛡️ 2. kssecurityscan.py
```md
>> Scanner de sécurité basique
- Ce script Python fournit un ensemble de vérifications de sécurité essentielles pour établir un premier diagnostic de l’état du système.  
- Il génère un rapport complet contenant les ports ouverts, l’état des fichiers sensibles et les paquets liés à la sécurité.

Fonctionnalités principales :
- Analyse des ports ouverts (ss ou netstat).  
- Vérification des fichiers critiques du système (/etc/passwd, /etc/shadow, /etc/sudoers, SSH…).  
- Détection de paquets de sécurité installés (nmap, fail2ban, ufw, clamav…).  
- Génération d’un rapport détaillé dans kssecurityreport.txt
```

---

### ⚙️ 3. ks_bootstrap.sh
```text
> - Mise à jour & installation des outils
   - Ce script Bash automatise la mise à jour du système et l’installation de tous les outils nécessaires au projet knowledge-security-tools.  
   - Il prépare également la structure du projet et crée un environnement Python isolé.
Fonctionnalités principales :
- Mise à jour complète du système (apt update && apt upgrade).  
- Installation des outils de développement et de sécurité (build-essential, python3, pip, git, nmap, lynis, cmake…).  
- Création du dossier du projet et initialisation Git.  
- Mise en place d’un environnement virtuel Python (venv).  
- Installation des dépendances Python de base.

---
