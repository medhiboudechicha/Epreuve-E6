<?php

class Database
{
    public static function connexion()
    {
        $config = require __DIR__ . '/../../config.php';

        return new PDO(
            $config['db']['dsn'],
            $config['db']['user'],
            $config['db']['password'],
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::SQLSRV_ATTR_ENCODING => PDO::SQLSRV_ENCODING_UTF8,
            ]
        );
    }
}
