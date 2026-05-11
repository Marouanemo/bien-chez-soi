#!/usr/bin/env bash
# ============================================================
# Bien Chez Soi - Deploy script for Hetzner Cloud (Ubuntu 22.04)
# ============================================================
# Usage:
#   1. Provisionne un serveur Hetzner (CX11 suffit, ~3€/mois)
#   2. Ajoute ta cle SSH au serveur
#   3. Exporte ses infos :
#        export SERVER_IP=1.2.3.4
#        export SSH_KEY=~/.ssh/id_ed25519
#   4. Lance : ./deploy.sh
# ============================================================

set -euo pipefail

SERVER_IP="${SERVER_IP:?Definir SERVER_IP=...}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519}"
SSH_USER="${SSH_USER:-root}"
REMOTE_DIR="/var/www/bienchezsoi"

echo "==> Deploiement sur $SERVER_IP"

# 1. Installer nginx + setup du dossier sur le serveur
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SSH_USER@$SERVER_IP" bash <<'REMOTE'
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y nginx ufw

# Firewall : HTTP + HTTPS + SSH
ufw allow OpenSSH || true
ufw allow 'Nginx Full' || true
ufw --force enable || true

mkdir -p /var/www/bienchezsoi
chown -R www-data:www-data /var/www/bienchezsoi
REMOTE

# 2. Upload des fichiers
echo "==> Upload des fichiers..."
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no \
    index.html nginx.conf \
    "$SSH_USER@$SERVER_IP:/tmp/"

# 3. Mise en place + reload nginx
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SSH_USER@$SERVER_IP" bash <<'REMOTE'
set -euo pipefail
cp /tmp/index.html /var/www/bienchezsoi/index.html
cp /tmp/nginx.conf /etc/nginx/sites-available/bienchezsoi
ln -sf /etc/nginx/sites-available/bienchezsoi /etc/nginx/sites-enabled/bienchezsoi
rm -f /etc/nginx/sites-enabled/default
chown -R www-data:www-data /var/www/bienchezsoi
nginx -t && systemctl reload nginx
echo "==> OK : http://$(curl -s ifconfig.me)/"
REMOTE

echo "==> Termine. La landing est en ligne sur http://$SERVER_IP"
