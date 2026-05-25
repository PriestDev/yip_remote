<?php

namespace App\Providers;

use Smarty;

class SmartyServiceProvider
{
    protected static $smarty;

    public static function getSmarty(): Smarty
    {
        if (self::$smarty === null) {
            self::$smarty = new Smarty();
            
            $config = config('smarty');
            
            self::$smarty->setTemplateDir($config['template_dir']);
            self::$smarty->setCompileDir($config['compile_dir']);
            self::$smarty->setCacheDir($config['compile_dir'] . '/cache');
            self::$smarty->setDebug($config['debug']);
            self::$smarty->setCaching(Smarty::CACHING_LIFETIME_CURRENT);
            self::$smarty->setCacheLifetime($config['cache_lifetime']);
        }

        return self::$smarty;
    }

    public static function register()
    {
        // Service provider registration logic
    }
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

function resource_path($path = '')
{
    return __DIR__ . '/../../resources' . ($path ? '/' . $path : '');
}
