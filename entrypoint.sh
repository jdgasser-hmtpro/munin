#!/bin/bash
set -e

mkdir -p /var/run/munin /var/log/munin
chown -R munin:munin /var/run/munin /var/log/munin /var/lib/munin
chown munin:munin /etc/munin/munin-node.conf 2>/dev/null || true

# Démons de longue durée — on mémorise leurs PIDs
/usr/sbin/munin-node & NODE_PID=$!
/usr/sbin/httpd & HTTPD_PID=$!
/usr/sbin/cron & CRON_PID=$!

# Premier cycle immédiat (job éphémère, on ne l'attend pas)
su - munin --shell=/bin/bash -c "munin-cron" || true &

# On ne sort que si un DÉMON meurt
wait -n "$NODE_PID" "$HTTPD_PID" "$CRON_PID"
echo "Un service critique est mort — arrêt du conteneur" >&2
exit 1
