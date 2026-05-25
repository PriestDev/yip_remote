<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{$product.name} - E-Commerce Store</title>
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
                </ul>
            </div>
        </nav>
    </header>

    <main class="container">
        <section class="product-detail">
            <div class="product-image">
                <img src="/yip_remote/public/images/{$product.image}" alt="{$product.name}">
            </div>
            <div class="product-info">
                <p class="category"><strong>Category:</strong> {$product.category}</p>
                <h2>{$product.name}</h2>
                <p class="price">${$product.price}</p>
                <p class="description">{$product.description}</p>
                <p class="product-id"><strong>Product ID:</strong> {$product.id}</p>
                <div class="product-actions">
                    <button class="btn-add-cart-large" onclick="addToCart({$product.id})">Add to Cart</button>
                    <a href="/yip_remote/public/" class="btn-back">Back to Home</a>
                </div>
            </div>
        </section>

        <section class="product-reviews">
            <h3>Customer Reviews</h3>
            <p>Reviews will be displayed here</p>
        </section>
    </main>

    <footer>
        <p>&copy; 2024 E-Commerce Store. All rights reserved.</p>
    </footer>

    <script>
        function addToCart(productId) {
            alert('Product ' + productId + ' added to cart!');
        }
    </script>

    <style>
        .btn-back {
            display: inline-block;
            padding: 0.7rem 1.5rem;
            background-color: #95a5a6;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .btn-back:hover {
            background-color: #7f8c8d;
        }
        .product-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        .product-reviews {
            margin-top: 3rem;
            padding: 2rem;
            background: #f9f9f9;
            border-radius: 8px;
        }
    </style>
</body>
</html>
