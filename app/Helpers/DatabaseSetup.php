<?php

namespace App\Helpers;

use App\Services\DatabaseService;

class DatabaseSetup
{
    public static function setupDatabase()
    {
        $db = DatabaseService::getInstance()->getConnection();

        try {
            // Create users table
            $db->exec("
                CREATE TABLE IF NOT EXISTS users (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    name VARCHAR(255) NOT NULL,
                    email VARCHAR(255) UNIQUE NOT NULL,
                    password VARCHAR(255) NOT NULL,
                    role ENUM('user', 'admin') DEFAULT 'user',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ");

            // Create products table
            $db->exec("
                CREATE TABLE IF NOT EXISTS products (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    name VARCHAR(255) NOT NULL,
                    description TEXT,
                    category VARCHAR(100),
                    price DECIMAL(10, 2) NOT NULL,
                    image VARCHAR(255),
                    stock INT DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ");

            // Create orders table
            $db->exec("
                CREATE TABLE IF NOT EXISTS orders (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    user_id INT NOT NULL,
                    order_number VARCHAR(50) UNIQUE,
                    total DECIMAL(10, 2) NOT NULL,
                    status ENUM('pending', 'processing', 'completed', 'cancelled') DEFAULT 'pending',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ");

            // Create order_items table
            $db->exec("
                CREATE TABLE IF NOT EXISTS order_items (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    order_id INT NOT NULL,
                    product_id INT NOT NULL,
                    quantity INT NOT NULL,
                    price DECIMAL(10, 2) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
                    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ");

            // Seed initial products if table is empty
            $check = $db->prepare("SELECT COUNT(*) as count FROM products");
            $check->execute();
            $result = $check->fetch(\PDO::FETCH_ASSOC);
            
            if ($result['count'] == 0) {
                $products = [
                    ['Laptop', 'High-performance laptop with Intel Core i7', 'Electronics', 999.99, 'laptop.jpg', 10],
                    ['Smartphone', 'Latest 5G smartphone with advanced camera', 'Electronics', 599.99, 'phone.jpg', 25],
                    ['Tablet', 'Portable tablet for work and entertainment', 'Electronics', 399.99, 'tablet.jpg', 15],
                    ['Wireless Headphones', 'Premium noise-cancelling headphones', 'Accessories', 199.99, 'headphones.jpg', 40],
                    ['USB-C Cable', 'Durable USB-C charging cable 6ft', 'Accessories', 14.99, 'cable.jpg', 100],
                    ['Power Bank', '20000mAh portable power bank', 'Accessories', 39.99, 'powerbank.jpg', 50],
                ];

                foreach ($products as $product) {
                    $stmt = $db->prepare("
                        INSERT INTO products (name, description, category, price, image, stock)
                        VALUES (?, ?, ?, ?, ?, ?)
                    ");
                    $stmt->execute($product);
                }
            }

            // Seed admin user if no admin exists
            $adminCheck = $db->prepare("SELECT COUNT(*) as count FROM users WHERE role = 'admin'");
            $adminCheck->execute();
            $adminResult = $adminCheck->fetch(\PDO::FETCH_ASSOC);
            
            if ($adminResult['count'] == 0) {
                $stmt = $db->prepare("
                    INSERT INTO users (name, email, password, role)
                    VALUES (?, ?, ?, ?)
                ");
                $hashedPassword = password_hash('admin123', PASSWORD_BCRYPT);
                $stmt->execute(['Admin User', 'admin@ecommerce.local', $hashedPassword, 'admin']);
            }

            return true;
        } catch (\Exception $e) {
            error_log('Database setup error: ' . $e->getMessage());
            return false;
        }
    }
}
