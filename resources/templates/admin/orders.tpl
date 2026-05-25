{extends file="../layout.tpl"}

{block name="title"}Manage Orders - Admin Dashboard{/block}

{block name="extra_css"}
    <style>
        .admin-layout {
            display: flex;
            flex-direction: row;
            min-height: calc(100vh - 100px);
        }

        .admin-sidebar {
            background-color: #2c3e50;
            color: white;
            padding: 1.5rem;
            width: 250px;
            min-height: 100%;
            overflow-y: auto;
        }

        .admin-sidebar h3 {
            margin-bottom: 1.5rem;
            font-size: 1.2rem;
        }

        .sidebar-menu {
            list-style: none;
        }

        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }

        .sidebar-menu a {
            display: block;
            padding: 0.8rem 1rem;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background-color: #3498db;
        }

        .admin-content {
            flex: 1;
            padding: 2rem;
            background-color: #f5f5f5;
            overflow-y: auto;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .dashboard-header h1 {
            font-size: 2rem;
            color: #333;
        }

        .user-info {
            background-color: white;
            padding: 0.8rem 1.5rem;
            border-radius: 4px;
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .user-info p {
            margin: 0;
            color: #666;
        }

        .logout-btn {
            background-color: #e74c3c;
            color: white;
            padding: 0.6rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background-color 0.3s;
        }

        .logout-btn:hover {
            background-color: #c0392b;
        }

        .content-section {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            color: #333;
            border-bottom: 2px solid #3498db;
            padding-bottom: 0.5rem;
        }

        .orders-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1rem;
        }

        .orders-table thead {
            background-color: #f0f0f0;
        }

        .orders-table th,
        .orders-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .orders-table th {
            font-weight: 600;
            color: #333;
        }

        .orders-table tbody tr:hover {
            background-color: #f9f9f9;
        }

        .status-badge {
            display: inline-block;
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-processing {
            background-color: #cfe2ff;
            color: #084298;
        }

        .status-completed {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #842029;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-small {
            padding: 0.4rem 0.8rem;
            font-size: 0.85rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-view {
            background-color: #3498db;
            color: white;
        }

        .btn-view:hover {
            background-color: #2980b9;
        }

        .btn-edit {
            background-color: #27ae60;
            color: white;
        }

        .btn-edit:hover {
            background-color: #229954;
        }

        .btn-delete {
            background-color: #e74c3c;
            color: white;
        }

        .btn-delete:hover {
            background-color: #c0392b;
        }

        .no-orders {
            text-align: center;
            padding: 2rem;
            color: #999;
        }

        /* Mobile Responsiveness */
        @media (max-width: 1024px) {
            .admin-layout {
                flex-direction: column;
            }

            .admin-sidebar {
                width: 100%;
                min-height: auto;
            }

            .admin-content {
                padding: 1.5rem;
            }

            .sidebar-menu {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
            }

            .sidebar-menu li {
                margin-bottom: 0;
            }

            .sidebar-menu a {
                padding: 0.6rem 0.8rem;
                font-size: 0.9rem;
            }

            .orders-table {
                font-size: 0.9rem;
            }

            .orders-table th,
            .orders-table td {
                padding: 0.75rem;
            }
        }

        @media (max-width: 768px) {
            .admin-content {
                padding: 1rem;
            }

            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .dashboard-header h1 {
                font-size: 1.5rem;
            }

            .user-info {
                width: 100%;
                justify-content: space-between;
            }

            .content-section {
                padding: 1.5rem;
                overflow-x: auto;
            }

            .section-title {
                font-size: 1.2rem;
            }

            .orders-table {
                min-width: 500px;
                font-size: 0.8rem;
            }

            .orders-table th,
            .orders-table td {
                padding: 0.6rem 0.4rem;
            }

            .action-buttons {
                gap: 0.3rem;
            }

            .btn-small {
                padding: 0.3rem 0.6rem;
                font-size: 0.75rem;
            }

            .status-badge {
                padding: 0.3rem 0.6rem;
                font-size: 0.75rem;
            }
        }

        @media (max-width: 480px) {
            .admin-sidebar {
                padding: 1rem;
            }

            .sidebar-menu a {
                padding: 0.5rem 0.6rem;
                font-size: 0.8rem;
            }

            .admin-content {
                padding: 0.75rem;
            }

            .dashboard-header h1 {
                font-size: 1.3rem;
            }

            .content-section {
                padding: 1rem;
            }

            .orders-table {
                min-width: 100%;
                font-size: 0.75rem;
            }

            .orders-table th,
            .orders-table td {
                padding: 0.5rem 0.3rem;
            }

            .btn-small {
                padding: 0.25rem 0.5rem;
                font-size: 0.7rem;
            }

            .logout-btn {
                width: 100%;
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
    <script>
        function logout() {
            window.location.href = '/logout';
        }

        function viewOrder(orderId) {
            alert('View order ' + orderId + ' - Feature coming soon');
        }

        function editOrder(orderId) {
            alert('Edit order ' + orderId + ' - Feature coming soon');
        }
    </script>
{/block}
