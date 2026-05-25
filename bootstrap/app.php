<?php

$app = new \Illuminate\Container\Container();

// Register configuration
$app->singleton('config', function () {
    $config = require __DIR__ . '/../config/app.php';
    return $config;
});

// Register the HTTP Kernel
$app->singleton(\Illuminate\Contracts\Http\Kernel::class, \App\Http\Kernel::class);

// Register the Console Kernel
$app->singleton(\Illuminate\Contracts\Console\Kernel::class, \App\Console\Kernel::class);

// Register the Exception Handler
$app->singleton(\Illuminate\Contracts\Debug\ExceptionHandler::class, \App\Exceptions\Handler::class);

return $app;
