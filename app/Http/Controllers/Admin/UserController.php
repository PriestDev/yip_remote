<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Providers\SmartyServiceProvider;
use App\Models\User;
use App\Services\DatabaseService;

class UserController extends Controller
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

            // Get all users
            $users = [];
            $result = $db->query("SELECT id, name, email, role, created_at FROM users ORDER BY created_at DESC");
            
            if (!empty($result)) {
                $users = $result;
            }

            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('users', $users);
        } catch (\Exception $e) {
            // Assign empty values if database fails
            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('users', []);
            error_log('User listing error: ' . $e->getMessage());
        }

        return $smarty->fetch('admin/users.tpl');
    }

    public function show(int $id): string
    {
        // Check authentication
        if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'admin') {
            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            header('Location: ' . $baseUrl . '/login');
            exit;
        }

        $smarty = SmartyServiceProvider::getSmarty();

        try {
            $user = User::find($id);

            if (!$user) {
                http_response_code(404);
                $smarty->assign('error', 'User not found');
                return $smarty->fetch('admin/users.tpl');
            }

            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('user', [
                'id' => $user->getId(),
                'name' => $user->getName(),
                'email' => $user->getEmail(),
                'role' => $user->getRole(),
                'created_at' => $user->getCreatedAt(),
            ]);
        } catch (\Exception $e) {
            $smarty->assign('user_name', $_SESSION['user_name']);
            error_log('User detail error: ' . $e->getMessage());
        }

        return $smarty->fetch('admin/users.tpl');
    }
}
