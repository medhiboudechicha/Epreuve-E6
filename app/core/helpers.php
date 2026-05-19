<?php

function e($texte)
{
    return htmlspecialchars((string) $texte, ENT_QUOTES, 'UTF-8');
}

function url($page, $params = [])
{
    $params = array_merge(['page' => $page], $params);
    return 'index.php?' . http_build_query($params);
}

function redirection($page, $params = [])
{
    header('Location: ' . url($page, $params));
    exit;
}

function message($texte = null, $type = 'ok')
{
    if ($texte !== null) {
        $_SESSION['message'] = ['texte' => $texte, 'type' => $type];
        return;
    }

    if (!isset($_SESSION['message'])) {
        return null;
    }

    $message = $_SESSION['message'];
    unset($_SESSION['message']);
    return $message;
}

function image_produit($nomImage)
{
    if ($nomImage && file_exists(__DIR__ . '/../../uploads/' . $nomImage)) {
        return 'uploads/' . rawurlencode($nomImage);
    }

    return 'uploads/no_image.jpg';
}

function prix($montant)
{
    return number_format((float) $montant, 2, ',', ' ') . ' €';
}
