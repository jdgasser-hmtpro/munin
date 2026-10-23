#!/bin/bash
set -e

# Répertoires runtime (/var/run est vide à chaque démarrage de conteneur)
mkdir -p /var/run/munin /var/log/munin
chown -R munin:munin /var/run/munin /var/log/munin /var/lib/munin
chown munin:munin /etc/munin/munin-node.conf 2>/dev/null || true

/usr/sbin/munin-node &
/usr/sbin/httpd &
/usr/sbin/cron &

su - munin --shell=/bin/bash -c "munin-cron" || true

wait -n
exit 1
