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
            
            // Assign dynamic base URL
            $scriptPath = $_SERVER['SCRIPT_NAME'] ?? '';
            $baseUrl = dirname($scriptPath); // Removes /index.php, leaves /yip_remote/public (or whatever)
            self::$smarty->assign('base_url', $baseUrl);
            
            // Register custom modifiers to avoid deprecation warnings
            self::registerModifiers();
        }

        return self::$smarty;
    }

    /**
     * Register custom modifiers to prevent deprecation warnings
     */
    private static function registerModifiers(): void
    {
        // number_format modifier - formats a number with thousands separator
        self::$smarty->registerPlugin(
            'modifier',
            'number_format',
            function($number, $decimals = 0, $dec_point = '.', $thousands_sep = ',') {
                return number_format($number, $decimals, $dec_point, $thousands_sep);
            }
        );

        // ucfirst modifier - capitalizes first character
        self::$smarty->registerPlugin(
            'modifier',
            'ucfirst',
            function($string) {
                return ucfirst($string);
            }
        );

        // date_format modifier - formats date using Smarty format strings
        self::$smarty->registerPlugin(
            'modifier',
            'date_format',
            function($date, $format = '%b %e, %Y', $default_date = '') {
                if (empty($date)) {
                    return $default_date;
                }
                
                // If $date is a string, convert to timestamp
                if (is_string($date)) {
                    $date = strtotime($date);
                }
                
                // Convert Smarty format to PHP format
                // Smarty uses strftime format, PHP uses date format
                // Common conversions:
                // %Y -> Y (year, 4 digits)
                // %m -> m (month, 2 digits)
                // %d -> d (day, 2 digits)
                // %H -> H (hour, 24-hour)
                // %M -> i (minute)
                // %S -> s (second)
                
                $phpFormat = strtr($format, [
                    '%Y' => 'Y',
                    '%y' => 'y',
                    '%m' => 'm',
                    '%d' => 'd',
                    '%H' => 'H',
                    '%M' => 'i',
                    '%S' => 's',
                    '%F' => 'Y-m-d',
                    '%T' => 'H:i:s',
                    '%b' => 'M',
                    '%B' => 'F',
                    '%A' => 'l',
                    '%a' => 'D',
                ]);
                
                return date($phpFormat, $date);
            }
        );
    }
}

