{extends file="../layout.tpl"}

{block name="title"}Admin Settings - Admin Dashboard{/block}

{block name="extra_css"}
    <link rel="stylesheet" href="{$base_url}/css/admin.css">
    <style>
        .settings-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .settings-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .settings-card h3 {
            margin-top: 0;
            color: #333;
            font-size: 1.1rem;
            border-bottom: 2px solid #3498db;
            padding-bottom: 0.5rem;
        }

        .settings-card .stat {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.8rem 0;
            border-bottom: 1px solid #eee;
        }

        .settings-card .stat:last-child {
            border-bottom: none;
        }

        .settings-card .stat-label {
            color: #666;
            font-weight: 500;
        }

        .settings-card .stat-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #3498db;
        }

        .settings-form-group {
            margin-bottom: 1.5rem;
        }

        .settings-form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 500;
        }

        .settings-form-group input,
        .settings-form-group select,
        .settings-form-group textarea {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 0.95rem;
            box-sizing: border-box;
        }

        .settings-form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .settings-button {
            padding: 0.7rem 1.5rem;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background-color 0.3s;
        }

        .settings-button:hover {
            background-color: #2980b9;
        }

        .settings-button.danger {
            background-color: #e74c3c;
        }

        .settings-button.danger:hover {
            background-color: #c0392b;
        }

        @media (max-width: 768px) {
            .settings-grid {
                grid-template-columns: 1fr;
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
                <li><a href="{$base_url}/admin/products">Products</a></li>
                <li><a href="{$base_url}/admin/users">Users</a></li>
                <li><a href="{$base_url}/admin/settings" class="active">Settings</a></li>
            </ul>
        </aside>

        <div class="admin-content">
            <div class="dashboard-header">
                <h1>Admin Settings</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{if $user_name}{$user_name}{else}Admin{/if}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <!-- System Overview -->
            <h2 class="section-title" style="margin-top: 2rem; margin-bottom: 1.5rem;">System Overview</h2>
            <div class="settings-grid">
                <div class="settings-card">
                    <h3>📊 Statistics</h3>
                    <div class="stat">
                        <span class="stat-label">Total Orders</span>
                        <span class="stat-value">{$stats['total_orders']}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Total Products</span>
                        <span class="stat-value">{$stats['total_products']}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Total Users</span>
                        <span class="stat-value">{$stats['total_users']}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Admin Users</span>
                        <span class="stat-value">{$stats['admin_users']}</span>
                    </div>
                </div>

                <div class="settings-card">
                    <h3>🔧 System Information</h3>
                    <div class="stat">
                        <span class="stat-label">PHP Version</span>
                        <span class="stat-value" style="font-size: 1rem; color: #666;">{$system_info['php_version']}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Current Date</span>
                        <span class="stat-value" style="font-size: 0.95rem; color: #666;">{$system_info['current_date']}</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">Database</span>
                        <span class="stat-value" style="font-size: 0.95rem; color: #666;">{$system_info['database']}</span>
                    </div>
                </div>
            </div>

            <!-- Store Settings -->
            <div class="content-section" style="margin-top: 2rem;">
                <h2 class="section-title">Store Settings</h2>
                <form onsubmit="handleSettingsSave(event)">
                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.5rem;">
                        <div class="settings-form-group">
                            <label for="store_name">Store Name</label>
                            <input type="text" id="store_name" name="store_name" value="E-Commerce Store" placeholder="Enter store name">
                        </div>
                        <div class="settings-form-group">
                            <label for="store_email">Store Email</label>
                            <input type="email" id="store_email" name="store_email" value="admin@ecommerce.local" placeholder="admin@example.com">
                        </div>
                    </div>

                    <div class="settings-form-group">
                        <label for="store_description">Store Description</label>
                        <textarea id="store_description" name="store_description" placeholder="Enter store description">Premium quality tech products at competitive prices.</textarea>
                    </div>

                    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.5rem;">
                        <div class="settings-form-group">
                            <label for="currency">Currency</label>
                            <select id="currency" name="currency">
                                <option value="USD" selected>USD ($)</option>
                                <option value="EUR">EUR (€)</option>
                                <option value="GBP">GBP (£)</option>
                                <option value="JPY">JPY (¥)</option>
                            </select>
                        </div>
                        <div class="settings-form-group">
                            <label for="timezone">Timezone</label>
                            <select id="timezone" name="timezone">
                                <option value="UTC" selected>UTC</option>
                                <option value="EST">Eastern (EST)</option>
                                <option value="CST">Central (CST)</option>
                                <option value="MST">Mountain (MST)</option>
                                <option value="PST">Pacific (PST)</option>
                            </select>
                        </div>
                    </div>

                    <div style="margin-top: 2rem; display: flex; gap: 1rem;">
                        <button type="submit" class="settings-button">💾 Save Settings</button>
                        <button type="button" class="settings-button danger" onclick="handleResetSettings()">🔄 Reset to Defaults</button>
                    </div>
                </form>
            </div>

            <!-- Security Settings -->
            <div class="content-section" style="margin-top: 2rem; margin-bottom: 2rem;">
                <h2 class="section-title">Security & Backup</h2>
                <div style="display: flex; flex-direction: column; gap: 1rem;">
                    <button class="settings-button" onclick="handleDatabaseBackup()" style="text-align: left; padding: 1rem;">
                        💾 Backup Database
                        <div style="font-size: 0.85rem; color: #ccc; margin-top: 0.3rem;">Create a backup of your database</div>
                    </button>
                    <button class="settings-button" onclick="handleClearCache()" style="text-align: left; padding: 1rem;">
                        🗑️ Clear Cache
                        <div style="font-size: 0.85rem; color: #ccc; margin-top: 0.3rem;">Clear template cache and compiled files</div>
                    </button>
                    <button class="settings-button danger" onclick="handleRestartSession()" style="text-align: left; padding: 1rem;">
                        🔐 Force Logout All Users
                        <div style="font-size: 0.85rem; color: #ccc; margin-top: 0.3rem;">Force all users to re-login (for security)</div>
                    </button>
                </div>
            </div>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
    <script>
        function handleSettingsSave(event) {
            event.preventDefault();
            const storeName = document.getElementById('store_name').value;
            toastr.success('Settings saved! Store name updated to: ' + storeName);
        }

        function handleResetSettings() {
            if (confirm('Are you sure you want to reset all settings to defaults?')) {
                document.getElementById('store_name').value = 'E-Commerce Store';
                document.getElementById('store_email').value = 'admin@ecommerce.local';
                document.getElementById('store_description').value = 'Premium quality tech products at competitive prices.';
                document.getElementById('currency').value = 'USD';
                document.getElementById('timezone').value = 'UTC';
                toastr.warning('Settings reset to defaults');
            }
        }

        function handleDatabaseBackup() {
            toastr.info('Database backup feature coming soon');
        }

        function handleClearCache() {
            if (confirm('This will clear all template cache. Continue?')) {
                toastr.success('Cache cleared successfully');
            }
        }

        function handleRestartSession() {
            if (confirm('This will force all users to logout. Are you sure?')) {
                toastr.warning('All users have been logged out');
            }
        }
    </script>
{/block}
