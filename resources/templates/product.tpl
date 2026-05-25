{extends file="layout.tpl"}

{block name="title"}{$product.name} - E-Commerce Store{/block}

{block name="extra_css"}
    <style>
        .product-detail {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin: 2rem 0;
        }

        .product-image {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .product-image img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
        }

        .product-info {
            padding: 1rem;
        }

        .product-info .category {
            color: #666;
            margin-bottom: 1rem;
        }

        .product-info h2 {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #333;
        }

        .product-info .price {
            font-size: 1.8rem;
            font-weight: bold;
            color: #27ae60;
            margin-bottom: 1rem;
        }

        .product-info .description {
            line-height: 1.6;
            color: #555;
            margin-bottom: 1.5rem;
        }

        .product-id {
            color: #999;
            font-size: 0.9rem;
            margin-bottom: 2rem;
        }

        .product-actions {
            display: flex;
            gap: 1rem;
        }

        .btn-add-cart-large {
            background-color: #3498db;
            color: white;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            flex: 1;
        }

        .btn-add-cart-large:hover {
            background-color: #2980b9;
        }

        .btn-back {
            display: inline-block;
            padding: 0.8rem 2rem;
            background-color: #95a5a6;
            color: white;
            border-radius: 8px;
        }

        @media (max-width: 768px) {
            .product-detail {
                grid-template-columns: 1fr;
            }

            .product-actions {
                flex-direction: column;
            }
        }
    </style>
{/block}

{block name="content"}
    <section class="product-detail">
        <div class="product-image">
            <img src="{$base_url}/images/{$product.image}" alt="{$product.name}">
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
{/block}

{block name="extra_scripts"}
    <script>
        function addToCart(productId) {
            alert('Product ' + productId + ' added to cart!');
        }
    </script>
{/block}
