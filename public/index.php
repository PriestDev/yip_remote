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
| Initialize Database
|--------------------------------------------------------------------------
*/

try {
    \App\Helpers\DatabaseSetup::setupDatabase();
} catch (\Exception $e) {
    // Database setup will be handled gracefully
    error_log('Database setup warning: ' . $e->getMessage());
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

// Start session for cart functionality
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Simple router
try {
    if ($path === '/' || $path === '' || $path === '/yip_remote/public/') {
        $controller = new \App\Http\Controllers\HomeController();
        echo $controller->index();
    } elseif ($path === '/login' || $path === '/login/') {
        $controller = new \App\Http\Controllers\AuthController();
        echo $controller->login();
    } elseif ($path === '/register' || $path === '/register/') {
        $controller = new \App\Http\Controllers\AuthController();
        echo $controller->register();
    } elseif ($path === '/handleLogin' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $controller = new \App\Http\Controllers\AuthController();
        $controller->handleLogin();
    } elseif ($path === '/handleRegister' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $controller = new \App\Http\Controllers\AuthController();
        $controller->handleRegister();
    } elseif ($path === '/logout' || $path === '/logout/') {
        $controller = new \App\Http\Controllers\AuthController();
        $controller->logout();
    } elseif ($path === '/admin/dashboard' || $path === '/admin/dashboard/') {
        $controller = new \App\Http\Controllers\Admin\DashboardController();
        echo $controller->index();
    } elseif ($path === '/admin/orders' || $path === '/admin/orders/') {
        $controller = new \App\Http\Controllers\Admin\OrderController();
        echo $controller->index();
    } elseif (preg_match('#^/admin/orders/(\d+)(?:/)?$#', $path, $matches)) {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\Admin\OrderController();
        echo $controller->show($id);
    } elseif (preg_match('#^/admin/orders/(\d+)/update(?:/)?$#', $path, $matches) && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\Admin\OrderController();
        $controller->update($id);
    } elseif ($path === '/admin/products' || $path === '/admin/products/') {
        $controller = new \App\Http\Controllers\Admin\ProductController();
        echo $controller->index();
    } elseif (($path === '/admin/products/store' || $path === '/admin/products/store/') && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $controller = new \App\Http\Controllers\Admin\ProductController();
        $controller->store();
    } elseif (preg_match('#^/admin/products/(\d+)(?:/)?$#', $path, $matches)) {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\Admin\ProductController();
        echo $controller->show($id);
    } elseif (preg_match('#^/admin/products/(\d+)/edit(?:/)?$#', $path, $matches)) {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\Admin\ProductController();
        echo $controller->editForm($id);
    } elseif (preg_match('#^/admin/products/(\d+)/delete(?:/)?$#', $path, $matches) && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\Admin\ProductController();
        $controller->delete($id);
    } elseif (preg_match('#^/admin/products/(\d+)/update(?:/)?$#', $path, $matches) && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\Admin\ProductController();
        $controller->update($id);
    } elseif ($path === '/admin/users' || $path === '/admin/users/') {
        $controller = new \App\Http\Controllers\Admin\UserController();
        echo $controller->index();
    } elseif (preg_match('#^/admin/users/(\d+)(?:/)?$#', $path, $matches)) {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\Admin\UserController();
        echo $controller->show($id);
    } elseif (preg_match('#^/admin/users/(\d+)/delete(?:/)?$#', $path, $matches) && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\Admin\UserController();
        $controller->delete($id);
    } elseif ($path === '/admin/settings' || $path === '/admin/settings/') {
        $controller = new \App\Http\Controllers\Admin\SettingsController();
        echo $controller->index();
    } elseif ($path === '/cart' || $path === '/cart/') {
        $controller = new \App\Http\Controllers\HomeController();
        echo $controller->cart();
    } elseif ($path === '/checkout' || $path === '/checkout/') {
        $controller = new \App\Http\Controllers\CheckoutController();
        echo $controller->index();
    } elseif ($path === '/api/checkout/store' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $controller = new \App\Http\Controllers\CheckoutController();
        $controller->store();
    } elseif (preg_match('#^/order/(\d+)(?:/)?$#', $path, $matches)) {
        $id = (int)$matches[1];
        $controller = new \App\Http\Controllers\CheckoutController();
        echo $controller->show($id);
    } elseif ($path === '/api/cart/add' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        $controller = new \App\Http\Controllers\CartController();
        $controller->add();
    } elseif ($path === '/api/cart/remove' && $_SERVER['REQUEST_METHOD'] === 'POST') {
        // Handle removing from cart
        header('Content-Type: application/json');
        $data = json_decode(file_get_contents('php://input'), true);
        $id = isset($data['id']) ? (int)$data['id'] : 0;
        
        if ($id > 0 && isset($_SESSION['cart'][$id])) {
            unset($_SESSION['cart'][$id]);
            echo json_encode(['success' => true, 'message' => 'Item removed from cart']);
        } else {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Item not in cart']);
        }
        exit;
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


