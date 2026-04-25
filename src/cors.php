<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => [
        'https://*.pages.dev',
        'http://167.71.193.120',
        'http://167.71.193.120:8080',
        'http://localhost',
        'http://127.0.0.1',
        'null',
    ],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
