<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?php bloginfo('name'); ?></title>
    <?php wp_head(); ?>
</head>
<body>
<header>
    <h1><?php bloginfo('name'); ?></h1>
    <nav>
        <ul>
            <li><a href="<?php echo home_url('/'); ?>">Inicio</a></li>
            <li><a href="<?php echo home_url('/blog'); ?>">Blog</a></li>
            <li><a href="<?php echo home_url('/contacto'); ?>">Contacto</a></li>
        </ul>
    </nav>
</header>