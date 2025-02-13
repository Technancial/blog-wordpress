#!/bin/bash

set -e  # Detener script en caso de error

echo "🔄 Esperando a que la base de datos esté disponible..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST%:*}" --silent; do
  echo "❌ Base de datos no disponible. Reintentando en 5 segundos..."
  sleep 5
done

# Si WordPress no está instalado, instalarlo
if ! wp core is-installed --allow-root --path=/var/www/html; then
  echo "⚠️ WordPress no detectado, instalando..."
  wp core install --allow-root --path=/var/www/html \
    --url="http://localhost" \
    --title="Mi WordPress Seguro" \
    --admin_user="admin" \
    --admin_password="admin" \
    --admin_email="admin@example.com"
fi

# Activar los plugins sin volver a descargarlos
echo "✅ Activando plugins de seguridad..."
wp plugin activate wordfence sucuri-scanner limit-login-attempts-reloaded all-in-one-wp-security-and-firewall --allow-root --path=/var/www/html

# Configurar los plugins después de la activación
#echo "⚙️ Ejecutando configuración de plugins de seguridad..."
#bash /usr/local/bin/configure-plugins.sh

# Iniciar Apache en primer plano
exec apache2-foreground