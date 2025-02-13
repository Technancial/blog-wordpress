# 📌 Configuración del Blog en WordPress en Docker con Apache y ModSecurity

## 📖 Introducción
Este repositorio contiene la configuración completa para desplegar **WordPress** en un **contenedor Docker** con **Apache**, integrando **ModSecurity**, personalizando `.htaccess`, `000-default.conf`, el fin es establecer una configuración segura.

## ✅ Requisitos Previos
Antes de iniciar, asegúrate de tener instalados:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)

## 📂 Estructura del Proyecto
```
wordpress-docker/
│── docker-compose.yml        # Configuración de servicios Docker
│── Dockerfile                # Imagen personalizada de WordPress
│── apache/
│   │── 000-default.conf      # Configuración de VirtualHost Apache
│   │── modsecurity.conf      # Configuración de ModSecurity
│── wordpress/
│   │── .htaccess             # Reglas de reescritura y seguridad de WP
│   │── wp-config.php         # Configuración de WordPress
```

## 📦 Configuración del `Dockerfile`
El `Dockerfile` se basa en la imagen oficial de WordPress con personalizaciones.
```dockerfile
FROM wordpress:6.7.1-php8.1-apache

ENV TZ=America/Lima

WORKDIR /var/www/html

USER root
...
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
```
Nota:
- Considerar actualizar la versión más reciente, actualmente se está usando la versión: wordpress:6.7.1-php8.1-apache
- Configuraciones de seguridad usando **ModSecurity**
- Activaciones de **Reglas de seguridad** en Apache
- Módulos habilitados de Apache:
  - headers
  - ssl
  - rewrite
  - remoteip
  - security2
- Plugins:
  - Wordfence (Firewall y escáner de seguridad)
  - Sucuri Scanner (Monitorización de seguridad)
  - Limit Login Attemps Reloaded (Protección contra ataques de fuerza bruta)
  - WPS Hide Login (Oculta la URL de login de Wordpress)
  - UpdraftPlus (Copias de seguridad automática)

## 🌐 Configuración de Apache (`000-default.conf`)
El archivo `000-default.conf` define la configuración de Apache para WordPress.
```apache
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

    AddType application/font-woff .woff
    AddType application/font-woff2 .woff2
    AddType application/x-font-ttf .ttf
    AddType image/svg+xml .svg

    # 🔐 Activar ModSecurity
    <IfModule security2_module>
        Include /etc/modsecurity/modsecurity.conf
    </IfModule>

    # 🚀 Permitir acceso a archivos en wp-includes/
    <Directory "/var/www/html/wp-includes/">
        AllowOverride None
        Require all granted
    </Directory>

    # 🚀 Permitir acceso a archivos en wp-content/uploads/
    <Directory "/var/www/html/wp-content/uploads/">
        AllowOverride None
        Require all granted
    </Directory>

    # 🔥 Permitir acceso a fuentes
    <Directory "/var/www/html/wp-includes/fonts/">
        AllowOverride None
        Require all granted
    </Directory>

    # 🔥 Seguridad adicional con headers HTTP
    <IfModule mod_headers.c>
        Header always set X-Frame-Options "SAMEORIGIN"
        Header always set X-XSS-Protection "1; mode=block"
        Header always set X-Content-Type-Options "nosniff"
        Header always set Referrer-Policy "strict-origin-when-cross-origin"

        # 🛠️ CSP con permisos ampliados para fuentes y estilos        
        Header always set Content-Security-Policy "default-src 'self' 'unsafe-inline' 'unsafe-eval' data:; font-src 'self' data: https://fonts.gstatic.com https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; img-src 'self' data: blob:;"
    </IfModule>

</VirtualHost>
```

## 🔍 Configuración de VirtualHost

| 🔍 Configuración         | 📌 Descripción |
|-------------------------|---------------------------|
| **Puerto**              | `80` (sin HTTPS) |
| **Raíz del sitio**      | `/var/www/html` |
| **Módulos habilitados** | `security2 (ModSecurity)`, `headers` |
| **Logs**                | `error.log` y `access.log` |
| **Permisos de directorios** | Acceso a `wp-includes/`, `wp-content/uploads/`, `wp-includes/fonts/` |
| **Seguridad en headers** | `X-Frame-Options`, `X-XSS-Protection`, `X-Content-Type-Options`, `Referrer-Policy` |
| **CSP**                 | Restringe scripts, imágenes y fuentes externas |


### Headers utilizados

## 🔐 Headers de Seguridad en Apache

| 🔍 **Header**                        | 📌 **Descripción** | 🛡 **Protección contra** |
|--------------------------------------|-------------------|-------------------------|
| **X-Frame-Options** `"SAMEORIGIN"`   | Evita que la página se cargue dentro de un `<iframe>` en otro sitio. | **Clickjacking** (Un atacante puede incrustar la página en otra y engañar al usuario para que haga clic en elementos sin su conocimiento). |
| **X-XSS-Protection** `"1; mode=block"` | Habilita el filtro de protección contra ataques **Cross-Site Scripting (XSS)** en navegadores antiguos. | **XSS (Cross-Site Scripting)**, donde un atacante inyecta código malicioso en el sitio. |
| **X-Content-Type-Options** `"nosniff"` | Evita que los navegadores intenten adivinar el tipo de contenido (`MIME type`) de los archivos. | **MIME type sniffing**, donde un atacante cambia el contenido de un archivo (por ejemplo, un script malicioso en lugar de una imagen). |
| **Referrer-Policy** `"strict-origin-when-cross-origin"` | Controla cómo se envía la información de referencia (`Referer`) al cambiar de una página a otra. | Evita el **robo de datos de referer** cuando los usuarios navegan entre sitios. |
| **Content-Security-Policy (CSP)** | Restringe las fuentes de contenido permitidas, evitando la ejecución de scripts maliciosos. | **XSS, inyección de código, ataques de origen cruzado**, y reduce el riesgo de ejecución de scripts no confiables. |

## 🔥 Configuración de `.htaccess`
Este archivo maneja **reescrituras de URL**, acceso a archivos y seguridad adicional.
```apache
# 🔥 Activar reescritura de URLs en WordPress
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
    RewriteBase /
    RewriteRule ^index\.php$ - [L]

    # 🔹 Redirigir todo excepto archivos existentes y directorios a index.php
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
</IfModule>

...
# 🔥 Seguridad adicional con headers HTTP
<IfModule mod_headers.c>
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set X-Content-Type-Options "nosniff"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    Header always set Content-Security-Policy "default-src 'self' data:; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; font-src 'self' data:; img-src 'self' data: https://secure.gravatar.com;;"
</IfModule>
```

## 🔍 **Resumen de la configuración en `.htaccess`**

| 🔥 **Funcionalidad** | 📌 **Descripción** |
|----------------------|-------------------|
| **Activación de reescritura de URLs** | Habilita `mod_rewrite` para reescribir URLs en WordPress y redirigir todas las peticiones a `index.php`, excepto archivos y directorios existentes. |
| **Acceso permitido a archivos de estilos y scripts** | Se permite el acceso a `load-styles.php` y `load-scripts.php`, archivos esenciales para el funcionamiento de WordPress. |
| **Acceso a archivos estáticos (JS, CSS, fuentes, imágenes)** | Se configuran **CORS** (`Access-Control-Allow-Origin`) para permitir fuentes externas (`https://fonts.gstatic.com`). |
| **Acceso a archivos en `wp-includes/` y `wp-content/uploads/`** | Se permite acceso a los archivos en `wp-includes/js`, `wp-includes/css`, `blocks` y `dist`. |
| **Bloqueo de archivos sensibles** | Se bloquea el acceso a `.htaccess`, `.htpasswd`, `wp-config.php`, `php.ini`, `php5.ini`, `readme.html`, `license.txt` para evitar filtración de información. |
| **Bloqueo de `xmlrpc.php`** | Se deniega el acceso a `xmlrpc.php`, protegiendo contra ataques de fuerza bruta y abuso de XML-RPC. |
| **Permiso para `admin-ajax.php`** | Se permite acceso a `admin-ajax.php`, necesario para el correcto funcionamiento de AJAX en WordPress. |
| **Headers de seguridad HTTP** | Se agregan encabezados de seguridad para proteger contra ataques como **clickjacking**, **XSS**, **MIME sniffing**, y control de referer. |
| **Política de Seguridad de Contenidos (CSP)** | Restringe el uso de scripts, fuentes e imágenes a `self`, permitiendo imágenes desde `https://secure.gravatar.com`. |


## 🔐 Configuración de Seguridad (`modsecurity.conf`)
Este archivo contiene reglas para **ModSecurity**.
```apache
###############################################
# ModSecurity Configuration for WordPress
###############################################

# 🔥 Habilitar ModSecurity
SecStatusEngine Off
SecRuleEngine On

...

# 🔥 Configuración de análisis de tráfico
SecDebugLog /var/log/apache2/modsec_debug.log
SecDebugLogLevel 3

```

## 📌 Configuraciones más relevantes

| 🔍 Configuración | 📌 Descripción |
|----------------|----------------|
| **SecRuleEngine On** | **Activa ModSecurity** para filtrar tráfico sospechoso y ataques. |
| **SecAuditEngine RelevantOnly** | **Registra solo eventos importantes** en el log para evitar exceso de información. |
| **Permitir archivos estáticos sin validación** | **Evita bloqueos innecesarios** en la carga de archivos como JS, CSS, imágenes y fuentes. |
| **Permitir acceso a `wp-includes/` y `wp-content/fonts/`** | **Reduce reglas de seguridad** en estas carpetas para evitar falsos positivos. |
| **Permitir acceso a `wp-admin/` y `admin-ajax.php`** | **Evita restricciones en el backend** de WordPress. |
| **Permitir carga de fuentes remotas** | **Autoriza Google Fonts, CDN de scripts y Gravatar**. |
| **Evitar bloqueos en formularios** | **Deshabilita reglas que podrían afectar el login o formularios de contacto**. |
| **Permitir API REST de WordPress** | **Evita bloqueos en `/wp-json/`**, necesarios para API REST. |
| **Protección contra ataques comunes** | 🔥 **Bloquea SQL Injection, XSS y bots maliciosos**. |
| **Registro y depuración** | **Logs de eventos de seguridad y tráfico sospechoso**. |


## 🚀 Despliegue con Docker Compose
Ejecuta el siguiente comando para iniciar el contenedor:
```sh
docker-compose up -d
```
Para verificar logs:
```sh
docker logs -f wordpress
```
Nota: Considerar que el DockerCompose está para poder levantar el blog de forma local, con la base de datos, y se está permitiendo que la base de datos pueda cargar un dump de forma inicial.
crear un archivo .env con cada una de las varibles de entorno requeridas.

## 🛠️ Solución de Problemas
### 🔹 Errores con `.htaccess`
Si las reglas no se aplican, verifica que `mod_rewrite` está habilitado:
```sh
a2enmod rewrite && service apache2 restart
```

### 🔹 Bloqueo de archivos estáticos
Si Apache o ModSecurity bloquea archivos, revisa `modsecurity.conf` y `.htaccess`.
```apache
SecRuleRemoveById 5001
```

---
**📌 Con esta documentación, el equipo puede configurar y mantener WordPress en Docker con seguridad y persistencia.** 🚀

