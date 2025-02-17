<?php get_header(); ?>

<main class="container">
    <section class="content">
        <?php if (have_posts()) : ?>
            <?php while (have_posts()) : the_post(); ?>
                <article class="post">
                    <h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
                    <p><?php the_excerpt(); ?></p>
                </article>
            <?php endwhile; ?>
            <div class="pagination">
                <?php the_posts_navigation(); ?>
            </div>
        <?php else : ?>
            <p>No se encontraron publicaciones.</p>
        <?php endif; ?>
    </section>
</main>

<?php get_footer(); ?>