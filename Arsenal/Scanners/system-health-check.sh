#!/bin/bash
# System Health Check — Knowledge Security Tools
# Analyse rapide de l’état du système : CPU, RAM, stockage, services critiques.

echo "=== System Health Check ==="

echo "[CPU]"
top -bn1 | head -n 5

echo "[RAM]"
free -h

echo "[DISK]"
df -h /

echo "[SERVICES]"
systemctl --failed
