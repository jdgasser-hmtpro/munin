FROM opensuse/leap:latest

RUN zypper --non-interactive in --auto-agree-with-licenses \
    munin apache2 munin-node cron mailx && \
    zypper clean

# 1. munin-node en IPv4 (fix bind [::])
RUN sed -i 's/^host .*/host 127.0.0.1/' /etc/munin/munin-node.conf || \
    echo "host 127.0.0.1" >> /etc/munin/munin-node.conf
RUN mkdir -p /etc/munin/plugin-conf.d

# 2. LE cron manquant — cycle munin toutes les 5 min
RUN echo '*/5 * * * * munin /usr/bin/munin-cron' > /etc/cron.d/munin && \
    chmod 644 /etc/cron.d/munin

RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime || true
ENV TIMEZONE="Europe/Paris"

COPY munin_inventory.sh /usr/local/bin/munin_inventory.sh
RUN chmod +x /usr/local/bin/munin_inventory.sh

# 3. entrypoint qui répare les permissions avant de lancer
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80 4949
VOLUME /etc/munin/
VOLUME /etc/apache2/vhosts.d/
VOLUME /var/lib/munin/

ENTRYPOINT ["/entrypoint.sh"]
