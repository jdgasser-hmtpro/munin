#!/bin/bash
mkdir -p /var/run/munin /var/log/munin
chown -R munin:munin /var/run/munin /var/log/munin /var/lib/munin
chown munin:munin /etc/munin/munin-node.conf 2>/dev/null || true

/usr/sbin/munin-node &      echo "munin-node pid=$!" >&2
/usr/sbin/httpd &           echo "httpd pid=$!" >&2
/usr/sbin/cron &            echo "cron pid=$!" >&2
su - munin --shell=/bin/bash -c "munin-cron" || echo "premier munin-cron: KO" >&2

tail -f /dev/null
