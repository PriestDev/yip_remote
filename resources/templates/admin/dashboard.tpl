{extends file="../layout.tpl"}

{block name="title"}Admin Dashboard - E-Commerce Store{/block}

{block name="extra_css"}
    <link rel="stylesheet" href="{$base_url}/css/admin.css">
{/block}

{block name="content"}
    <div class="admin-layout">
        <aside class="admin-sidebar">
            <h3>Admin Menu</h3>
            <ul class="sidebar-menu">
                <li><a href="{$base_url}/admin/dashboard" class="active">Dashboard</a></li>
                <li><a href="{$base_url}/admin/orders">Orders</a></li>
                <li><a href="{$base_url}/admin/products">Products</a></li>
                <li><a href="{$base_url}/admin/users">Users</a></li>
                <li><a href="{$base_url}/admin/settings">Settings</a></li>
            </ul>
        </aside>

        <div class="admin-content">
            <div class="dashboard-header">
                <h1>Dashboard</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{if $user_name}{$user_name}{else}Admin{/if}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total Orders</h3>
                    <div class="number">{if $total_orders}{$total_orders}{else}0{/if}</div>
                </div>
                <div class="stat-card">
                    <h3>Total Revenue</h3>
                    <div class="number">${if $total_revenue}{$total_revenue}{else}0{/if}</div>
                </div>
                <div class="stat-card">
                    <h3>Total Customers</h3>
                    <div class="number">{if $total_customers}{$total_customers}{else}0{/if}</div>
                </div>
                <div class="stat-card">
                    <h3>Pending Orders</h3>
                    <div class="number">{if $pending_orders}{$pending_orders}{else}0{/if}</div>
                </div>
            </div>

            <div class="content-section">
                <h2 class="section-title">Recent Activity</h2>
                <p>System is running smoothly. All metrics updated in real-time from the database.</p>
            </div>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
{/block}
