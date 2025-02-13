#!/bin/bash
set -euo pipefail

echo "🔄 Verificando instalación de WordPress en /var/www/html..."

# Si la carpeta está vacía, copiar WordPress desde /usr/src/wordpress
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "📂 Copiando archivos de WordPress a /var/www/html..."
  cp -r /usr/src/wordpress/* /var/www/html/
  chown -R www-data:www-data /var/www/html

  # Si wp-config.php no existe pero wp-config-docker.php sí, renombrarlo
  if [ ! -f /var/www/html/wp-config.php ] && [ -f /var/www/html/wp-config-docker.php ]; then
    echo "🔧 Renombrando wp-config-docker.php a wp-config.php..."
    mv /var/www/html/wp-config-docker.php /var/www/html/wp-config.php
    chown www-data:www-data /var/www/html/wp-config.php
  fi
  
fi

# Ejecutar setup.sh solo si WordPress ya está en /var/www/html
if [ -f /var/www/html/wp-config.php ]; then
  echo "⚙️ Ejecutando setup.sh..."
  bash /usr/local/bin/setup.sh
else
  echo "⚠️ No se encontró wp-config.php. Posible problema con la copia de WordPress."
fi

# Ejecutar el comando original (Apache)
exec "$@"