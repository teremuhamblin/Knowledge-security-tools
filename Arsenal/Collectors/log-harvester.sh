#!/bin/bash
# Log Harvester — Knowledge Security Tools
# Extraction ciblée des logs système pour analyse ultérieure.

OUTPUT="logs-$(date +%F).tar.gz"

echo "Collecte des logs..."
tar -czf "$OUTPUT" /var/log/*.log

echo "Logs archivés dans $OUTPUT"
