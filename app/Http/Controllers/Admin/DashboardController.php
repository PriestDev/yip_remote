<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Providers\SmartyServiceProvider;
use App\Models\Order;
use App\Models\User;
use App\Services\DatabaseService;

class DashboardController extends Controller
{
    public function index(): string
    {
        // Check authentication
        if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'admin') {
            header('Location: /yip_remote/public/login');
            exit;
        }

        $smarty = SmartyServiceProvider::getSmarty();

        try {
            $db = DatabaseService::getInstance();

            // Get total orders
            $orders_result = $db->query("SELECT COUNT(*) as count FROM orders");
            $total_orders = $orders_result[0]['count'] ?? 0;

            // Get total revenue
            $revenue_result = $db->query("SELECT COALESCE(SUM(total), 0) as revenue FROM orders WHERE status = 'completed'");
            $total_revenue = $revenue_result[0]['revenue'] ?? 0;

            // Get total customers
            $customers_result = $db->query("SELECT COUNT(*) as count FROM users WHERE role = 'user'");
            $total_customers = $customers_result[0]['count'] ?? 0;

            // Get pending orders
            $pending_result = $db->query("SELECT COUNT(*) as count FROM orders WHERE status = 'pending'");
            $pending_orders = $pending_result[0]['count'] ?? 0;

            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('total_orders', $total_orders);
            $smarty->assign('total_revenue', number_format($total_revenue, 2));
            $smarty->assign('total_customers', $total_customers);
            $smarty->assign('pending_orders', $pending_orders);
        } catch (\Exception $e) {
            // Assign default values if database fails
            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('total_orders', 0);
            $smarty->assign('total_revenue', 0);
            $smarty->assign('total_customers', 0);
            $smarty->assign('pending_orders', 0);
        }

        return $smarty->fetch('admin/dashboard.tpl');
    }
}
