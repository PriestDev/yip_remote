# YIP Remote - E-Commerce Platform

A fully functional e-commerce application with user authentication, shopping cart, and order management. Built with PHP 8.2, MySQL, Smarty template engine, and jQuery.

**Repository**: [GitHub - PriestDev/yip_remote](https://github.com/PriestDev/yip_remote)

## Features

### Core Features
- ✅ **User Authentication**: Secure registration and login with bcrypt password hashing
- ✅ **Product Catalog**: Browse electronics and accessories with detailed product pages
- ✅ **Shopping Cart**: Add/remove items with persistent session management
- ✅ **Quantity Selection Modal**: User-friendly modal for selecting product quantities before adding to cart
- ✅ **Checkout System**: Multi-step checkout with shipping information collection
- ✅ **Order Management**: Complete order creation, storage, and confirmation
- ✅ **Inventory Management**: Automatic stock decrement on order placement
- ✅ **Product Images**: Support with fallback placeholder when image unavailable
- ✅ **Order Confirmation**: Professional confirmation page with order details and next steps
- ✅ **Responsive Design**: Mobile-friendly interface with breakpoints at 768px and 1024px
- ✅ **Admin Dashboard**: Product and order management for administrators (locked to admin role)
- ✅ **Session-Based Permissions**: Role-based access control (user/admin)
- ✅ **Dynamic Path Generation**: Folder-agnostic deployment - works in any directory
- ✅ **Toast Notifications**: User feedback with Toastr.js

### Technical Features
- Clean MVC architecture with namespaced controllers and models
- PDO prepared statements for SQL injection prevention
- Smarty 4.5.6 template engine with custom modifiers
- Type hints on all PHP 8.2 methods and properties
- RESTful API endpoints for cart and checkout operations
- Professional Git workflow with meaningful commits

## System Requirements

- **PHP**: 8.2 or higher
- **MySQL**: 5.7 or higher
- **Apache**: With mod_rewrite enabled (included in XAMPP)
- **Node/npm**: Optional (not required for core functionality)

## Installation

### 1. Prerequisites
- XAMPP installed and running (PHP 8.2+)
- MySQL service active in XAMPP
- Apache service active in XAMPP

### 2. Clone/Extract Project
```bash
# Extract to XAMPP htdocs or clone from GitHub
cd C:\xampp\htdocs
git clone https://github.com/PriestDev/yip_remote.git
cd yip_remote
```

### 3. Install Dependencies
```bash
composer install
```

### 4. Database Setup

Create the database and tables using phpMyAdmin or MySQL CLI:

```sql
CREATE DATABASE ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_db;

-- Users table
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  role ENUM('user', 'admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
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

-- Orders table
CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  order_number VARCHAR(50) UNIQUE NOT NULL,
  total DECIMAL(10, 2) NOT NULL,
  status ENUM('pending', 'processing', 'completed', 'cancelled') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Order items table
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

### 5. Environment Variables
Create `.env` file in project root:
```
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ecommerce_db
DB_USERNAME=root
DB_PASSWORD=
```

### 6. Add Sample Data (Optional)
```sql
-- Add test admin user
INSERT INTO users (email, password_hash, name, role) VALUES 
('admin@example.com', '$2y$10$...', 'Admin User', 'admin'),
('customer@example.com', '$2y$10$...', 'Test Customer', 'user');

-- Add sample products
INSERT INTO products (name, description, category, price, stock, image) VALUES
('Laptop', 'High-performance laptop', 'Electronics', 1299.99, 10, 'laptop.jpg'),
('Smartphone', '5G smartphone', 'Electronics', 599.99, 15, 'smartphone.jpg'),
('Tablet', '10-inch tablet', 'Electronics', 399.99, 8, 'tablet.jpg'),
('Wireless Headphones', 'Noise-cancelling headphones', 'Accessories', 199.99, 20, 'headphones.jpg'),
('USB-C Cable', 'High-speed USB-C cable', 'Accessories', 14.99, 50, 'usb-cable.jpg'),
('Power Bank', '20000mAh power bank', 'Accessories', 39.99, 25, 'powerbank.jpg'),
('Gaming Monitor', '144Hz gaming monitor', 'Electronics', 349.99, 5, 'monitor.jpg');
```

## Project Structure

```
yip_remote/
├── app/
│   ├── Http/
│   │   └── Controllers/
│   │       ├── HomeController.php
│   │       ├── AuthController.php
│   │       ├── CartController.php
│   │       ├── CheckoutController.php
│   │       └── Admin/
│   │           ├── ProductController.php
│   │           ├── OrderController.php
│   │           └── UserController.php
│   ├── Models/
│   │   ├── User.php
│   │   ├── Product.php
│   │   └── Order.php
│   ├── Services/
│   │   └── DatabaseService.php (PDO singleton)
│   ├── Providers/
│   │   ├── SmartyServiceProvider.php
│   │   └── DatabaseServiceProvider.php
│   └── Exceptions/
│       └── Handler.php
├── public/
│   ├── index.php (Router)
│   ├── .htaccess (URL rewriting)
│   ├── css/
│   │   └── style.css (1000+ lines, responsive)
│   ├── js/
│   │   ├── admin.js
│   │   └── app.js
│   └── images/
│       ├── laptop.jpg
│       ├── smartphone.jpg
│       ├── ... (product images)
├── resources/
│   ├── templates/
│   │   ├── layout.tpl (Base template)
│   │   ├── home.tpl
│   │   ├── product.tpl
│   │   ├── cart.tpl
│   │   ├── checkout.tpl
│   │   ├── order-confirmation.tpl
│   │   ├── login.tpl
│   │   ├── register.tpl
│   │   └── admin/
│   │       ├── dashboard.tpl
│   │       ├── products.tpl
│   │       └── orders.tpl
│   └── templates_c/ (Compiled Smarty templates)
├── config/
│   ├── app.php
│   └── database.php
├── .env (Environment variables)
├── composer.json
└── README.md
```

## Available Routes

### Public Routes
- `GET /` - Home page with featured products
- `GET /product/{id}` - Product detail page
- `GET /login` - Login page
- `POST /auth/login` - Handle login
- `GET /register` - Registration page
- `POST /auth/register` - Handle registration
- `GET /cart` - View shopping cart
- `GET /checkout` - Checkout page (authenticated only)
- `POST /api/checkout/store` - Create and store order
- `GET /order/{id}` - Order confirmation page

### API Routes
- `POST /api/cart/add` - Add item to cart (authenticated)
- `POST /api/cart/remove` - Remove item from cart
- `POST /api/checkout/store` - Place order

### Admin Routes
- `GET /admin/dashboard` - Admin dashboard
- `GET /admin/products` - Manage products
- `GET /admin/products/{id}` - Edit product
- `POST /admin/products/store` - Create/update product
- `DELETE /admin/products/{id}` - Delete product
- `GET /admin/orders` - View all orders
- `GET /admin/orders/{id}` - Order details

### Other Routes
- `GET /logout` - Destroy session and logout

## Getting Started

### 1. Start XAMPP Services
- Start Apache (web server)
- Start MySQL (database server)

### 2. Access the Application
Open browser and navigate to:
```
http://localhost/yip_remote/public/
```

### 3. Test Accounts
**Admin Account:**
- Email: `admin@example.com`
- Password: `password` (update after setup)

**Customer Account:**
- Email: `customer@example.com`
- Password: `password` (update after setup)

### 4. Complete a Test Purchase
1. Register or login as customer
2. Browse products on home page
3. Click "Add to Cart" on any product
4. Select quantity in modal
5. Go to cart and click "Proceed to Checkout"
6. Fill in shipping information
7. Check terms & conditions
8. Click "Place Order"
9. View order confirmation with order details

## Deployment Notes

### Portable Deployment
The application uses dynamic path detection with `dirname($_SERVER['SCRIPT_NAME'])`, making it folder-agnostic.

**To deploy to a different folder:**
1. Rename the folder (e.g., `my_shop`)
2. Update `public/.htaccess` RewriteBase:
   ```apache
   RewriteBase /my_shop/public/
   ```
3. Update database configuration in `.env`
4. Clear template cache: `rm -r resources/templates_c/*`
5. Access at: `http://localhost/my_shop/public/`

All other paths automatically adjust at runtime.

## Key Technologies

- **Backend**: PHP 8.2 with type hints
- **Database**: MySQL with PDO prepared statements
- **Templating**: Smarty 4.5.6 with custom modifiers
- **Frontend**: HTML5, CSS3, JavaScript (ES6)
- **AJAX**: Fetch API for async cart/checkout operations
- **UI Components**: Toastr.js for toast notifications
- **Package Manager**: Composer

## Security Features

- ✅ Bcrypt password hashing for user authentication
- ✅ PDO prepared statements to prevent SQL injection
- ✅ Session-based authentication with role validation
- ✅ CSRF protection via form validation
- ✅ HTTP-only session cookies
- ✅ Input validation on checkout form
- ✅ Admin role-based access control

## Testing the Application

### Manual Testing Checklist
- [ ] Register new account
- [ ] Login with credentials
- [ ] Add product to cart (authenticated)
- [ ] Try adding to cart without login (redirects to register)
- [ ] Try adding to cart as admin (shows error)
- [ ] Modify cart quantity
- [ ] Proceed to checkout
- [ ] Place order with valid data
- [ ] View order confirmation
- [ ] Check database for order records
- [ ] Verify inventory decremented
- [ ] Logout from account
- [ ] Login as admin to view orders

## Database Verification

After placing an order, verify data in phpMyAdmin:

```sql
-- Check order was created
SELECT * FROM orders WHERE user_id = 1;

-- Check order items
SELECT oi.*, p.name FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 1;

-- Verify stock was decremented
SELECT id, name, stock FROM products WHERE id = 1;
```

## Troubleshooting

### 404 Errors on Routes
- Check Apache mod_rewrite is enabled
- Verify `.htaccess` RewriteBase matches your folder path
- Clear browser cache

### Template Not Found Errors
- Clear `resources/templates_c/` directory
- Verify template files exist in `resources/templates/`

### Database Connection Failed
- Verify MySQL is running in XAMPP
- Check `.env` credentials match your setup
- Ensure `ecommerce_db` database exists

### CSS/JS Not Loading
- Check browser console for 404 errors
- Verify `{$base_url}` is rendering correctly in template
- Clear browser cache

## Code Style & Standards

- PSR-12 compliant code formatting
- Type hints on all properties and method parameters
- Meaningful variable and function names
- Inline comments for complex logic
- Smarty {literal}{/literal} blocks for mixed PHP/JavaScript

## Future Features

- [ ] User account dashboard
- [ ] Order tracking
- [ ] Product reviews and ratings
- [ ] Wishlist functionality
- [ ] Payment gateway integration
- [ ] Email notifications
- [ ] Coupon/discount codes
- [ ] Product search and filtering
- [ ] Category browsing
- [ ] Advanced admin analytics

## Contributing

This project is maintained by PriestDev. For issues or suggestions, please open an issue on the [GitHub repository](https://github.com/PriestDev/yip_remote).

## License

MIT License - See LICENSE file for details

## Support

For questions or issues:
- 📧 Email: support@estore.com
- 📞 Phone: 1-800-ESTORE-1
- 🕐 Hours: Monday - Friday, 9 AM - 6 PM EST
- 💻 GitHub: [PriestDev/yip_remote](https://github.com/PriestDev/yip_remote)

---

**Last Updated**: May 26, 2026
**Version**: 1.0.0 (Production Ready)
**PHP Version**: 8.2+
**MySQL Version**: 5.7+

Edit `app/Models/Product.php` and add to the `all()` method:

```php
new self(4, 'Product 4', 'Description', 59.99, 'product4.jpg'),
```

### Creating New Controllers

Create a new file in `app/Http/Controllers/`:

```php
<?php
namespace App\Http\Controllers;

class YourController extends Controller
{
    public function action()
    {
        return view('your_view', ['data' => 'value']);
    }
}
```

### Creating New Views

Create a new PHP file in `resources/templates/`:

```php
<!DOCTYPE html>
<html>
<head><title>Your Page</title></head>
<body>
    <h1><?php echo $variable; ?></h1>
</body>
</html>
```

## Smarty Integration

The project includes Smarty integration through `SmartyServiceProvider`. To use Smarty templates:

### Configuration

Smarty is configured in `config/smarty.php` with:
- Template directory: `resources/templates`
- Compile directory: `resources/templates_c`
- Caching enabled with lifetime from `.env`

### Using Smarty Templates

In controllers, return Smarty-compiled views:

```php
$smarty = SmartyServiceProvider::getSmarty();
$smarty->assign('products', $products);
return $smarty->fetch('products.tpl');
```

## Database Migrations

Create migrations in `database/migrations/` and run them:

```bash
php artisan migrate
```

Example migration for products table:

```php
<?php
// database/migrations/2024_create_products_table.php
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

MIT License - feel free to use for educational or commercial purposes.

## Support

For issues or questions, please create an issue in the project repository.

---

**Note**: This is a basic setup for learning purposes. For production use, implement proper error handling, validation, and security measures.
