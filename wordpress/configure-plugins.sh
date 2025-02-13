#!/bin/bash

echo "🔧 Configurando plugins de seguridad en WordPress..."

# Verificar si WordPress está instalado
if ! wp core is-installed --allow-root --path=/var/www/html; then
  echo "⚠️ WordPress no está instalado. No se pueden configurar los plugins."
  exit 1
fi

# Activar UpdraftPlus
echo "📦 Activando UpdraftPlus..."
wp plugin activate updraftplus --allow-root --path=/var/www/html


# Activar WPS Hide Login
echo "🔐 Configurando WPS Hide Login..."
#wp plugin activate wps-hide-login --allow-root --path=/var/www/html

# Definir la nueva URL de acceso a WordPress
NEW_LOGIN_PATH="access"

# Verificar si ya está configurado
CURRENT_LOGIN_PATH=$(wp option get whl_page --allow-root --path=/var/www/html)

if [ "$CURRENT_LOGIN_PATH" != "$NEW_LOGIN_PATH" ]; then
  echo "🔄 Estableciendo nueva URL de login: /$NEW_LOGIN_PATH"
  wp option update whl_page "$NEW_LOGIN_PATH" --allow-root --path=/var/www/html
else
  echo "✅ La URL de login ya está configurada en: /$NEW_LOGIN_PATH"
fi

# Configuración de Wordfence
# Establecer tu clave de licencia aquí
WORDFENCE_LICENSE_KEY="e729c13e064b26d444cc893c5def9365af5e5baf5a4f241b6c3e4fa2597973e15b7199d1b8bcbf11f5ac107587eccaeaf38c6eec3785b78527d85b2c2729b7ff"

# Verificar si la licencia ya está registrada
CURRENT_LICENSE=$(wp option get wordfence_apiKey --allow-root --path=/var/www/html)
if [ "$CURRENT_LICENSE" != "$WORDFENCE_LICENSE_KEY" ]; then
  echo "🔑 Registrando clave de licencia en Wordfence..."
  wp option update wordfence_apiKey "$WORDFENCE_LICENSE_KEY" --allow-root --path=/var/www/html
  wp option update wordfenceActivated 1 --allow-root --path=/var/www/html
  wp option update wordfence_registered 1 --allow-root --path=/var/www/html
  wp option update wordfence_lastChecked "now" --allow-root --path=/var/www/html
  echo "✅ Licencia de Wordfence activada correctamente."
else
  echo "✅ La clave de licencia de Wordfence ya está configurada."
fi

# 🔄 Forzar la sincronización con los servidores de Wordfence
# wp wordfence sync --allow-root --path=/var/www/html

# 🔍 Configurar opciones de seguridad en Wordfence
wp option update wordfence_autoUpdate_enabled 1 --allow-root --path=/var/www/html
wp option update wordfence_scanFrequency 1 --allow-root --path=/var/www/html
wp option update wordfence_firewallEnabled 1 --allow-root --path=/var/www/html


# Configuración de Sucuri Scanner
echo "🔍 Configurando Sucuri Scanner..."
wp option update sucuri-auto-update 1 --allow-root --path=/var/www/html
wp option update sucuri-email-notifications 1 --allow-root --path=/var/www/html

# Configuración de Limit Login Attempts Reloaded
echo "🔑 Configurando Limit Login Attempts Reloaded..."
wp option update limit_login_allowed_retries 3 --allow-root --path=/var/www/html

# Configuración de All-in-One WP Security & Firewall
echo "🔥 Configurando All-in-One WP Security & Firewall..."
wp option update aiowps_enable_login_lockdown 1 --allow-root --path=/var/www/html
wp option update aiowps_login_max_attempts 3 --allow-root --path=/var/www/html
wp option update aiowps_enable_firewall 1 --allow-root --path=/var/www/html

echo "✅ Configuración de plugins de seguridad completada."