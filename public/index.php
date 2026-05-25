<?php

declare(strict_types=1);

define('LARAVEL_START', microtime(true));

/*
|--------------------------------------------------------------------------
| Define Application Paths
|--------------------------------------------------------------------------
*/

define('BASE_PATH', __DIR__ . '/..');
define('APP_PATH', BASE_PATH . '/app');
define('RESOURCES_PATH', BASE_PATH . '/resources');

/*
|--------------------------------------------------------------------------
| Register The Auto Loader
|--------------------------------------------------------------------------
*/

require BASE_PATH . '/vendor/autoload.php';

// Manually include Smarty if autoloader fails
if (!class_exists('Smarty')) {
    require BASE_PATH . '/vendor/smarty/smarty/libs/Smarty.class.php';
}

/*
|--------------------------------------------------------------------------
| Load Environment Variables
|--------------------------------------------------------------------------
*/

$_ENV = [];

$envFile = BASE_PATH . '/.env';
if (file_exists($envFile)) {
    $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos($line, '=') !== false && strpos($line, '#') !== 0) {
            list($key, $value) = explode('=', $line, 2);
            $key = trim($key);
            $value = trim($value, '\'"');
            $_ENV[$key] = $value;
            putenv("$key=$value");
        }
    }
}

/*
|--------------------------------------------------------------------------
| Define Helper Functions
|--------------------------------------------------------------------------
*/

function env($key, $default = null) {
    return $_ENV[$key] ?? $default;
}

function resource_path($path = '') {
    return RESOURCES_PATH . ($path ? '/' . ltrim($path, '/') : '');
}

function public_path($path = '') {
    return __DIR__ . ($path ? '/' . ltrim($path, '/') : '');
}

/*
|--------------------------------------------------------------------------
| Route The Request
|--------------------------------------------------------------------------
*/

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
// Remove base path if it exists
$basePath = '/yip_remote/public';
if (strpos($path, $basePath) === 0) {
    $path = substr($path, strlen($basePath));
}
$path = $path ?: '/';

// Simple router
try {
    if ($path === '/' || $path === '' || $path === '/yip_remote/public/') {
        $controller = new \App\Http\Controllers\HomeController();
        echo $controller->index();
    } elseif (preg_match('#^/product/(\d+)(?:/)?(?:\?.*)?$#', $path, $matches)) {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\HomeController();
        echo $controller->show($id);
    } else {
        http_response_code(404);
        echo '<h1>404 - Page Not Found</h1>';
        echo '<p>Requested path: ' . htmlspecialchars($path) . '</p>';
    }
} catch (Exception $e) {
    http_response_code(404);
    echo '<h1>Error</h1>';
    echo '<p>' . htmlspecialchars($e->getMessage()) . '</p>';
}


