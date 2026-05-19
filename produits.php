<?php

$url = 'index.php?page=produits';
if (!empty($_GET['recherche'])) {
    $url .= '&recherche=' . urlencode($_GET['recherche']);
}

header('Location: ' . $url);
exit;
