#!/bin/bash
set -e

# Fix des proprios sur les volumes montés (UID munin du build courant)
munin_uid=$(id -u munin)
chown -R munin:munin /var/lib/munin /var/log/munin /var/run/munin
chown munin:munin /etc/munin/munin-node.conf 2>/dev/null || true

# Services
/usr/sbin/munin-node &
/usr/sbin/httpd &
/usr/sbin/cron &

# Premier cycle immédiat puis main loop de survie
su - munin --shell=/bin/bash -c "munin-cron" || true

# Surveille : si munin-node ou cron meurt, on le voit dans les logs du conteneur
wait -n
exit 1
