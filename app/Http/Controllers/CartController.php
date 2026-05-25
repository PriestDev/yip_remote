<?php

namespace App\Http\Controllers;

class CartController extends Controller
{
    public function add(): void
    {
        header('Content-Type: application/json');

        // Check if user is authenticated
        if (!isset($_SESSION['user_id'])) {
            http_response_code(401);
            echo json_encode([
                'success' => false,
                'message' => 'Please sign in to add items to cart',
                'redirect' => '/yip_remote/public/register'
            ]);
            exit;
        }

        // Check if user is admin
        if ($_SESSION['user_role'] === 'admin') {
            http_response_code(403);
            echo json_encode([
                'success' => false,
                'message' => 'Administrators cannot add products to cart'
            ]);
            exit;
        }

        // Get product ID and quantity from request
        $data = json_decode(file_get_contents('php://input'), true);
        $id = isset($data['id']) ? (int)$data['id'] : 0;
        $quantity = isset($data['quantity']) ? (int)$data['quantity'] : 1;

        if ($id <= 0) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Invalid product ID']);
            exit;
        }

        if ($quantity < 1) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Quantity must be at least 1']);
            exit;
        }

        // Initialize cart in session if not exists
        if (!isset($_SESSION['cart'])) {
            $_SESSION['cart'] = [];
        }

        // Add product to cart with quantity
        $_SESSION['cart'][$id] = ($_SESSION['cart'][$id] ?? 0) + $quantity;

        echo json_encode([
            'success' => true,
            'message' => 'Item added to cart successfully',
            'cartCount' => count($_SESSION['cart'])
        ]);
        exit;
    }
}
