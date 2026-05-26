# YIP Remote - E-Commerce Platform

A fully functional e-commerce application demonstrating user authentication, shopping cart functionality, and order management with a MySQL database backend.

**Repository**: [GitHub - PriestDev/yip_remote](https://github.com/PriestDev/yip_remote)

## Features

- User authentication with bcrypt password hashing
- Product catalog with detailed product pages
- Shopping cart with quantity selection modal
- Multi-step checkout with order persistence to database
- Order management and confirmation pages
- Automatic inventory management (stock decrement on purchase)
- Role-based access control (user/admin)
- Responsive design for mobile and desktop
- RESTful API endpoints for cart and checkout operations
- Toast notifications for user feedback

## System Requirements

- PHP 8.2 or higher
- MySQL 5.7 or higher
- Apache with mod_rewrite enabled (XAMPP)
- Composer for dependency management

## Installation & Setup

### 1. Clone the Repository
```bash
cd c:\xampp\htdocs
git clone https://github.com/PriestDev/yip_remote.git
cd yip_remote
```

### 2. Install Dependencies
```bash
composer install
```

### 3. Configure Database

Create `.env` file in project root:
```
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ecommerce_db
DB_USERNAME=root
DB_PASSWORD=
```

### 4. Create Database and Tables

In phpMyAdmin or MySQL CLI:
```sql
CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  role ENUM('user', 'admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  price DECIMAL(10, 2) NOT NULL,
  stock INT DEFAULT 0,
  image VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  order_number VARCHAR(50) UNIQUE NOT NULL,
  total DECIMAL(10, 2) NOT NULL,
  status ENUM('pending', 'processing', 'completed', 'cancelled') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

### 5. Add Test Data
```sql
INSERT INTO users (email, password_hash, name, role) VALUES 
('admin@test.com', '$2y$10$...bcrypt_hash...', 'Admin', 'admin'),
('user@test.com', '$2y$10$...bcrypt_hash...', 'Test User', 'user');

INSERT INTO products (name, description, price, stock) VALUES
('Laptop', 'High-performance laptop', 1299.99, 10),
('Smartphone', '5G smartphone', 599.99, 15),
('Tablet', '10-inch tablet', 399.99, 8);
```

### 6. Run the Application
Start Apache and MySQL in XAMPP, then navigate to:
```
http://localhost/yip_remote/public/
```

## Project Structure

```
yip_remote/
├── app/
│   ├── Http/Controllers/          # Application controllers
│   ├── Models/                    # Data models (User, Product, Order)
│   ├── Services/DatabaseService.php
│   ├── Providers/                 # Service providers
│   └── Exceptions/
├── public/
│   ├── index.php                  # Router entry point
│   ├── .htaccess                  # URL rewriting
│   ├── css/style.css              # Styles (1000+ lines, responsive)
│   └── js/
├── resources/
│   ├── templates/                 # Smarty templates (.tpl files)
│   └── templates_c/               # Compiled templates (auto-generated)
├── config/                        # Configuration files
├── .env                           # Environment variables
├── composer.json                  # PHP dependencies
└── README.md
```

## Available Routes

### Public Routes
- `GET /` - Home page with products
- `GET /product/{id}` - Product details
- `GET /login` - Login page
- `POST /auth/login` - Process login
- `GET /register` - Registration page
- `POST /auth/register` - Process registration
- `GET /cart` - Shopping cart
- `GET /checkout` - Checkout page (authenticated)
- `POST /api/checkout/store` - Place order
- `GET /order/{id}` - Order confirmation
- `GET /logout` - Logout

### Admin Routes
- `GET /admin/dashboard` - Admin dashboard
- `GET /admin/products` - Manage products
- `GET /admin/orders` - Manage orders

## Technology Stack

- **Backend**: PHP 8.2 with type hints
- **Database**: MySQL with PDO prepared statements
- **Templating**: Smarty 4.5.6
- **Frontend**: HTML5, CSS3, JavaScript (Fetch API)
- **Security**: Bcrypt password hashing, CSRF validation, SQL injection prevention
- **UI Components**: Toastr.js for notifications

## Testing the Application

1. Start XAMPP (Apache & MySQL)
2. Navigate to `http://localhost/yip_remote/public/`
3. Register a new account
4. Browse products and add items to cart
5. Complete checkout with shipping information
6. View order confirmation
7. Verify order in database via phpMyAdmin

**Test Accounts** (if sample data added):
- Admin: `admin@test.com` / password
- User: `user@test.com` / password

## Security Features

- Bcrypt password hashing
- PDO prepared statements (SQL injection prevention)
- Session-based authentication with role validation
- Input validation and sanitization
- Admin role-based access control

---

**Version**: 1.0.0  
**PHP**: 8.2+  
**MySQL**: 5.7+  
**Last Updated**: May 26, 2026
