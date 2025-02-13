<?php
function mi_tema_scripts() {
    wp_enqueue_style('mi-tema-style', get_stylesheet_uri());
    wp_enqueue_script('mi-tema-js', get_template_directory_uri() . '/js/scripts.js', array('jquery'), null, true);
}
add_action('wp_enqueue_scripts', 'mi_tema_scripts');

function mi_tema_setup() {
    add_theme_support('title-tag');
    add_theme_support('post-thumbnails');
    register_nav_menus(array(
        'menu-principal' => __('Menú Principal', 'mi-tema'),
    ));
}
add_action('after_setup_theme', 'mi_tema_setup');
?>