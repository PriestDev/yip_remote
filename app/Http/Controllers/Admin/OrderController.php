<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Providers\SmartyServiceProvider;

class OrderController extends Controller
{
    public function index(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        return $smarty->fetch('admin_orders.tpl');
    }

    public function show(int $id): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        
        // Mock order data
        $order = [
            'id' => $id,
            'order_id' => 'ORD-' . str_pad($id, 3, '0', STR_PAD_LEFT),
            'customer' => 'Customer Name',
            'total' => 24.99,
            'status' => 'completed',
            'date' => date('Y-m-d'),
            'items' => []
        ];

        $smarty->assign('order', $order);
        return $smarty->fetch('admin_order_detail.tpl');
    }
}
