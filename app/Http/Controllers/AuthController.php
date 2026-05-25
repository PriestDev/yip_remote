<?php

namespace App\Http\Controllers;

use App\Providers\SmartyServiceProvider;
use App\Models\User;

class AuthController extends Controller
{
    public function login(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        return $smarty->fetch('login.tpl');
    }

    public function handleLogin(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Invalid request method']);
            return;
        }

        header('Content-Type: application/json');
        
        $email = $_POST['email'] ?? '';
        $password = $_POST['password'] ?? '';

        if (!$email || !$password) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Email and password are required']);
            return;
        }

        $user = User::findByEmail($email);
        
        if ($user && $user->verifyPassword($password)) {
            $_SESSION['user_id'] = $user->getId();
            $_SESSION['user_name'] = $user->getName();
            $_SESSION['user_email'] = $user->getEmail();
            $_SESSION['user_role'] = $user->getRole();

            // Calculate base URL dynamically
            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            $redirect = $user->getRole() === 'admin' ? $baseUrl . '/admin/dashboard' : $baseUrl . '/';

            echo json_encode([
                'success' => true,
                'message' => 'Login successful',
                'redirect' => $redirect
            ]);
        } else {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Invalid email or password']);
        }
        exit;
    }

    public function register(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        return $smarty->fetch('register.tpl');
    }

    public function handleRegister(): void
    {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Invalid request method']);
            return;
        }

        header('Content-Type: application/json');
        
        $name = $_POST['fullname'] ?? '';
        $email = $_POST['email'] ?? '';
        $password = $_POST['password'] ?? '';
        $confirmPassword = $_POST['confirm_password'] ?? '';

        // Validation
        if (!$name || !$email || !$password || !$confirmPassword) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'All fields are required']);
            return;
        }

        if ($password !== $confirmPassword) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Passwords do not match']);
            return;
        }

        if (strlen($password) < 6) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Password must be at least 6 characters']);
            return;
        }

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Invalid email format']);
            return;
        }

        // Check if email already exists
        if (User::findByEmail($email)) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Email already registered']);
            return;
        }

        // Create new user
        $hashedPassword = password_hash($password, PASSWORD_BCRYPT);
        $user = new User(null, $name, $email, $hashedPassword, 'user');

        if ($user->save()) {
            // Calculate base URL dynamically
            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            echo json_encode([
                'success' => true,
                'message' => 'Registration successful. Please login.',
                'redirect' => $baseUrl . '/login'
            ]);
        } else {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'Registration failed. Please try again.']);
        }
        exit;
    }

    public function logout(): void
    {
        session_destroy();
        $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
        header('Location: ' . $baseUrl . '/');
        exit;
    }
}
