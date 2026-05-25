# Quick Start Guide

## Step 1: Install Dependencies
```bash
cd c:\xampp\htdocs\yip_remote
composer install
```

## Step 2: Configure Database
1. Open `.env` file
2. Set your MySQL credentials
3. Create database `ecommerce_db` in phpMyAdmin

## Step 3: Start XAMPP
- Start Apache and MySQL services

## Step 4: Access the Site
Open `http://localhost/yip_remote/public` in your browser

## Troubleshooting

### Composer Not Found
Download Composer from https://getcomposer.org and install globally

### 404 Errors
Ensure Apache mod_rewrite is enabled in `C:\xampp\apache\conf\httpd.conf`

### Database Connection Error
- Check MySQL is running
- Verify credentials in `.env`
- Ensure database exists

### Permission Issues
Right-click Command Prompt → Run as Administrator before running composer commands

## Next Steps
1. Explore the project structure
2. Modify templates in `resources/templates/`
3. Create new controllers in `app/Http/Controllers/`
4. Add database migrations in `database/migrations/`
5. Integrate a database library (PDO/Eloquent)
