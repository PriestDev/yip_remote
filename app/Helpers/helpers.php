<?php

// Application Helpers

function env($key, $default = null)
{
    return $_ENV[$key] ?? $default;
}

function config($key)
{
    $parts = explode('.', $key);
    $config = require __DIR__ . '/../config/' . $parts[0] . '.php';
    
    if (isset($parts[1])) {
        return $config[$parts[1]] ?? null;
    }
    
    return $config;
}

function view($view, $data = [])
{
    return \View::make($view, $data);
}

function resource_path($path = '')
{
    return __DIR__ . '/../resources' . ($path ? '/' . $path : '');
}

function public_path($path = '')
{
    return __DIR__ . '/../public' . ($path ? '/' . $path : '');
}

function abort($code, $message = '')
{
    http_response_code($code);
    echo $message ?: 'Error ' . $code;
    exit;
}

function dd($var)
{
    var_dump($var);
    exit;
}
