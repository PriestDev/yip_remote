{extends file="../layout.tpl"}

{block name="title"}Manage Users - Admin Dashboard{/block}

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
                <li><a href="{$base_url}/admin/products">Products</a></li>
                <li><a href="{$base_url}/admin/users" class="active">Users</a></li>
                <li><a href="{$base_url}/admin/settings">Settings</a></li>
            </ul>
        </aside>

        <div class="admin-content">
            <div class="dashboard-header">
                <h1>Manage Users</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{if $user_name}{$user_name}{else}Admin{/if}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="content-section">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h2 class="section-title" style="margin: 0;">Users List</h2>
                    <button class="btn-action" onclick="addUser()" style="padding: 0.6rem 1.2rem; background-color: #27ae60; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 0.95rem;">+ Add New User</button>
                </div>

                {if count($users) > 0}
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Joined Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$users item=user}
                                <tr>
                                    <td>#{$user['id']}</td>
                                    <td>{$user['name']}</td>
                                    <td>{$user['email']}</td>
                                    <td>
                                        <span class="status-badge" style="background-color: {if $user['role'] === 'admin'}#cfe2ff{else}#e7f3ff{/if}; color: {if $user['role'] === 'admin'}#084298{else}#0c5aa0{/if};">
                                            {ucfirst($user['role'])}
                                        </span>
                                    </td>
                                    <td>{$user['created_at']|date_format:"%Y-%m-%d %H:%M"}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-small btn-view" onclick="viewUser({$user['id']})">View</button>
                                            <button class="btn-small btn-edit" onclick="editUser({$user['id']})">Edit</button>
                                            {if $user['id'] != $smarty.session.user_id}
                                                <button class="btn-small btn-delete" onclick="deleteUser({$user['id']})">Delete</button>
                                            {/if}
                                        </div>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                {else}
                    <div class="no-orders">
                        <p>No users found.</p>
                    </div>
                {/if}
            </div>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
    <script>
        function addUser() {
            const email = prompt('Enter user email:');
            if (!email) return;

            const password = prompt('Enter password (min 6 characters):');
            if (!password || password.length < 6) {
                toastr.error('Password must be at least 6 characters');
                return;
            }

            const name = prompt('Enter user name:');
            if (!name) return;

            const role = prompt('Enter role (user/admin):', 'user');
            if (!role || (role !== 'user' && role !== 'admin')) {
                toastr.error('Role must be "user" or "admin"');
                return;
            }

            toastr.info('Add user feature - please use registration page or database directly');
        }

        function viewUser(userId) {
            window.location.href = '{$base_url}/admin/users/' + userId;
        }

        function editUser(userId) {
            const newName = prompt('Enter new user name:');
            if (!newName) return;

            toastr.info('Edit user feature coming soon. Name: ' + newName);
        }

        function deleteUser(userId) {
            if (!confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
                return;
            }

            fetch('{$base_url}/admin/users/' + userId + '/delete', {
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
                toastr.error('Error deleting user: ' + error.message);
            });
        }
    </script>
{/block}
