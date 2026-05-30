#!/bin/bash
# Permission Checker — Educational
# Démonstration : détection de fichiers avec permissions faibles.

echo "=== Permission Checker ==="
find / -type f -perm -o+w 2>/dev/null | head -n 20
