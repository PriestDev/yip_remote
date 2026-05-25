{extends file="../layout.tpl"}

{block name="title"}Manage Orders - Admin Dashboard{/block}

{block name="extra_css"}
    <link rel="stylesheet" href="{$base_url}/css/admin.css">
{/block}

{block name="content"}
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <h3>Admin Menu</h3>
            <ul class="sidebar-menu">
                <li><a href="{$base_url}/admin/dashboard">Dashboard</a></li>
                <li><a href="{$base_url}/admin/orders" class="active">Orders</a></li>
                <li><a href="{$base_url}/admin/products">Products</a></li>
                <li><a href="{$base_url}/admin/users">Users</a></li>
                <li><a href="{$base_url}/admin/settings">Settings</a></li>
            </ul>
        </aside>

        <div class="admin-content">
            <div class="dashboard-header">
                <h1>Manage Orders</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{if $user_name}{$user_name}{else}Admin{/if}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="content-section">
                <h2 class="section-title">Orders List</h2>
                {if count($orders) > 0}
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$orders item=order}
                                <tr>
                                    <td>#{$order['order_number']}</td>
                                    <td>{if $order['customer_name']}{$order['customer_name']}{else}Guest{/if}</td>
                                    <td>${$order['total']|number_format:2}</td>
                                    <td><span class="status-badge status-{$order['status']}">{ucfirst($order['status'])}</span></td>
                                    <td>{$order['created_at']|date_format:"%Y-%m-%d"}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-small btn-view" onclick="viewOrder({$order['id']})">View</button>
                                            <button class="btn-small btn-edit" onclick="editOrder({$order['id']})">Edit</button>
                                        </div>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                {else}
                    <div class="no-orders">
                        <p>No orders found. System is ready for first orders.</p>
                    </div>
                {/if}
            </div>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
{/block}
