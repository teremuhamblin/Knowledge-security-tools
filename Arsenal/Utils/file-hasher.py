#!/usr/bin/env python3
"""
File Hasher — Utils
Calcule les empreintes SHA256 des fichiers fournis.
"""

import hashlib
import sys

for file in sys.argv[1:]:
    with open(file, "rb") as f:
        h = hashlib.sha256(f.read()).hexdigest()
        print(f"{file}: {h}")
