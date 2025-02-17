<?php
/**
 * Theme Name: Technancial Theme
 * Theme URI: https://technancial.com
 * Description: Un theme personalizado para WordPress basado en el logo de Technancial.
 * Author: Technancial
 * Version: 1.0
 * License: GPL-2.0+
 */

// Cargar scripts y estilos
function technancial_enqueue_assets() {
    wp_enqueue_style('technancial-style', get_stylesheet_uri());
    wp_enqueue_style('technancial-custom', get_template_directory_uri() . '/assets/css/custom.css');
    wp_enqueue_script('technancial-scripts', get_template_directory_uri() . '/assets/js/scripts.js', array('jquery'), null, true);
}
add_action('wp_enqueue_scripts', 'technancial_enqueue_assets');

// Registrar menú de navegación
function technancial_register_menus() {
    register_nav_menus(array(
        'main-menu' => __('Menú Principal', 'technancial'),
    ));
}
add_action('after_setup_theme', 'technancial_register_menus');

// Configurar soporte de imágenes destacadas
function technancial_theme_setup() {
    add_theme_support('post-thumbnails');
    add_theme_support('title-tag');
}
add_action('after_setup_theme', 'technancial_theme_setup');

// Personalizar el logo del sitio
function technancial_custom_logo() {
    add_theme_support('custom-logo', array(
        'height'      => 80,
        'width'       => 200,
        'flex-height' => true,
        'flex-width'  => true,
    ));
}
add_action('after_setup_theme', 'technancial_custom_logo');
