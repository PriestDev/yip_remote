<?php

namespace App\Http\Controllers;

use Illuminate\View\View;

class HomeController extends Controller
{
    public function index(): View
    {
        $products = [
            ['id' => 1, 'name' => 'Product 1', 'price' => 29.99, 'image' => 'product1.jpg'],
            ['id' => 2, 'name' => 'Product 2', 'price' => 39.99, 'image' => 'product2.jpg'],
            ['id' => 3, 'name' => 'Product 3', 'price' => 49.99, 'image' => 'product3.jpg'],
        ];

        return view('home', ['products' => $products]);
    }

    public function show(int $id): View
    {
        $product = [
            'id' => $id,
            'name' => 'Product ' . $id,
            'price' => 29.99 + ($id * 10),
            'description' => 'This is a detailed description of product ' . $id,
            'image' => 'product' . $id . '.jpg'
        ];

        return view('product', ['product' => $product]);
    }
}
