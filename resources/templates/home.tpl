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
                <img src="{$base_url}/images/{$product.image}" alt="{$product.name}" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22%3E%3Crect fill=%22%23e0e0e0%22 width=%22200%22 height=%22200%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 font-size=%2214%22 fill=%22%23999%22 text-anchor=%22middle%22 dy=%22.3em%22%3EImage not available%3C/text%3E%3C/svg%3E'">
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
    <style>
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
            justify-content: center;
            align-items: center;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal-content {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 1.5rem;
            color: #333;
        }

        .quantity-group {
            margin-bottom: 2rem;
        }

        .quantity-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: #555;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .quantity-btn {
            background: #3498db;
            color: white;
            border: none;
            width: 36px;
            height: 36px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .quantity-btn:hover {
            background: #2980b9;
        }

        .quantity-input {
            flex: 1;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            text-align: center;
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
        }

        .modal-actions button {
            flex: 1;
            padding: 0.8rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-confirm {
            background: #27ae60;
            color: white;
        }

        .btn-confirm:hover {
            background: #229954;
        }

        .btn-cancel {
            background: #e0e0e0;
            color: #333;
        }

        .btn-cancel:hover {
            background: #d0d0d0;
        }
    </style>

    <div id="quantityModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header" id="modalProductName"></div>
            <div class="quantity-group">
                <label for="quantityInput">Quantity:</label>
                <div class="quantity-controls">
                    <button class="quantity-btn" onclick="decreaseQuantity()">−</button>
                    <input type="number" id="quantityInput" class="quantity-input" value="1" min="1" onchange="validateQuantity()">
                    <button class="quantity-btn" onclick="increaseQuantity()">+</button>
                </div>
            </div>
            <div class="modal-actions">
                <button class="btn-confirm" onclick="confirmAddToCart()">Add to Cart</button>
                <button class="btn-cancel" onclick="closeQuantityModal()">Cancel</button>
            </div>
        </div>
    </div>

    <script>
        const isAuthenticated = {if $user_id}true{else}false{/if};
        const userRole = '{if $user_role}{$user_role}{else}guest{/if}';
        const baseUrl = '{$base_url}';
        let selectedProductId = null;
        let selectedProductName = null;
        
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

            // Store product info and show quantity modal
            selectedProductId = productId;
            selectedProductName = productName;
            document.getElementById('modalProductName').textContent = productName;
            document.getElementById('quantityInput').value = '1';
            document.getElementById('quantityModal').classList.add('active');
        }

        function closeQuantityModal() {
            document.getElementById('quantityModal').classList.remove('active');
            selectedProductId = null;
            selectedProductName = null;
        }

        function increaseQuantity() {
            const input = document.getElementById('quantityInput');
            input.value = parseInt(input.value) + 1;
        }

        function decreaseQuantity() {
            const input = document.getElementById('quantityInput');
            if (parseInt(input.value) > 1) {
                input.value = parseInt(input.value) - 1;
            }
        }

        function validateQuantity() {
            const input = document.getElementById('quantityInput');
            if (parseInt(input.value) < 1) {
                input.value = 1;
            }
        }

        function confirmAddToCart() {
            const quantity = parseInt(document.getElementById('quantityInput').value);
            
            if (quantity < 1) {
                toastr.error('Quantity must be at least 1');
                return;
            }

            // Add to cart via API
            fetch(baseUrl + '/api/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({id: selectedProductId, quantity: quantity})
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success(quantity + ' x ' + selectedProductName + ' added to cart!');
                    closeQuantityModal();
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

        // Close modal when clicking outside
        document.addEventListener('click', function(event) {
            const modal = document.getElementById('quantityModal');
            if (event.target === modal) {
                closeQuantityModal();
            }
        });
{/literal}
    </script>
{/block}
