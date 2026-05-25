<?php

$app = new \Illuminate\Container\Container();

$app->singleton('config', function () {
    return require __DIR__ . '/../config/app.php';
});

return $app;
