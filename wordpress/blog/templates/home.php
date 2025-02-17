<?php get_header(); ?>
<section>
    <h2>Últimos Artículos</h2>
    <div class="carousel">
        <?php
        $latest_posts = new WP_Query(array('posts_per_page' => 3));
        while ($latest_posts->have_posts()) : $latest_posts->the_post();
        ?>
        <div class="carousel-item">
            <a href="<?php the_permalink(); ?>">
                <?php the_post_thumbnail('medium'); ?>
                <h3><?php the_title(); ?></h3>
            </a>
        </div>
        <?php endwhile; wp_reset_postdata(); ?>
    </div>
</section>
<section>
    <h2>Sobre el Autor</h2>
    <p>Este es un blog sobre emprendimiento y tecnología.</p>
</section>
<?php get_footer(); ?>