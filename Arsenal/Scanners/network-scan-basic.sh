#!/bin/bash
# Network Scan Basic — Knowledge Security Tools
# Scan réseau léger pour identifier les hôtes actifs et ports ouverts.

TARGET=${1:-"192.168.1.0/24"}

echo "=== Network Scan Basic ==="
echo "Cible : $TARGET"

nmap -sn "$TARGET"
