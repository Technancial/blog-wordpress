<?php get_header(); ?>

<main class="content">
    <h1><?php bloginfo('name'); ?></h1>
    <p><?php bloginfo('description'); ?></p>

    <?php if (have_posts()) : ?>
        <div class="posts">
            <?php while (have_posts()) : the_post(); ?>
                <article class="post">
                    <h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
                    <p><?php the_excerpt(); ?></p>
                </article>
            <?php endwhile; ?>
        </div>
    <?php else : ?>
        <p>No hay publicaciones disponibles.</p>
    <?php endif; ?>
</main>

<?php get_footer(); ?>