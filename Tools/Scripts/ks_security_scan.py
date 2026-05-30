# file: ks_security_scan.py
# Usage: python3 ks_security_scan.py
# Script Python de sécurité (scan basique & checks)
# Ce script :
# - liste les ports ouverts (via ss ou netstat),
# - vérifie quelques fichiers sensibles,
# - liste les paquets installés liés à la sécurité,
# - prépare un rapport simple.

import os
import subprocess
from datetime import datetime
from pathlib import Path

REPORT_PATH = Path("./ks_security_report.txt")


def run_cmd(cmd):
    try:
        result = subprocess.run(
            cmd, shell=True, check=False,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
        )
        return result.stdout.strip()
    except Exception as e:
        return f"Erreur lors de l'execution de '{cmd}': {e}"


def section(title):
    return f"\n==================== {title} ====================\n"


def scan_open_ports():
    # ss est plus moderne, fallback sur netstat
    if shutil.which("ss"):
        cmd = "sudo ss -tulnp"
    else:
        cmd = "sudo netstat -tulnp"
    return run_cmd(cmd)


def check_sensitive_files():
    files = [
        "/etc/passwd",
        "/etc/shadow",
        "/etc/sudoers",
        "/etc/ssh/sshd_config",
    ]
    out = []
    for f in files:
        p = Path(f)
        if p.exists():
            st = p.stat()
            out.append(f"{f} : existe, mode={oct(st.st_mode)}, owner={st.st_uid}:{st.st_gid}")
        else:
            out.append(f"{f} : n'existe pas")
    return "\n".join(out)


def list_security_packages():
    # Pour Debian/Ubuntu
    cmd = "dpkg -l | egrep 'nmap|lynx|lynis|fail2ban|ufw|iptables|clamav' || true"
    return run_cmd(cmd)


def main():
    import shutil

    print("=== knowledge-security-tools : Scan de securite basique ===")

    report = []
    report.append(f"Rapport genere le {datetime.now().isoformat()}")
    report.append(section("PORTS OUVERTS"))
    if shutil.which("ss") or shutil.which("netstat"):
        report.append(scan_open_ports())
    else:
        report.append("Ni ss ni netstat n'ont ete trouves sur ce systeme.")

    report.append(section("FICHIERS SENSIBLES"))
    report.append(check_sensitive_files())

    report.append(section("PAQUETS DE SECURITE (SELECTION)"))
    report.append(list_security_packages())

    REPORT_PATH.write_text("\n".join(report), encoding="utf-8")
    print(f"Rapport ecrit dans {REPORT_PATH.resolve()}")


if __name__ == "__main__":
    main()
