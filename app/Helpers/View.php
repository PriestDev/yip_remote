<?php

class View
{
    protected static $data = [];
    protected static $view = '';

    public static function make($view, $data = []): View
    {
        static::$view = $view;
        static::$data = $data;
        return new self();
    }

    public function render(): string
    {
        extract(static::$data);
        
        ob_start();
        include resource_path('templates/' . static::$view . '.php');
        return ob_get_clean();
    }

    public function __toString(): string
    {
        return $this->render();
    }
}

function view($view, $data = []): View
{
    return View::make($view, $data);
}

function resource_path($path = '')
{
    return __DIR__ . '/../../resources' . ($path ? '/' . $path : '');
}
