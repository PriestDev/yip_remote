<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Product;
use App\Services\DatabaseService;
use Exception;

class CheckoutController extends Controller
{
    public function index(): string
    {
        // User must be logged in
        if (!isset($_SESSION['user_id'])) {
            header('Location: /yip_remote/public/login');
            exit;
        }

        // User cannot be admin
        if ($_SESSION['user_role'] === 'admin') {
            header('Location: /yip_remote/public/');
            exit;
        }

        // Cart must not be empty
        if (empty($_SESSION['cart'])) {
            header('Location: /yip_remote/public/cart');
            exit;
        }

        $cart = $_SESSION['cart'];
        $cartItems = [];
        $totalAmount = 0;

        // Fetch product details for each cart item
        foreach ($cart as $productId => $quantity) {
            $product = Product::find($productId);
            if ($product) {
                $itemTotal = $product->getPrice() * $quantity;
                $totalAmount += $itemTotal;
                $cartItems[] = [
                    'product_id' => $productId,
                    'name' => $product->getName(),
                    'price' => $product->getPrice(),
                    'quantity' => $quantity,
                    'total' => $itemTotal
                ];
            }
        }

        $smarty = \App\Providers\SmartyServiceProvider::getSmarty();
        $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
        
        $smarty->assign('base_url', $baseUrl);
        $smarty->assign('cart_items', $cartItems);
        $smarty->assign('total_amount', $totalAmount);
        $smarty->assign('user_id', $_SESSION['user_id']);
        $smarty->assign('user_name', $_SESSION['user_name']);
        
        return $smarty->fetch('checkout.tpl');
    }

    public function store(): void
    {
        header('Content-Type: application/json');

        // User must be logged in
        if (!isset($_SESSION['user_id'])) {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Please sign in to place an order']);
            exit;
        }

        // User cannot be admin
        if ($_SESSION['user_role'] === 'admin') {
            http_response_code(403);
            echo json_encode(['success' => false, 'message' => 'Administrators cannot place orders']);
            exit;
        }

        // Cart must not be empty
        if (empty($_SESSION['cart'])) {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Your cart is empty']);
            exit;
        }

        try {
            $cart = $_SESSION['cart'];
            $userId = $_SESSION['user_id'];
            $totalAmount = 0;

            // Calculate total and validate products
            foreach ($cart as $productId => $quantity) {
                $product = Product::find($productId);
                if (!$product) {
                    http_response_code(400);
                    echo json_encode(['success' => false, 'message' => 'Invalid product in cart']);
                    exit;
                }
                
                if ($product->getStock() < $quantity) {
                    http_response_code(400);
                    echo json_encode(['success' => false, 'message' => 'Insufficient stock for ' . $product->getName()]);
                    exit;
                }

                $totalAmount += $product->getPrice() * $quantity;
            }

            // Create order
            $order = new Order(
                null, // id will be auto-generated
                $userId, // user_id
                null, // order_number will be generated in save()
                $totalAmount, // total
                'pending', // status
                date('Y-m-d H:i:s'), // created_at
                [], // items (empty, will be added separately)
                $_SESSION['user_name'] ?? 'Customer' // customer_name
            );
            $order->save();

            $orderId = $order->getId();

            // Add order items
            foreach ($cart as $productId => $quantity) {
                $product = Product::find($productId);
                
                // Insert order item
                $database = DatabaseService::getInstance();
                $database->execute(
                    'INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)',
                    [$orderId, $productId, $quantity, $product->getPrice()]
                );

                // Update product stock
                $newStock = $product->getStock() - $quantity;
                $database->execute(
                    'UPDATE products SET stock = ? WHERE id = ?',
                    [$newStock, $productId]
                );
            }

            // Clear the cart
            unset($_SESSION['cart']);

            echo json_encode([
                'success' => true,
                'message' => 'Order placed successfully',
                'order_id' => $orderId,
                'redirect' => '/yip_remote/public/order/' . $orderId
            ]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['success' => false, 'message' => 'Failed to place order: ' . $e->getMessage()]);
        }
        exit;
    }

    public function show(int $id): string
    {
        // User must be logged in
        if (!isset($_SESSION['user_id'])) {
            throw new Exception('User not logged in');
        }

        $order = Order::find($id);
        if (!$order) {
            throw new Exception('Order not found');
        }

        // Only show order to the user who placed it
        if ($order->getUserId() !== $_SESSION['user_id']) {
            throw new Exception('You do not have permission to view this order');
        }

        // Fetch order items
        $database = DatabaseService::getInstance();
        $items = $database->query(
            'SELECT oi.*, p.name FROM order_items oi 
             JOIN products p ON oi.product_id = p.id 
             WHERE oi.order_id = ?',
            [$id]
        );

        $smarty = \App\Providers\SmartyServiceProvider::getSmarty();
        $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
        
        $smarty->assign('base_url', $baseUrl);
        $smarty->assign('order', $order);
        $smarty->assign('items', $items);
        $smarty->assign('user_id', $_SESSION['user_id']);
        
        return $smarty->fetch('order-confirmation.tpl');
    }
}
