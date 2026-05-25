<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Providers\SmartyServiceProvider;

class DashboardController extends Controller
{
    public function index(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        return $smarty->fetch('admin_dashboard.tpl');
    }
}
