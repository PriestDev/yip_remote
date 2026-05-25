<?php

namespace App\Http\Controllers;

use App\Providers\SmartyServiceProvider;

class AuthController extends Controller
{
    public function login(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        return $smarty->fetch('login.tpl');
    }

    public function register(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        return $smarty->fetch('register.tpl');
    }

    public function logout(): void
    {
        // Clear session
        session_destroy();
        header('Location: /');
        exit;
    }
}
