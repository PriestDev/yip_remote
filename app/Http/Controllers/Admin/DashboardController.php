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
            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            header('Location: ' . $baseUrl . '/login');
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

            // Get recent activities
            $activities = [];

            // Recent orders (last 5)
            $recent_orders = $db->query("SELECT id, user_id, total, status, created_at FROM orders ORDER BY created_at DESC LIMIT 5");
            if (!empty($recent_orders)) {
                foreach ($recent_orders as $order) {
                    $activities[] = [
                        'type' => 'order',
                        'title' => 'New Order #' . $order['id'],
                        'description' => 'Order placed for $' . number_format($order['total'], 2),
                        'status' => $order['status'],
                        'timestamp' => $order['created_at']
                    ];
                }
            }

            // Recent user registrations (last 5)
            $recent_users = $db->query("SELECT id, name, email, created_at FROM users WHERE role = 'user' ORDER BY created_at DESC LIMIT 5");
            if (!empty($recent_users)) {
                foreach ($recent_users as $user) {
                    $activities[] = [
                        'type' => 'user',
                        'title' => 'New User Registration',
                        'description' => $user['name'] . ' (' . $user['email'] . ')',
                        'status' => 'registered',
                        'timestamp' => $user['created_at']
                    ];
                }
            }

            // Recent product updates (last 5)
            $recent_products = $db->query("SELECT id, name, updated_at FROM products ORDER BY updated_at DESC LIMIT 5");
            if (!empty($recent_products)) {
                foreach ($recent_products as $product) {
                    $activities[] = [
                        'type' => 'product',
                        'title' => 'Product Updated',
                        'description' => $product['name'],
                        'status' => 'updated',
                        'timestamp' => $product['updated_at']
                    ];
                }
            }

            // Sort activities by timestamp (most recent first)
            usort($activities, function($a, $b) {
                return strtotime($b['timestamp']) - strtotime($a['timestamp']);
            });

            // Keep only top 10 activities
            $activities = array_slice($activities, 0, 10);

            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            $smarty->assign('base_url', $baseUrl);
            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('total_orders', $total_orders);
            $smarty->assign('total_revenue', number_format($total_revenue, 2));
            $smarty->assign('total_customers', $total_customers);
            $smarty->assign('pending_orders', $pending_orders);
            $smarty->assign('activities', $activities);
        } catch (\Exception $e) {
            // Assign default values if database fails
            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('total_orders', 0);
            $smarty->assign('total_revenue', 0);
            $smarty->assign('total_customers', 0);
            $smarty->assign('pending_orders', 0);
            $smarty->assign('activities', []);
            error_log('Dashboard error: ' . $e->getMessage());
        }

        return $smarty->fetch('admin/dashboard.tpl');
    }
}
