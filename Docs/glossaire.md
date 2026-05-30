# 🔐 Glossaire — Knowledge Security Tools
Ce glossaire regroupe les termes essentiels utilisés dans le domaine de la cybersécurité, de l’OSINT, du forensic, de l’ingénierie système et de la threat intelligence.  
Il sert de référence interne pour les utilisateurs et contributeurs du projet **Knowledge Security Tools**.

---

# 🧩 1. Concepts fondamentaux

## **Cybersécurité**
Ensemble des pratiques, technologies et processus visant à protéger les systèmes, réseaux et données contre les cybermenaces.

## **Vulnérabilité**
Faiblesse dans un système permettant à un attaquant d’exécuter une action non autorisée.

## **Exploit**
Code ou technique permettant d’exploiter une vulnérabilité.

## **Surface d’attaque**
Ensemble des points d’entrée exploitables par un attaquant.

## **Menace**
Événement ou acteur pouvant causer un dommage à un système.

## **Risque**
Probabilité qu’une menace exploite une vulnérabilité, multipliée par l’impact potentiel.

---

# 🕵️ 2. OSINT (Open Source Intelligence)

## **OSINT**
Collecte et analyse d’informations accessibles publiquement.

## **Footprinting**
Collecte d’informations préliminaires sur une cible.

## **Fingerprinting**
Identification précise des technologies, versions et services utilisés.

## **Whois**
Protocole permettant d’obtenir des informations sur un nom de domaine.

## **DNS Enumeration**
Techniques visant à cartographier les enregistrements DNS d’une cible.

## **Shodan**
Moteur de recherche d’appareils connectés exposés sur Internet.

## **Metadata**
Données cachées dans des fichiers (EXIF, PDF, DOCX, etc.).

---

# 🛡️ 3. Blue Team / Défense

## **SIEM (Security Information and Event Management)**
Plateforme centralisant logs, alertes et corrélations d’événements.

## **EDR (Endpoint Detection & Response)**
Solution de détection avancée sur postes et serveurs.

## **SOC (Security Operations Center)**
Centre opérationnel chargé de la surveillance et de la réponse aux incidents.

## **Incident Response (IR)**
Processus de gestion d’un incident de sécurité.

## **Threat Hunting**
Recherche proactive de menaces non détectées automatiquement.

## **Hardening**
Renforcement de la sécurité d’un système.

---

# ⚔️ 4. Red Team / Offensive

## **Reconnaissance**
Phase initiale de collecte d’informations.

## **Exploitation**
Utilisation d’une vulnérabilité pour obtenir un accès.

## **Post-Exploitation**
Actions réalisées après compromission (mouvements latéraux, persistance).

## **Privilege Escalation**
Obtention de privilèges supérieurs à ceux initialement acquis.

## **Pivoting**
Utilisation d’une machine compromise pour atteindre d’autres systèmes.

## **C2 (Command & Control)**
Canal de communication entre un attaquant et une machine compromise.

---

# 🧬 5. Forensic & Analyse

## **Forensic**
Analyse technique visant à comprendre un incident ou une compromission.

## **Hash**
Empreinte cryptographique d’un fichier (SHA256, MD5…).

## **Timeline Analysis**
Reconstruction chronologique d’événements.

## **Memory Dump**
Extraction du contenu de la mémoire vive.

## **Artifact**
Trace laissée par un système ou un utilisateur.

## **Chain of Custody**
Traçabilité des preuves numériques.

---

# 🌐 6. Réseau & Protocoles

## **IP (Internet Protocol)**
Adresse identifiant un hôte sur un réseau.

## **TCP/UDP**
Protocoles de transport (fiable vs non fiable).

## **Port Scanning**
Analyse des ports ouverts sur une machine.

## **Firewall**
Système filtrant le trafic réseau.

## **Proxy**
Serveur intermédiaire entre un client et une ressource.

## **VPN**
Tunnel chiffré permettant de sécuriser les communications.

---

# 🔑 7. Cryptographie

## **Chiffrement**
Transformation de données pour les rendre illisibles sans clé.

## **Clé publique / privée**
Paire cryptographique utilisée pour le chiffrement asymétrique.

## **HMAC**
Code d’authentification basé sur un hash et une clé.

## **TLS**
Protocole de sécurisation des communications.

## **Entropy**
Mesure du caractère aléatoire d’une donnée.

---

# 🧠 8. Threat Intelligence

## **IOC (Indicator of Compromise)**
Indicateur permettant d’identifier une compromission.

## **IOA (Indicator of Attack)**
Indicateur d’une attaque en cours.

## **TTP (Tactics, Techniques & Procedures)**
Méthodes utilisées par un groupe d’attaquants.

## **MITRE ATT&CK**
Framework répertoriant les techniques d’attaque.

## **Kill Chain**
Modèle décrivant les étapes d’une attaque.

---

# 🏛️ 9. Conformité & Gouvernance

## **RGPD**
Règlement général sur la protection des données.

## **ISO 27001**
Norme de gestion de la sécurité de l’information.

## **Audit**
Évaluation de la conformité ou de la sécurité d’un système.

## **Politique de sécurité**
Document définissant les règles de sécurité d’une organisation.

---

# 🧰 10. Outils & Technologies

## **EDR**
Détection avancée sur endpoints.

## **Sandbox**
Environnement isolé pour analyser des fichiers suspects.

## **Reverse Engineering**
Analyse d’un binaire pour comprendre son fonctionnement.

## **Container**
Environnement isolé (Docker, Podman).

## **CI/CD**
Automatisation du développement et du déploiement.

---

# 🧩 11. Termes spécifiques au projet Knowledge Security Tools

## **KST**
Acronyme du projet Knowledge Security Tools.

## **Arsenal**
Ensemble des outils Python spécialisés.

## **Perso**
Scripts OSINT/forensic personnalisés.

## **System**
Scripts d’ingénierie système.

## **Tools**
Scripts internes, templates et générateurs.

---

# 📌 Conclusion

Ce glossaire est conçu pour évoluer avec le projet.  
Toute contribution est bienvenue via une Pull Request ou une RFC.
