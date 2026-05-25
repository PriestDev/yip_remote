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

            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            $smarty->assign('base_url', $baseUrl);
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
                return $smarty->fetch('admin/product-detail.tpl');
            }

            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            $smarty->assign('base_url', $baseUrl);
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
            $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
            $smarty->assign('base_url', $baseUrl);
            $smarty->assign('user_name', $_SESSION['user_name']);
            $smarty->assign('error', 'Error loading product: ' . $e->getMessage());
            error_log('Product detail error: ' . $e->getMessage());
        }

        return $smarty->fetch('admin/product-detail.tpl');
    }

    public function delete(int $id): void
    {
        // Check authentication
        if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'admin') {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Unauthorized']);
            exit;
        }

        header('Content-Type: application/json');

        try {
            $db = DatabaseService::getInstance();

            // Check if product exists
            $result = $db->query("SELECT id FROM products WHERE id = ?", [$id]);
            if (empty($result)) {
                http_response_code(404);
                echo json_encode(['success' => false, 'message' => 'Product not found']);
                exit;
            }

            // Delete product
            $db->execute("DELETE FROM products WHERE id = ?", [$id]);

            echo json_encode([
                'success' => true,
                'message' => 'Product deleted successfully'
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Error deleting product: ' . $e->getMessage()
            ]);
            error_log('Product deletion error: ' . $e->getMessage());
        }
        exit;
    }

    public function update(int $id): void
    {
        // Check authentication
        if (!isset($_SESSION['user_id']) || $_SESSION['user_role'] !== 'admin') {
            http_response_code(401);
            echo json_encode(['success' => false, 'message' => 'Unauthorized']);
            exit;
        }

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(400);
            echo json_encode(['success' => false, 'message' => 'Invalid request method']);
            exit;
        }

        header('Content-Type: application/json');

        try {
            $db = DatabaseService::getInstance();

            // Check if product exists
            $result = $db->query("SELECT id FROM products WHERE id = ?", [$id]);
            if (empty($result)) {
                http_response_code(404);
                echo json_encode(['success' => false, 'message' => 'Product not found']);
                exit;
            }

            // Get form data
            $name = $_POST['name'] ?? '';
            $price = $_POST['price'] ?? 0;
            $stock = $_POST['stock'] ?? 0;
            $category = $_POST['category'] ?? '';
            $description = $_POST['description'] ?? '';

            // Validation
            if (empty($name)) {
                echo json_encode(['success' => false, 'message' => 'Product name is required']);
                exit;
            }

            if ($price <= 0) {
                echo json_encode(['success' => false, 'message' => 'Price must be greater than 0']);
                exit;
            }

            // Update product
            $db->execute(
                "UPDATE products SET name = ?, price = ?, stock = ?, category = ?, description = ? WHERE id = ?",
                [$name, $price, $stock, $category, $description, $id]
            );

            echo json_encode([
                'success' => true,
                'message' => 'Product updated successfully'
            ]);
        } catch (\Exception $e) {
            http_response_code(500);
            echo json_encode([
                'success' => false,
                'message' => 'Error updating product: ' . $e->getMessage()
            ]);
            error_log('Product update error: ' . $e->getMessage());
        }
        exit;
    }
}
