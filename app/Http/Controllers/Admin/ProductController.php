<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Providers\SmartyServiceProvider;
use App\Models\Product;
use App\Services\DatabaseService;

class ProductController extends Controller
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

            // Get all products
            $products = [];
            $result = $db->query("SELECT id, name, price, stock, category, image FROM products ORDER BY id DESC");
            
            if (!empty($result)) {
                $products = $result;
            }

            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('products', $products);
        } catch (\Exception $e) {
            // Assign empty values if database fails
            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('products', []);
            error_log('Product listing error: ' . $e->getMessage());
        }

        return $smarty->fetch('admin/products.tpl');
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
            $product = Product::find($id);

            if (!$product) {
                http_response_code(404);
                $smarty->assign('error', 'Product not found');
                return $smarty->fetch('admin/products.tpl');
            }

            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('product', [
                'id' => $product->getId(),
                'name' => $product->getName(),
                'description' => $product->getDescription(),
                'price' => $product->getPrice(),
                'stock' => $product->getStock(),
                'category' => $product->getCategory(),
                'image' => $product->getImage(),
            ]);
        } catch (\Exception $e) {
            $smarty->assign('user_name', $_SESSION['user_name']);
            error_log('Product detail error: ' . $e->getMessage());
        }

        return $smarty->fetch('admin/products.tpl');
    }
}
