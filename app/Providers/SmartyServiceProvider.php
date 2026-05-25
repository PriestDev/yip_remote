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
            
            $config = require __DIR__ . '/../../config/smarty.php';
            
            // Set directories
            self::$smarty->setTemplateDir($config['template_dir']);
            self::$smarty->setCompileDir($config['compile_dir']);
            self::$smarty->setCacheDir($config['cache_dir']);
            self::$smarty->setPluginsDir($config['plugins_dir']);
            
            // Set delimiters
            self::$smarty->setLeftDelimiter($config['left_delimiter']);
            self::$smarty->setRightDelimiter($config['right_delimiter']);
            
            // Set caching
            self::$smarty->setCaching($config['caching']);
        }

        return self::$smarty;
    }
}

