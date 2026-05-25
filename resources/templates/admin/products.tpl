{extends file="../layout.tpl"}

{block name="title"}Manage Products - Admin Dashboard{/block}

{block name="extra_css"}
    <link rel="stylesheet" href="{$base_url}/css/admin.css">
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
                <h1>Manage Products</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{if $user_name}{$user_name}{else}Admin{/if}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="content-section">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h2 class="section-title" style="margin: 0;">Products Inventory</h2>
                    <button class="btn-action" onclick="addProduct()" style="padding: 0.6rem 1.2rem; background-color: #27ae60; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 0.95rem;">+ Add New Product</button>
                </div>

                {if count($products) > 0}
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Image</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$products item=product}
                                <tr>
                                    <td>#{$product['id']}</td>
                                    <td>{$product['name']}</td>
                                    <td>{if $product['category']}{$product['category']}{else}-{/if}</td>
                                    <td>${$product['price']|number_format:2}</td>
                                    <td>
                                        <span style="padding: 0.3rem 0.6rem; background-color: {if $product['stock'] > 10}#d1e7dd{else}#fff3cd{/if}; border-radius: 4px; font-size: 0.85rem;">
                                            {$product['stock']} units
                                        </span>
                                    </td>
                                    <td>
                                        {if $product['image']}
                                            <img src="{$base_url}/images/{$product['image']}" alt="{$product['name']}" style="max-height: 40px; max-width: 40px; border-radius: 4px;">
                                        {else}
                                            <span style="color: #999;">-</span>
                                        {/if}
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-small btn-view" onclick="viewProduct({$product['id']})">View</button>
                                            <button class="btn-small btn-edit" onclick="editProduct({$product['id']})">Edit</button>
                                            <button class="btn-small btn-delete" onclick="deleteProduct({$product['id']})">Delete</button>
                                        </div>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                {else}
                    <div class="no-orders">
                        <p>No products found. <a href="#" onclick="addProduct(); return false;" style="color: #3498db; text-decoration: underline;">Add your first product</a></p>
                    </div>
                {/if}
            </div>
        </div>
    </div>

    <!-- Add Product Modal -->
    <div id="addProductModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
        <div style="background: white; border-radius: 8px; padding: 2rem; max-width: 500px; width: 90%; max-height: 90vh; overflow-y: auto;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <h2 style="margin: 0; color: #2c3e50;">Add New Product</h2>
                <button onclick="closeAddProductModal()" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #7f8c8d;">✕</button>
            </div>

            <form id="addProductForm" style="display: flex; flex-direction: column; gap: 1rem;">
                <div>
                    <label for="addName" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: #2c3e50;">Product Name *</label>
                    <input type="text" id="addName" name="name" required placeholder="e.g., Laptop" style="width: 100%; padding: 0.75rem; border: 1px solid #bdc3c7; border-radius: 4px; font-size: 0.95rem;">
                </div>

                <div>
                    <label for="addCategory" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: #2c3e50;">Category *</label>
                    <input type="text" id="addCategory" name="category" required placeholder="e.g., Electronics" style="width: 100%; padding: 0.75rem; border: 1px solid #bdc3c7; border-radius: 4px; font-size: 0.95rem;">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div>
                        <label for="addPrice" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: #2c3e50;">Price ($) *</label>
                        <input type="number" id="addPrice" name="price" required step="0.01" min="0" placeholder="99.99" style="width: 100%; padding: 0.75rem; border: 1px solid #bdc3c7; border-radius: 4px; font-size: 0.95rem;">
                    </div>
                    <div>
                        <label for="addStock" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: #2c3e50;">Stock Quantity *</label>
                        <input type="number" id="addStock" name="stock" required min="0" placeholder="10" style="width: 100%; padding: 0.75rem; border: 1px solid #bdc3c7; border-radius: 4px; font-size: 0.95rem;">
                    </div>
                </div>

                <div>
                    <label for="addDescription" style="display: block; font-weight: 600; margin-bottom: 0.5rem; color: #2c3e50;">Description</label>
                    <textarea id="addDescription" name="description" placeholder="Product description..." style="width: 100%; padding: 0.75rem; border: 1px solid #bdc3c7; border-radius: 4px; font-size: 0.95rem; resize: vertical; min-height: 80px;"></textarea>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <button type="button" onclick="closeAddProductModal()" style="flex: 1; padding: 0.75rem; background: #95a5a6; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 0.95rem; font-weight: 600;">Cancel</button>
                    <button type="submit" style="flex: 2; padding: 0.75rem; background: #27ae60; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 0.95rem; font-weight: 600;">Add Product</button>
                </div>
            </form>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
    <script>
        function openAddProductModal() {
            document.getElementById('addProductModal').style.display = 'flex';
        }

        function closeAddProductModal() {
            document.getElementById('addProductModal').style.display = 'none';
            document.getElementById('addProductForm').reset();
        }

        // Close modal when clicking outside of it
        document.getElementById('addProductModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeAddProductModal();
            }
        });

        // Handle form submission
        document.getElementById('addProductForm').addEventListener('submit', function(e) {
            e.preventDefault();

            // Validation
            const name = document.getElementById('addName').value.trim();
            const category = document.getElementById('addCategory').value.trim();
            const price = parseFloat(document.getElementById('addPrice').value);
            const stock = parseInt(document.getElementById('addStock').value);
            const description = document.getElementById('addDescription').value.trim();

            if (!name) {
                toastr.error('Product name is required');
                return;
            }

            if (!category) {
                toastr.error('Category is required');
                return;
            }

            if (isNaN(price) || price <= 0) {
                toastr.error('Price must be greater than 0');
                return;
            }

            if (isNaN(stock) || stock < 0) {
                toastr.error('Stock must be 0 or greater');
                return;
            }

            // Submit form
            const formData = new FormData();
            formData.append('name', name);
            formData.append('category', category);
            formData.append('price', price);
            formData.append('stock', stock);
            formData.append('description', description);

            fetch('{$base_url}/admin/products/store', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success(data.message);
                    closeAddProductModal();
                    setTimeout(() => location.reload(), 1500);
                } else {
                    toastr.error(data.message);
                }
            })
            .catch(error => {
                toastr.error('Error adding product: ' + error.message);
            });
        });

        function addProduct() {
            openAddProductModal();
        }

        function viewProduct(productId) {
            window.location.href = '{$base_url}/admin/products/' + productId;
        }

        function editProduct(productId) {
            window.location.href = '{$base_url}/admin/products/' + productId + '/edit';
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
                    setTimeout(() => location.reload(), 1500);
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
