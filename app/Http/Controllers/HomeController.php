<?php

namespace App\Http\Controllers;

use App\Providers\SmartyServiceProvider;

class HomeController extends Controller
{
    public function index(): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        
        $products = [
            ['id' => 1, 'name' => 'Product 1', 'price' => '29.99', 'image' => 'product1.jpg'],
            ['id' => 2, 'name' => 'Product 2', 'price' => '39.99', 'image' => 'product2.jpg'],
            ['id' => 3, 'name' => 'Product 3', 'price' => '49.99', 'image' => 'product3.jpg'],
        ];

        $smarty->assign('products', $products);
        return $smarty->fetch('home.tpl');
    }

    public function show(int $id): string
    {
        $smarty = SmartyServiceProvider::getSmarty();
        
        $product = [
            'id' => $id,
            'name' => 'Product ' . $id,
            'price' => number_format(29.99 + ($id * 10), 2),
            'description' => 'This is a detailed description of product ' . $id,
            'image' => 'product' . $id . '.jpg'
        ];

        $smarty->assign('product', $product);
        return $smarty->fetch('product.tpl');
    }
}
