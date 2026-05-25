{extends file="layout.tpl"}

{block name="title"}Electronics Store - Premium Tech Products{/block}

{block name="content"}
    <section class="hero">
        <h2>Welcome to Our Electronics Store</h2>
        <p>Discover premium quality tech products at competitive prices - Powered by Database-Driven Architecture</p>
    </section>

    <section class="products">
        <h3>Featured Products</h3>
        <div class="product-grid">
            {foreach from=$products item=product}
            <div class="product-card">
                <img src="{$base_url}/images/{$product.image}" alt="{$product.name}">
                <p class="category">{$product.category}</p>
                <h4>{$product.name}</h4>
                <p class="price">${$product.price}</p>
                <a href="{$base_url}/product/{$product.id}" class="btn-product-link">View Details</a>
                <button class="btn-add-cart" onclick="addToCart({$product.id}, '{$product.name}')">Add to Cart</button>
            </div>
            {/foreach}
        </div>
    </section>
{/block}

{block name="extra_scripts"}
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
{/block}
