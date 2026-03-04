FROM opensuse/leap:15.6

# Installer les dépendances
RUN zypper --non-interactive in --auto-agree-with-licenses \
    munin apache2 munin-node cron mailx

# Créer les répertoires nécessaires (si non créés par les volumes)
RUN mkdir -p /var/lib/munin /var/log/munin /var/run/munin

# Copier uniquement les scripts/outils nécessaires (ex: munin_inventory.sh)
COPY munin_inventory.sh /usr/local/bin/munin_inventory.sh
RUN chmod +x /usr/local/bin/munin_inventory.sh

ENV TIMEZONE="/Europe/Paris"
# Exposer les ports


EXPOSE 80
EXPOSE 4949

VOLUME /etc/munin/
VOLUME /etc/apache2/vhosts.d/
VOLUME /var/lib/munin/

# Démarrer les services directement (sans init.sh)
CMD service munin-node start && service apache2 start && service cron start && tail -f /dev/null
