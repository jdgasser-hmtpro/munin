#!/bin/bash
MUNIN_CONF="/etc/munin/munin.conf"
# Répertoire des plugins
PLUGIN_DIR="/etc/munin/plugins/"
# Fichier temporaire
TMP_FILE="/tmp/munin_inventory.tmp"

# Exemple : Lister les hôtes depuis un fichier local (à adapter)
HOSTS_FILE="/etc/munin/hosts.list"

# Vider le fichier temporaire
> "$TMP_FILE"

# Générer la configuration pour chaque hôte
while read -r host; do
    # Ignorer les lignes vides ou commentées
    [[ -z "$host" || "$host" == \#* ]] && continue

    # Exemple : Ajouter une section pour chaque hôte dans munin.conf
    echo "[$host]" >> "$TMP_FILE"
    echo "    address $host" >> "$TMP_FILE"
    echo "    use_node_name yes" >> "$TMP_FILE"
    echo "" >> "$TMP_FILE"

    # Optionnel : Créer des liens symboliques pour des plugins spécifiques
    # Exemple : ln -s /usr/share/munin/plugins/cpu /etc/munin/plugins/cpu_$host
done < "$HOSTS_FILE"

# Sauvegarder la nouvelle configuration
if [ -f "$TMP_FILE" ]; then
    mv "$TMP_FILE" "$MUNIN_CONF"
    chmod 644 "$MUNIN_CONF"
    # Redémarrer Munin pour appliquer les changements (si nécessaire)
    systemctl restart munin-node || true
fi

# Nettoyer
rm -f "$TMP_FILE"
