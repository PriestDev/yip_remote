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
        const isAuthenticated = {if $user_id}true{else}false{/if};
        const userRole = '{if $user_role}{$user_role}{else}guest{/if}';
        const baseUrl = '{$base_url}';
        
{literal}
        function addToCart(productId, productName) {
            // Check if user is authenticated
            if (!isAuthenticated) {
                toastr.warning('Please sign in to add items to cart');
                setTimeout(() => {
                    window.location.href = baseUrl + '/register';
                }, 1500);
                return;
            }

            // Check if user is admin
            if (userRole === 'admin') {
                toastr.error('Administrators cannot add products to cart');
                return;
            }

            // Add to cart via API
            fetch(baseUrl + '/api/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({id: productId})
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success(productName + ' added to cart!');
                } else {
                    if (data.redirect) {
                        toastr.warning(data.message);
                        setTimeout(() => {
                            window.location.href = data.redirect;
                        }, 1500);
                    } else {
                        toastr.error(data.message);
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                toastr.error('Failed to add item to cart');
            });
        }
{/literal}
    </script>
{/block}
