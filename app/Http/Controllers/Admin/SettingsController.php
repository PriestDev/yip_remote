<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Providers\SmartyServiceProvider;
use App\Services\DatabaseService;

class SettingsController extends Controller
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

            // Get system statistics for settings dashboard
            $ordersResult = $db->query("SELECT COUNT(*) as count FROM orders");
            $productsResult = $db->query("SELECT COUNT(*) as count FROM products");
            $usersResult = $db->query("SELECT COUNT(*) as count FROM users");
            $adminResult = $db->query("SELECT COUNT(*) as count FROM users WHERE role = 'admin'");

            $stats = [
                'total_orders' => $ordersResult[0]['count'] ?? 0,
                'total_products' => $productsResult[0]['count'] ?? 0,
                'total_users' => $usersResult[0]['count'] ?? 0,
                'admin_users' => $adminResult[0]['count'] ?? 0,
            ];

            // System information
            $systemInfo = [
                'php_version' => phpversion(),
                'current_date' => date('Y-m-d H:i:s'),
                'database' => 'MySQL',
            ];

            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('stats', $stats);
            $smarty->assign('system_info', $systemInfo);
        } catch (\Exception $e) {
            // Assign empty values if database fails
            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('stats', [
                'total_orders' => 0,
                'total_products' => 0,
                'total_users' => 0,
                'admin_users' => 0,
            ]);
            $smarty->assign('system_info', [
                'php_version' => phpversion(),
                'current_date' => date('Y-m-d H:i:s'),
                'database' => 'MySQL',
            ]);
            error_log('Settings retrieval error: ' . $e->getMessage());
        }

        return $smarty->fetch('admin/settings.tpl');
    }
}
