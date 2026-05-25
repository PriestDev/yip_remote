{extends file="../layout.tpl"}

{block name="title"}Product Details - Admin Dashboard{/block}

{block name="extra_css"}
    <link rel="stylesheet" href="{$base_url}/css/admin.css">
    <style>
        .product-detail-container {
            max-width: 800px;
            margin: 2rem auto;
            background: #f8f9fa;
            border-radius: 8px;
            padding: 2rem;
        }
        .product-detail-grid {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }
        .product-image {
            width: 100%;
            height: 300px;
            background: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #e0e0e0;
        }
        .product-image img {
            max-width: 250px;
            max-height: 250px;
            object-fit: contain;
        }
        .product-info {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
        }
        .product-info h2 {
            margin: 0 0 1rem 0;
            color: #2c3e50;
        }
        .product-info-group {
            margin-bottom: 1.5rem;
        }
        .info-label {
            font-weight: 600;
            color: #7f8c8d;
            font-size: 0.9rem;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }
        .info-value {
            color: #2c3e50;
            font-size: 1.1rem;
        }
        .status-badge {
            display: inline-block;
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            font-size: 0.9rem;
            font-weight: 600;
        }
        .status-in-stock {
            background: #d4edda;
            color: #155724;
        }
        .status-low-stock {
            background: #fff3cd;
            color: #856404;
        }
        .status-out-of-stock {
            background: #f8d7da;
            color: #721c24;
        }
        .action-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        .btn-back {
            background: #95a5a6;
            color: white;
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background 0.3s;
        }
        .btn-back:hover {
            background: #7f8c8d;
        }
        .btn-edit {
            background: #3498db;
            color: white;
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background 0.3s;
        }
        .btn-edit:hover {
            background: #2980b9;
        }
        .btn-delete {
            background: #e74c3c;
            color: white;
            padding: 0.7rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background 0.3s;
        }
        .btn-delete:hover {
            background: #c0392b;
        }
        .error-message {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
        }
        @media (max-width: 768px) {
            .product-detail-grid {
                grid-template-columns: 1fr;
            }
            .product-image {
                height: 200px;
            }
        }
    </style>
{/block}

{block name="content"}
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <h3>Admin Menu</h3>
            <ul class="sidebar-menu">
                <li><a href="{$base_url}/admin/dashboard">Dashboard</a></li>
                <li><a href="{$base_url}/admin/orders">Orders</a></li>
                <li><a href="{$base_url}/admin/products" class="active">Products</a></li>
                <li><a href="{$base_url}/admin/users">Users</a></li>
                <li><a href="{$base_url}/admin/settings">Settings</a></li>
            </ul>
        </aside>

        <div class="admin-content">
            <div class="dashboard-header">
                <h1>Product Details</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{if $user_name}{$user_name}{else}Admin{/if}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="product-detail-container">
                {if isset($error)}
                    <div class="error-message">
                        {$error}
                    </div>
                {/if}

                {if isset($product) && $product}
                    <div class="product-detail-grid">
                        <div class="product-image">
                            {if $product.image}
                                <img src="{$base_url}/images/{$product.image}" alt="{$product.name}" onerror="this.src='{$base_url}/images/placeholder.svg'">
                            {else}
                                <p style="color: #95a5a6; font-size: 0.9rem;">No image available</p>
                            {/if}
                        </div>

                        <div class="product-info">
                            <h2>{$product.name}</h2>

                            <div class="product-info-group">
                                <div class="info-label">Category</div>
                                <div class="info-value">{if $product.category}{$product.category}{else}Uncategorized{/if}</div>
                            </div>

                            <div class="product-info-group">
                                <div class="info-label">Price</div>
                                <div class="info-value" style="font-size: 1.3rem; color: #27ae60; font-weight: 600;">${$product.price|number_format:2}</div>
                            </div>

                            <div class="product-info-group">
                                <div class="info-label">Stock Status</div>
                                <div>
                                    {if $product.stock > 10}
                                        <span class="status-badge status-in-stock">In Stock ({$product.stock} units)</span>
                                    {elseif $product.stock > 0}
                                        <span class="status-badge status-low-stock">Low Stock ({$product.stock} units)</span>
                                    {else}
                                        <span class="status-badge status-out-of-stock">Out of Stock</span>
                                    {/if}
                                </div>
                            </div>

                            {if $product.description}
                                <div class="product-info-group">
                                    <div class="info-label">Description</div>
                                    <div class="info-value">{$product.description}</div>
                                </div>
                            {/if}

                            <div class="action-buttons">
                                <button class="btn-back" onclick="window.history.back()">← Back</button>
                                <button class="btn-edit" onclick="editProduct({$product.id})">✎ Edit Product</button>
                                <button class="btn-delete" onclick="deleteProduct({$product.id})">✕ Delete Product</button>
                            </div>
                        </div>
                    </div>
                {else}
                    <div class="error-message">
                        Product not found. It may have been deleted or the ID is invalid.
                    </div>
                {/if}
            </div>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
    <script>
        function editProduct(productId) {
            const newName = prompt('Enter new product name:');
            if (!newName) return;

            const newPrice = prompt('Enter new price:');
            if (!newPrice || isNaN(newPrice) || newPrice <= 0) {
                toastr.error('Invalid price');
                return;
            }

            const newStock = prompt('Enter new stock quantity:');
            if (!newStock || isNaN(newStock) || newStock < 0) {
                toastr.error('Invalid stock quantity');
                return;
            }

            const newCategory = prompt('Enter new category:');

            const formData = new FormData();
            formData.append('name', newName);
            formData.append('price', newPrice);
            formData.append('stock', newStock);
            formData.append('category', newCategory);

            fetch('{$base_url}/admin/products/' + productId + '/update', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success(data.message);
                    setTimeout(() => location.reload(), 1500);
                } else {
                    toastr.error(data.message);
                }
            })
            .catch(error => {
                toastr.error('Error updating product: ' + error.message);
            });
        }

        function deleteProduct(productId) {
            if (!confirm('Are you sure you want to delete this product? This action cannot be undone.')) {
                return;
            }

            fetch('{$base_url}/admin/products/' + productId + '/delete', {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success(data.message);
                    setTimeout(() => window.location.href = '{$base_url}/admin/products', 1500);
                } else {
                    toastr.error(data.message);
                }
            })
            .catch(error => {
                toastr.error('Error deleting product: ' + error.message);
            });
        }
    </script>
{/block}
