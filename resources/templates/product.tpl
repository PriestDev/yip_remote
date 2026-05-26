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
            <img src="{$base_url}/images/{$product.image}" alt="{$product.name}" onerror="this.src='data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 width=%22400%22 height=%22400%22%3E%3Crect fill=%22%23e0e0e0%22 width=%22400%22 height=%22400%22/%3E%3Ctext x=%2250%25%22 y=%2250%25%22 font-size=%2220%22 fill=%22%23999%22 text-anchor=%22middle%22 dy=%22.3em%22%3EImage not available%3C/text%3E%3C/svg%3E'">
        </div>
        <div class="product-info">
            <p class="category"><strong>Category:</strong> {$product.category}</p>
            <h2>{$product.name}</h2>
            <p class="price">${$product.price}</p>
            <p class="description">{$product.description}</p>
            <p class="product-id"><strong>Product ID:</strong> {$product.id}</p>
            <div class="product-actions">
                <button class="btn-add-cart-large" onclick="addToCart({$product.id}, '{$product.name}')">Add to Cart</button>
                <a href="{$base_url}/" class="btn-back">Back to Home</a>
            </div>
        </div>
    </section>

    <section class="product-reviews">
        <h3>Customer Reviews</h3>
        <p>Reviews will be displayed here</p>
    </section>
{/block}

{block name="extra_scripts"}
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
