<?php

namespace App\Http\Controllers;

use App\Providers\SmartyServiceProvider;
use App\Models\Product;
use Exception;

class HomeController extends Controller
{
    public function index(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        
        // Fetch products from database
        $productObjects = Product::all();
        
        // Convert Product objects to arrays for Smarty
        $products = [];
        foreach ($productObjects as $product) {
            $products[] = [
                'id' => $product->getId(),
                'name' => $product->getName(),
                'description' => $product->getDescription(),
                'category' => $product->getCategory(),
                'price' => $product->getPrice(),
                'image' => $product->getImage(),
                'stock' => $product->getStock()
            ];
        }

        $smarty->assign('products', $products);
        return $smarty->fetch('home.tpl');
    }

    public function show(int $id): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        
        // Get product from database
        $productObj = Product::find($id);
        
        if (!$productObj) {
            throw new Exception('Product not found');
        }

        // Convert to array for Smarty
        $product = [
            'id' => $productObj->getId(),
            'name' => $productObj->getName(),
            'description' => $productObj->getDescription(),
            'category' => $productObj->getCategory(),
            'price' => $productObj->getPrice(),
            'image' => $productObj->getImage(),
            'stock' => $productObj->getStock()
        ];

        $smarty->assign('product', $product);
        return $smarty->fetch('product.tpl');
    }

    public function cart(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        
        // Fetch cart items from session
        $cartItems = $_SESSION['cart'] ?? [];
        $products = [];
        $total = 0;

        foreach ($cartItems as $product_id => $quantity) {
            $product = Product::find($product_id);
            if ($product) {
                $item_total = $product->getPrice() * $quantity;
                $total += $item_total;
                $products[] = [
                    'id' => $product->getId(),
                    'name' => $product->getName(),
                    'price' => $product->getPrice(),
                    'quantity' => $quantity,
                    'subtotal' => $item_total,
                    'image' => $product->getImage()
                ];
            }
        }

        $smarty->assign('cartItems', $products);
        $smarty->assign('itemCount', count($products));
        $smarty->assign('total', $total);
        return $smarty->fetch('cart.tpl');
    }
}
