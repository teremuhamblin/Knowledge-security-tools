// . Script C d’analyse système + installation des dépendances
// Ce C va :
// - détecter quelques infos système,
// - vérifier la présence de binaires clés,
//- proposer d’installer les dépendances de base pour ton projet
// file: ks_syscheck.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int command_exists(const char *cmd) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "command -v %s > /dev/null 2>&1", cmd);
    return system(buffer) == 0;
}

void print_header(const char *title) {
    printf("\n==================== %s ====================\n", title);
}

void show_basic_system_info() {
    print_header("INFORMATIONS SYSTEME");
    printf("OS (uname -a):\n");
    system("uname -a");
    printf("\nDistribution (lsb_release -a ou /etc/os-release):\n");
    system("lsb_release -a 2>/dev/null || cat /etc/os-release 2>/dev/null");
    printf("\nCPU:\n");
    system("lscpu 2>/dev/null | head -n 15");
    printf("\nRAM:\n");
    system("free -h 2>/dev/null");
    printf("\nDisques:\n");
    system("df -h 2>/dev/null");
}

void check_tool(const char *name, const char *cmd) {
    printf(" - %-15s : %s\n", name, command_exists(cmd) ? "OK" : "ABSENT");
}

void check_security_stack() {
    print_header("VERIFICATION OUTILS / STACK");
    check_tool("gcc", "gcc");
    check_tool("makeTu touches un sujet que j’aime bien là—on va te poser une base propre pour ton projet `knowledge-security-tools`.

Je pars sur un environnement Linux type Debian/Ubuntu (APT). Tu pourras adapter si tu es sur autre chose.

---

### 1. Script C d’analyse système + préparation des dépendances

Ce script :
- détecte quelques infos système (OS, CPU, RAM),
- vérifie la présence de quelques outils clés,
- propose d’installer les dépendances via `apt`.

```c
// file: ks_sys_analyzer.c
// Compile: gcc ks_sys_analyzer.c -o ks_sys_analyzer
// Usage:   sudo ./ks_sys_analyzer

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int check_command(const char *cmd) {
    char buffer[256];
    snprintf(buffer, sizeof(buffer), "command -v %s >/dev/null 2>&1", cmd);
    int ret = system(buffer);
    return ret == 0;
}

void print_header(const char *title) {
    printf("\n==================== %s ====================\n", title);
}

void analyze_os() {
    print_header("SYSTEME");
    system("uname -a");
    printf("\n");
    printf("Contenu de /etc/os-release (si présent):\n");
    system("cat /etc/os-release 2>/dev/null | sed -n '1,6p'");
}

void analyze_cpu() {
    print_header("CPU");
    system("lscpu 2>/dev/null | sed -n '1,10p'");
}

void analyze_mem() {
    print_header("MEMOIRE");
    system("free -h 2>/dev/null");
}

void analyze_disk() {
    print_header("DISQUE");
    system("df -h 2>/dev/null | head -n 10");
}

void check_tools() {
    const char *tools[] = {
        "git", "gcc", "make", "python3", "pip3",
        "nmap", "lynis", "curl", "wget", "cmake"
    };
    int n = sizeof(tools) / sizeof(tools[0]);

    print_header("VERIFICATION DES OUTILS");

    for (int i = 0; i < n; i++) {
        printf("%-10s : %s\n", tools[i], check_command(tools[i]) ? "OK" : "ABSENT");
    }
}

void install_dependencies() {
    print_header("INSTALLATION DES DEPENDANCES (APT)");

    printf("Ce script va tenter d’installer les paquets nécessaires pour le projet knowledge-security-tools.\n");
    printf("Paquets cibles : build-essential, git, python3, python3-pip, nmap, lynis, curl, wget, cmake\n\n");

    char answer[8];
    printf("Voulez-vous continuer ? [y/N] : ");
    if (!fgets(answer, sizeof(answer), stdin)) {
        return;
    }

    if (answer[0] != 'y' && answer[0] != 'Y') {
        printf("Installation annulee.\n");
        return;
    }

    int ret = system("sudo apt update && "
                     "sudo apt install -y "
                     "build-essential git python3 python3-pip "
                     "nmap lynis curl wget cmake");
    if (ret != 0) {
        printf("Erreur lors de l’installation des dependances (code %d).\n", ret);
    } else {
        printf("Installation terminee.\n");
    }
}

int main(void) {
    printf("=== knowledge-security-tools : Analyse systeme & preparation ===\n");

    analyze_os();
    analyze_cpu();
    analyze_mem();
    analyze_disk();
    check_tools();

    printf("\n");
    install_dependencies();

    printf("\nTout est pret (ou presque) pour le projet knowledge-security-tools.\n");
    return 0;
}
