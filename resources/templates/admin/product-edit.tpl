{extends file="../layout.tpl"}

{block name="title"}Edit Product - Admin Dashboard{/block}

{block name="extra_css"}
    <link rel="stylesheet" href="{$base_url}/css/admin.css">
    <style>
        .edit-container {
            max-width: 600px;
            margin: 2rem auto;
            background: #f8f9fa;
            border-radius: 8px;
            padding: 2rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-group label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #bdc3c7;
            border-radius: 4px;
            font-size: 0.95rem;
            font-family: inherit;
        }
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.95rem;
            font-weight: 600;
            transition: background 0.3s;
        }
        .btn-cancel {
            background: #95a5a6;
            color: white;
            flex: 1;
        }
        .btn-cancel:hover {
            background: #7f8c8d;
        }
        .btn-submit {
            background: #27ae60;
            color: white;
            flex: 2;
        }
        .btn-submit:hover {
            background: #229954;
        }
        .error-message {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 1rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
        }
        .success-message {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 1rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
        }
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .edit-container {
                margin: 1rem;
                padding: 1.5rem;
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
                <h1>Edit Product</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{if $user_name}{$user_name}{else}Admin{/if}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="edit-container">
                {if isset($error)}
                    <div class="error-message">
                        {$error}
                    </div>
                {/if}

                {if isset($product) && $product}
                    <form id="editForm" method="POST" action="{$base_url}/admin/products/{$product.id}/update">
                        <div class="form-group">
                            <label for="name">Product Name *</label>
                            <input type="text" id="name" name="name" value="{$product.name}" required placeholder="e.g., Laptop">
                        </div>

                        <div class="form-group">
                            <label for="category">Category *</label>
                            <input type="text" id="category" name="category" value="{if $product.category}{$product.category}{/if}" required placeholder="e.g., Electronics">
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="price">Price ($) *</label>
                                <input type="number" id="price" name="price" value="{$product.price}" step="0.01" min="0" required placeholder="99.99">
                            </div>

                            <div class="form-group">
                                <label for="stock">Stock Quantity *</label>
                                <input type="number" id="stock" name="stock" value="{$product.stock}" min="0" required placeholder="10">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" placeholder="Product description...">{if $product.description}{$product.description}{/if}</textarea>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-cancel" onclick="window.history.back()">Cancel</button>
                            <button type="submit" class="btn btn-submit">Save Changes</button>
                        </div>
                    </form>
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
        document.getElementById('editForm').addEventListener('submit', function(e) {
            // Basic validation
            const name = document.getElementById('name').value.trim();
            const category = document.getElementById('category').value.trim();
            const price = parseFloat(document.getElementById('price').value);
            const stock = parseInt(document.getElementById('stock').value);

            if (!name) {
                e.preventDefault();
                toastr.error('Product name is required');
                return;
            }

            if (!category) {
                e.preventDefault();
                toastr.error('Category is required');
                return;
            }

            if (isNaN(price) || price <= 0) {
                e.preventDefault();
                toastr.error('Price must be greater than 0');
                return;
            }

            if (isNaN(stock) || stock < 0) {
                e.preventDefault();
                toastr.error('Stock must be 0 or greater');
                return;
            }

            // Show loading state
            toastr.info('Saving product changes...');
        });
    </script>
{/block}
