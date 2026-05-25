<?php

return [
    'debug' => env('SMARTY_DEBUG', false),
    'cache_lifetime' => env('SMARTY_CACHE_LIFETIME', 3600),
    'template_dir' => [resource_path('templates')],
    'compile_dir' => resource_path('templates_c'),
    'cache_dir' => resource_path('templates_c/cache'),
    'plugins_dir' => [resource_path('templates/plugins')],
    'left_delimiter' => '{',
    'right_delimiter' => '}',
    'caching' => false,
];
