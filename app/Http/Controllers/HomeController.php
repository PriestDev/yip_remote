<?php

namespace App\Http\Controllers;

use App\Providers\SmartyServiceProvider;

class HomeController extends Controller
{
    public function index(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        
        $products = [
            [
                'id' => 1,
                'name' => 'Fresh Apples',
                'price' => '4.99',
                'image' => 'apple.svg',
                'category' => 'Red Apples'
            ],
            [
                'id' => 2,
                'name' => 'Organic Bananas',
                'price' => '3.49',
                'image' => 'banana.svg',
                'category' => 'Tropical Fruits'
            ],
            [
                'id' => 3,
                'name' => 'Sweet Oranges',
                'price' => '5.99',
                'image' => 'orange.svg',
                'category' => 'Citrus Fruits'
            ],
            [
                'id' => 4,
                'name' => 'Juicy Strawberries',
                'price' => '6.49',
                'image' => 'strawberry.svg',
                'category' => 'Berries'
            ],
            [
                'id' => 5,
                'name' => 'Ripe Mangoes',
                'price' => '7.99',
                'image' => 'mango.svg',
                'category' => 'Tropical Fruits'
            ],
            [
                'id' => 6,
                'name' => 'Fresh Grapes',
                'price' => '5.49',
                'image' => 'grape.svg',
                'category' => 'Vine Fruits'
            ]
        ];

        $smarty->assign('products', $products);
        return $smarty->fetch('home.tpl');
    }

    public function show(int $id): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        
        // Fruit product database
        $fruits = [
            1 => [
                'id' => 1,
                'name' => 'Fresh Apples',
                'price' => '4.99',
                'image' => 'apple.svg',
                'category' => 'Red Apples',
                'description' => 'Crisp and sweet fresh apples sourced from local orchards. Rich in fiber and vitamin C. Perfect for snacking, baking, or making fresh juices. Store in cool place for maximum freshness.'
            ],
            2 => [
                'id' => 2,
                'name' => 'Organic Bananas',
                'price' => '3.49',
                'image' => 'banana.svg',
                'category' => 'Tropical Fruits',
                'description' => 'Naturally ripened organic bananas packed with potassium and nutrients. Great for breakfast, smoothies, or baking. Sustainably grown without artificial pesticides.'
            ],
            3 => [
                'id' => 3,
                'name' => 'Sweet Oranges',
                'price' => '5.99',
                'image' => 'orange.svg',
                'category' => 'Citrus Fruits',
                'description' => 'Juicy and refreshing oranges bursting with natural citrus flavor. Excellent source of vitamin C. Perfect for fresh juice, smoothies, or eating fresh. Hand-picked for quality assurance.'
            ],
            4 => [
                'id' => 4,
                'name' => 'Juicy Strawberries',
                'price' => '6.49',
                'image' => 'strawberry.svg',
                'category' => 'Berries',
                'description' => 'Plump, juicy strawberries with natural sweetness. Harvested at peak ripeness for maximum flavor. Rich in antioxidants and vitamin C. Perfect for desserts, breakfast, or snacking.'
            ],
            5 => [
                'id' => 5,
                'name' => 'Ripe Mangoes',
                'price' => '7.99',
                'image' => 'mango.svg',
                'category' => 'Tropical Fruits',
                'description' => 'Aromatic and creamy mangoes imported from tropical regions. Known as the king of fruits with its sweet and luscious taste. Packed with vitamins A and C. Perfect for smoothies and desserts.'
            ],
            6 => [
                'id' => 6,
                'name' => 'Fresh Grapes',
                'price' => '5.49',
                'image' => 'grape.svg',
                'category' => 'Vine Fruits',
                'description' => 'Seedless grapes with natural sweetness and crisp texture. Available in green and red varieties. Great for snacking, salads, or wine making. High in antioxidants and resveratrol.'
            ]
        ];
        
        // Get product or show 404
        if (!isset($fruits[$id])) {
            throw new Exception('Product not found');
        }
        
        $product = $fruits[$id];
        $smarty->assign('product', $product);
        return $smarty->fetch('product.tpl');
    }

    public function cart(): string
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        $smarty = SmartyServiceProvider::getSmarty();

        // Product database for cart display
        $allProducts = [
            1 => ['name' => 'Fresh Apples', 'price' => 4.99],
            2 => ['name' => 'Organic Bananas', 'price' => 3.49],
            3 => ['name' => 'Sweet Oranges', 'price' => 5.99],
            4 => ['name' => 'Juicy Strawberries', 'price' => 6.49],
            5 => ['name' => 'Ripe Mangoes', 'price' => 7.99],
            6 => ['name' => 'Fresh Grapes', 'price' => 5.49],
        ];

        // Get cart items from session
        $cart = $_SESSION['cart'] ?? [];
        $cartItems = [];
        $total = 0;

        foreach ($cart as $id => $quantity) {
            if (isset($allProducts[$id])) {
                $item = $allProducts[$id];
                $subtotal = $item['price'] * $quantity;
                $cartItems[] = [
                    'id' => $id,
                    'name' => $item['name'],
                    'price' => number_format($item['price'], 2),
                    'quantity' => $quantity,
                    'subtotal' => number_format($subtotal, 2)
                ];
                $total += $subtotal;
            }
        }

        $smarty->assign('cartItems', $cartItems);
        $smarty->assign('total', number_format($total, 2));
        $smarty->assign('itemCount', count($cartItems));
        return $smarty->fetch('cart.tpl');
    }
}
