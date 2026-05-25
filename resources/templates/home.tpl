<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Commerce Store - Smarty Template</title>
    <link rel="stylesheet" href="/yip_remote/public/css/style.css">
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="container">
                <h1 class="logo">E-Store</h1>
                <ul class="nav-links">
                    <li><a href="/">Home</a></li>
                    <li><a href="/products">Products</a></li>
                    <li><a href="/cart">Cart</a></li>
                    <li><a href="/about">About</a></li>
                </ul>
            </div>
        </nav>
    </header>

    <main class="container">
        <section class="hero">
            <h2>Welcome to Fresh Fruit Market</h2>
            <p>Discover premium quality fresh fruits at competitive prices - Powered by Smarty Templates</p>
        </section>

        <section class="products">
            <h3>Featured Fruits</h3>
            <div class="product-grid">
                {foreach from=$products item=product}
                <div class="product-card">
                    <img src="/yip_remote/public/images/{$product.image}" alt="{$product.name}">
                    <p class="category">{$product.category}</p>
                    <h4>{$product.name}</h4>
                    <p class="price">${$product.price}</p>
                    <a href="/yip_remote/public/product/{$product.id}" class="btn-product-link">View Details</a>
                    <button class="btn-add-cart" onclick="addToCart({$product.id}, '{$product.name}')">Add to Cart</button>
                </div>
                {/foreach}
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2024 E-Commerce Store. All rights reserved.</p>
    </footer>

    <script>
        function addToCart(productId, productName) {
            fetch('/yip_remote/public/api/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({literal}{ {id: productId}{/literal})
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(productName + ' added to cart!');
                } else {
                    alert('Error: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Failed to add item to cart');
            });
        }
    </script>
</body>
</html>
