<?php

require_once __DIR__ . '/../vendor/autoload.php';

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$method = $_SERVER['REQUEST_METHOD'];

// Define routes
$routes = [
    'GET' => [
        '/' => 'App\Http\Controllers\HomeController@index',
        '/product/{id}' => 'App\Http\Controllers\HomeController@show',
    ],
];

// Route matching
function matchRoute($uri, $routes)
{
    foreach ($routes as $pattern => $controller) {
        // Direct match
        if ($pattern === $uri) {
            return ['controller' => $controller, 'params' => []];
        }
        
        // Pattern match with parameters
        $pattern_regex = preg_replace('/{(\w+)}/', '(?P<$1>\d+)', $pattern);
        $pattern_regex = '#^' . $pattern_regex . '$#';
        
        if (preg_match($pattern_regex, $uri, $matches)) {
            $params = array_filter($matches, function($key) {
                return is_string($key);
            }, ARRAY_FILTER_USE_KEY);
            
            return ['controller' => $controller, 'params' => $params];
        }
    }
    
    return null;
}

// Get the matched route
$match = matchRoute($uri, $routes[$method] ?? []);

if (!$match) {
    header('HTTP/1.0 404 Not Found');
    echo '404 - Page Not Found';
    exit;
}

// Parse controller and action
[$controllerClass, $action] = explode('@', $match['controller']);
$controller = new $controllerClass();

// Call the controller method
$response = call_user_func_array(
    [$controller, $action],
    array_values($match['params'])
);

echo $response;
