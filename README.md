# Laravel E-Commerce with Smarty Integration

A basic e-commerce platform built with Laravel and integrated with Smarty template engine.

## Features

- **Product Listing**: Display all products with images, names, and prices
- **Product Details**: View detailed information about individual products
- **Responsive Design**: Mobile-friendly interface
- **Smarty Template Integration**: Leveraging Smarty for advanced templating
- **Clean Architecture**: Organized MVC structure

## System Requirements

- PHP 8.0 or higher
- MySQL 5.7 or higher
- Composer (for dependency management)
- Apache with mod_rewrite enabled (in XAMPP)

## Installation Steps

### 1. Prerequisites
Ensure you have XAMPP installed and running with PHP 8.0+

### 2. Install Dependencies

```bash
cd c:\xampp\htdocs\yip_remote
composer install
```

### 3. Environment Configuration

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

Edit `.env` with your database credentials:
```
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ecommerce_db
DB_USERNAME=root
DB_PASSWORD=
```

### 4. Create Database

Open phpMyAdmin (http://localhost/phpmyadmin) and create database:

```sql
CREATE DATABASE ecommerce_db;
```

### 5. Configure Apache

Add a virtual host in `C:\xampp\apache\conf\extra\httpd-vhosts.conf`:

```apache
<VirtualHost *:80>
    DocumentRoot "C:\xampp\htdocs\yip_remote\public"
    ServerName localhost
    <Directory "C:\xampp\htdocs\yip_remote\public">
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>
```

Add to `C:\xampp\apache\conf\httpd.conf`:
```
127.0.0.1 localhost
```

### 6. Create .htaccess for Routing

In `public/.htaccess`:

```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteRule ^index\.html$ - [L]
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.php [L]
</IfModule>
```

## Project Structure

```
yip_remote/
├── app/
│   ├── Http/
│   │   └── Controllers/
│   │       ├── HomeController.php
│   │       └── Controller.php
│   ├── Models/
│   │   └── Product.php
│   ├── Providers/
│   │   └── SmartyServiceProvider.php
│   └── Helpers/
│       ├── helpers.php
│       └── View.php
├── bootstrap/
│   └── app.php
├── config/
│   ├── app.php
│   └── smarty.php
├── database/
│   ├── migrations/
│   └── seeders/
├── public/
│   ├── index.php
│   ├── css/
│   │   └── style.css
│   ├── js/
│   └── images/
├── resources/
│   ├── templates/
│   │   ├── home.php
│   │   └── product.php
│   └── templates_c/
├── routes/
│   └── web.php
├── .env
├── composer.json
└── README.md
```

## Available Routes

- `/` - Home page with featured products
- `/product/{id}` - Product detail page

## Usage

### Starting the Development Server

1. Start XAMPP (Apache & MySQL)
2. Open browser and navigate to: `http://localhost/yip_remote/public`

### Adding New Products

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
