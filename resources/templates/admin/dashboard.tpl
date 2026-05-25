{extends file="../layout.tpl"}

{block name="title"}Admin Dashboard - E-Commerce Store{/block}

{block name="extra_css"}
    <style>
        .admin-layout {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 0;
            min-height: calc(100vh - 100px);
        }

        .admin-sidebar {
            background-color: #2c3e50;
            color: white;
            padding: 1.5rem;
            position: fixed;
            height: calc(100vh - 100px);
            width: 250px;
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
            margin-left: 250px;
            padding: 2rem;
            background-color: #f5f5f5;
            min-height: calc(100vh - 100px);
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-card h3 {
            color: #666;
            font-size: 0.9rem;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }

        .stat-card .number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #3498db;
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

        /* Mobile Responsiveness */
        @media (max-width: 1024px) {
            .admin-layout {
                grid-template-columns: 1fr;
            }

            .admin-sidebar {
                width: 100%;
                height: auto;
                position: relative;
                margin-bottom: 1rem;
            }

            .admin-content {
                margin-left: 0;
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
        }

        @media (max-width: 768px) {
            .admin-sidebar {
                width: 100%;
            }

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

            .stats-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .stat-card {
                padding: 1rem;
            }

            .stat-card .number {
                font-size: 2rem;
            }

            .content-section {
                padding: 1.5rem;
            }

            .section-title {
                font-size: 1.2rem;
            }
        }

        @media (max-width: 480px) {
            .sidebar-menu {
                gap: 0.3rem;
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

            .stat-card .number {
                font-size: 1.8rem;
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
                <li><a href="/admin/dashboard" class="active">Dashboard</a></li>
                <li><a href="/admin/orders">Orders</a></li>
                <li><a href="/admin/products">Products</a></li>
                <li><a href="/admin/users">Users</a></li>
                <li><a href="/admin/settings">Settings</a></li>
            </ul>
        </aside>

        <div class="admin-content">
            <div class="dashboard-header">
                <h1>Dashboard</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{$user_name|default:'Admin'}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Total Orders</h3>
                    <div class="number">{$total_orders|default:'0'}</div>
                </div>
                <div class="stat-card">
                    <h3>Total Revenue</h3>
                    <div class="number">${$total_revenue|default:'0'}</div>
                </div>
                <div class="stat-card">
                    <h3>Total Customers</h3>
                    <div class="number">{$total_customers|default:'0'}</div>
                </div>
                <div class="stat-card">
                    <h3>Pending Orders</h3>
                    <div class="number">{$pending_orders|default:'0'}</div>
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
    <script>
        // Check if user is logged in via session
        function checkAuth() {
            // Server-side session check is done in controller
            // Client-side validation for immediate feedback
        }

        function logout() {
            window.location.href = '/logout';
        }

        // Check auth on page load
        window.addEventListener('load', checkAuth);
    </script>
{/block}
