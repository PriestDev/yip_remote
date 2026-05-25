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
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
    <script>
        function addProduct() {
            toastr.info('Add product feature coming soon');
        }

        function viewProduct(productId) {
            toastr.info('View product ' + productId + ' - Feature coming soon');
        }

        function editProduct(productId) {
            toastr.info('Edit product ' + productId + ' - Feature coming soon');
        }

        function deleteProduct(productId) {
            if (confirm('Are you sure you want to delete this product?')) {
                toastr.warning('Delete product ' + productId + ' - Feature coming soon');
            }
        }
    </script>
{/block}
