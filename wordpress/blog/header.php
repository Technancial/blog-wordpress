<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>

<header class="site-header">
    <img src="<?php echo get_template_directory_uri(); ?>/assets/logo.png" alt="Logo" width="100">
    <nav>
        <?php wp_nav_menu(array('theme_location' => 'menu-principal')); ?>
    </nav>
</header>