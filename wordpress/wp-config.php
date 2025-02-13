<?php
define('DB_NAME', getenv_docker('WORDPRESS_DB_NAME'));
define('DB_USER', getenv_docker('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv_docker('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', 'WORDPRESS_DB_HOST');

define('FORCE_SSL_ADMIN', true);
define('DISALLOW_FILE_EDIT', true);
define('DISALLOW_FILE_MODS', true);
define('WP_DEBUG', false);
define('WP_AUTO_UPDATE_CORE', true);
define('FS_METHOD', 'direct');

define( 'AUTH_KEY',         getenv_docker('WORDPRESS_AUTH_KEY',         'a12da22ca12c8d8e9a0e1015e5dad875061575ea') );
define( 'SECURE_AUTH_KEY',  getenv_docker('WORDPRESS_SECURE_AUTH_KEY',  '2ce363dccc980360e3cc847dc026ca090597b67b') );
define( 'LOGGED_IN_KEY',    getenv_docker('WORDPRESS_LOGGED_IN_KEY',    '8ba6ab565d4ff0b189d50ca2e27ff4412c215ad0') );
define( 'NONCE_KEY',        getenv_docker('WORDPRESS_NONCE_KEY',        'c633dc5215cbc6533ee254d84f250cbd6caa8409') );
define( 'AUTH_SALT',        getenv_docker('WORDPRESS_AUTH_SALT',        '6c4fb0442338a8cc56d130bf3c81459428c17e10') );
define( 'SECURE_AUTH_SALT', getenv_docker('WORDPRESS_SECURE_AUTH_SALT', 'a4148cd67bc341bad66751fbaa09687e720bfabb') );
define( 'LOGGED_IN_SALT',   getenv_docker('WORDPRESS_LOGGED_IN_SALT',   'aa0c35cf9bd9830f4870de4c998d5c1feb98d127') );
define( 'NONCE_SALT',       getenv_docker('WORDPRESS_NONCE_SALT',       '539883420eef2d67e66c5c870b02dafae117799e') );

define( 'WP_DEBUG', !!getenv_docker('WORDPRESS_DEBUG', '') );

$table_prefix = 'wp_';

if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/');
}
require_once ABSPATH . 'wp-settings.php';