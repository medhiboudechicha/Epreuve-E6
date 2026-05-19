<?php

$url = 'index.php?page=utilisateur_form';
if (!empty($_GET['id'])) {
    $url .= '&id=' . urlencode($_GET['id']);
}

header('Location: ' . $url);
exit;
