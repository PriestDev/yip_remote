{extends file="layout.tpl"}

{block name="title"}Fresh Fruit Market - E-Commerce Store{/block}

{block name="content"}
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
