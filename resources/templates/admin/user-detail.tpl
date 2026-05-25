{extends file="../layout.tpl"}

{block name="title"}User Details - Admin Dashboard{/block}

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
                <h1>User Details</h1>
                <div class="user-info">
                    <p>Welcome, <strong>{if $user_name}{$user_name}{else}Admin{/if}</strong></p>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <div class="content-section" style="max-width: 600px;">
                {if isset($error)}
                    <div style="background-color: #f8d7da; border: 1px solid #f5c6cb; border-radius: 4px; padding: 1rem; color: #721c24; margin-bottom: 1rem;">
                        {$error}
                    </div>
                {else}
                    <div style="background: white; border-radius: 8px; padding: 2rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                        <div style="display: grid; grid-template-columns: 1fr; gap: 1.5rem;">
                            <div>
                                <label style="display: block; font-weight: 600; color: #7f8c8d; font-size: 0.85rem; margin-bottom: 0.25rem; text-transform: uppercase;">User ID</label>
                                <p style="margin: 0; font-size: 1.1rem; color: #2c3e50;">#{$user.id}</p>
                            </div>

                            <div>
                                <label style="display: block; font-weight: 600; color: #7f8c8d; font-size: 0.85rem; margin-bottom: 0.25rem; text-transform: uppercase;">Full Name</label>
                                <p style="margin: 0; font-size: 1.1rem; color: #2c3e50;">{if $user.name}{$user.name}{else}-{/if}</p>
                            </div>

                            <div>
                                <label style="display: block; font-weight: 600; color: #7f8c8d; font-size: 0.85rem; margin-bottom: 0.25rem; text-transform: uppercase;">Email Address</label>
                                <p style="margin: 0; font-size: 1.1rem; color: #2c3e50;">
                                    {if $user.email}<a href="mailto:{$user.email}" style="color: #3498db; text-decoration: none;">{$user.email}</a>{else}-{/if}
                                </p>
                            </div>

                            <div>
                                <label style="display: block; font-weight: 600; color: #7f8c8d; font-size: 0.85rem; margin-bottom: 0.25rem; text-transform: uppercase;">Role</label>
                                <p style="margin: 0; font-size: 1.1rem; color: #2c3e50;">
                                    <span style="display: inline-block; padding: 0.4rem 0.8rem; background-color: {if $user.role === 'admin'}#cfe2ff{else}#e7f3ff{/if}; color: {if $user.role === 'admin'}#084298{else}#0c5aa0{/if}; border-radius: 4px;">
                                        {$user.role|ucfirst}
                                    </span>
                                </p>
                            </div>

                            <div>
                                <label style="display: block; font-weight: 600; color: #7f8c8d; font-size: 0.85rem; margin-bottom: 0.25rem; text-transform: uppercase;">Joined Date</label>
                                <p style="margin: 0; font-size: 1.1rem; color: #2c3e50;">{$user.created_at|date_format:"%B %d, %Y at %H:%M"}</p>
                            </div>
                        </div>

                        <div style="display: flex; gap: 1rem; margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #ecf0f1;">
                            <button class="btn-small btn-secondary" onclick="window.history.back()" style="flex: 1; padding: 0.75rem; background: #95a5a6; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: 600;">Back</button>
                            {if $user.id != $smarty.session.user_id}
                                <button class="btn-small btn-edit" onclick="editUser({$user.id})" style="flex: 1; padding: 0.75rem; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: 600;">Edit</button>
                                <button class="btn-small btn-delete" onclick="deleteUser({$user.id})" style="flex: 1; padding: 0.75rem; background: #e74c3c; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: 600;">Delete</button>
                            {/if}
                        </div>
                    </div>
                {/if}
            </div>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
    <script>
        function editUser(userId) {
            // TODO: Implement edit user form
            toastr.info('Edit user feature coming soon');
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
                    setTimeout(() => location.href = '{$base_url}/admin/users', 1500);
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
