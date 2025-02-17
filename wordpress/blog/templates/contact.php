<?php get_header(); ?>
<h2>Contacto</h2>
<form action="" method="post">
    <label for="name">Nombre:</label>
    <input type="text" name="name" required>
    <label for="email">Email:</label>
    <input type="email" name="email" required>
    <label for="message">Mensaje:</label>
    <textarea name="message" required></textarea>
    <button type="submit">Enviar</button>
</form>
<?php get_footer(); ?>