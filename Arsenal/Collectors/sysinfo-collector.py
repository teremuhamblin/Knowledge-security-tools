#!/usr/bin/env python3
"""
Sysinfo Collector — Knowledge Security Tools
Collecte d'informations système : OS, CPU, RAM, réseau.
"""

import platform
import psutil
import socket

print("=== Sysinfo Collector ===")
print("OS:", platform.platform())
print("CPU:", platform.processor())
print("RAM:", psutil.virtual_memory().total)
print("Hostname:", socket.gethostname())
