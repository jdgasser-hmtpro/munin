#!/bin/bash
# Démarrer les services (si non géré par le conteneur)
service munin-node start
service apache2 start
service cron start
