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

            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            $smarty->assign('base_url', $baseUrl);
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

    public function delete(int $id): void
    {
        // Check authentication
        if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'admin') {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Unauthorized']);
            exit;
        }

        // Prevent self-deletion
        if ($id == $_SESSION['user_id']) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'You cannot delete your own account']);
            exit;
        }

        header('Content-Type: application/json');

        try {
            $db = DatabaseService::getInstance();

            // Check if user exists
            $result = $db->query("SELECT id FROM users WHERE id = ?", [$id]);
            if (empty($result)) {
                http_response_code(404);
                echo json_encode(['success' => false, 'message' => 'User not found']);
                exit;
            }

            // Delete user
            $db->execute("DELETE FROM users WHERE id = ?", [$id]);

            echo json_encode([
                'success' => true,
                'message' => 'User deleted successfully'
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Error deleting user: ' . $e->getMessage()
            ]);
            error_log('User deletion error: ' . $e->getMessage());
        }
        exit;
    }
}
