<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - E-Commerce Store</title>
    <link rel="stylesheet" href="/yip_remote/public/css/style.css">
    <style>
        .cart-container {
            max-width: 900px;
            margin: 2rem auto;
            padding: 2rem;
        }
        
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 2rem;
        }
        
        .cart-table th {
            background-color: #333;
            color: white;
            padding: 1rem;
            text-align: left;
            border: 1px solid #ddd;
        }
        
        .cart-table td {
            padding: 1rem;
            border: 1px solid #ddd;
            text-align: left;
        }
        
        .cart-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .cart-summary {
            text-align: right;
            margin-bottom: 2rem;
        }
        
        .cart-total {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 2rem;
        }
        
        .btn-checkout {
            background-color: #27ae60;
            color: white;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            margin-right: 1rem;
        }
        
        .btn-checkout:hover {
            background-color: #229954;
        }
        
        .btn-continue {
            background-color: #3498db;
            color: white;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-continue:hover {
            background-color: #2980b9;
        }
        
        .empty-cart {
            text-align: center;
            padding: 3rem;
        }
        
        .empty-cart h2 {
            color: #666;
            margin-bottom: 1rem;
        }
        
        .empty-cart p {
            color: #999;
            margin-bottom: 2rem;
        }
        
        @media (max-width: 768px) {
            .cart-table {
                font-size: 0.9rem;
            }
            
            .cart-table th,
            .cart-table td {
                padding: 0.5rem;
            }
        }
    </style>
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

    <main class="cart-container">
        <h1>Shopping Cart</h1>

        {if $itemCount > 0}
            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$cartItems item=item}
                    <tr>
                        <td><strong>{$item.name}</strong></td>
                        <td>${$item.price}</td>
                        <td>{$item.quantity}</td>
                        <td>${$item.subtotal}</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>

            <div class="cart-summary">
                <div class="cart-total">
                    Total: ${$total}
                </div>
                <button class="btn-checkout">Proceed to Checkout</button>
                <a href="/" class="btn-continue">Continue Shopping</a>
            </div>
        {else}
            <div class="empty-cart">
                <h2>Your cart is empty</h2>
                <p>You haven't added any items to your cart yet.</p>
                <a href="/" class="btn-continue">Start Shopping</a>
            </div>
        {/if}
    </main>

    <footer>
        <p>&copy; 2024 E-Commerce Store. All rights reserved.</p>
    </footer>

    <script>
        // Note: In a real application, you would handle cart operations with proper backend integration
        // This is a basic implementation using session storage
    </script>
</body>
</html>
