<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Providers\SmartyServiceProvider;
use App\Models\Order;
use App\Services\DatabaseService;

class OrderController extends Controller
{
    public function index(): string
    {
        // Check authentication
        if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'admin') {
            header('Location: /login');
            exit;
        }

        $smarty = SmartyServiceProvider::getSmarty();

        try {
            $db = DatabaseService::getInstance();
            
            // Fetch all orders with customer information
            $orders = $db->query("
                SELECT o.id, o.order_number, o.total, o.status, o.created_at,
                       u.name as customer_name
                FROM orders o
                LEFT JOIN users u ON o.user_id = u.id
                ORDER BY o.created_at DESC
            ");

            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('orders', $orders);
        } catch (\Exception $e) {
            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('orders', []);
        }

        return $smarty->fetch('admin/orders.tpl');
    }

    public function show(int $id): string
    {
        // Check authentication
        if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'admin') {
            header('Location: /login');
            exit;
        }

        $smarty = SmartyServiceProvider::getSmarty();

        try {
            $db = DatabaseService::getInstance();
            
            // Fetch order with items
            $orders = $db->query("
                SELECT o.*, u.name as customer_name, u.email
                FROM orders o
                LEFT JOIN users u ON o.user_id = u.id
                WHERE o.id = ?
            ", [$id]);

            if (!empty($orders)) {
                $order = $orders[0];
                
                // Fetch order items
                $items = $db->query("
                    SELECT oi.*, p.name as product_name
                    FROM order_items oi
                    JOIN products p ON oi.product_id = p.id
                    WHERE oi.order_id = ?
                ", [$id]);

                $smarty->assign('order', $order);
                $smarty->assign('items', $items);
            }
        } catch (\Exception $e) {
            // Handle error
        }

        return $smarty->fetch('admin/order-detail.tpl');
    }
}
