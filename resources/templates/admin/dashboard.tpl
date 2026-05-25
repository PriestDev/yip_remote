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
                
                {if count($activities) > 0}
                    <div style="background: white; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                        <div style="display: flex; flex-direction: column;">
                            {foreach from=$activities item=activity}
                                <div style="padding: 1.5rem; border-bottom: 1px solid #ecf0f1; display: flex; align-items: center; gap: 1rem; transition: background-color 0.3s;">
                                    <div style="flex-shrink: 0; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem; background-color: {if $activity.type === 'order'}#3498db{elseif $activity.type === 'user'}#2ecc71{else}#e74c3c{/if};">
                                        {if $activity.type === 'order'}📦{elseif $activity.type === 'user'}👤{else}📝{/if}
                                    </div>
                                    
                                    <div style="flex: 1;">
                                        <h4 style="margin: 0 0 0.25rem 0; color: #2c3e50; font-size: 0.95rem; font-weight: 600;">{$activity.title}</h4>
                                        <p style="margin: 0 0 0.25rem 0; color: #7f8c8d; font-size: 0.85rem;">{$activity.description}</p>
                                        <span style="display: inline-block; padding: 0.2rem 0.6rem; background-color: {if $activity.status === 'pending'}#fff3cd{elseif $activity.status === 'completed'}#d1e7dd{else}#e7f3ff{/if}; color: {if $activity.status === 'pending'}#856404{elseif $activity.status === 'completed'}#155724{else}#0c5aa0{/if}; border-radius: 3px; font-size: 0.75rem; font-weight: 600; text-transform: capitalize;">
                                            {$activity.status}
                                        </span>
                                    </div>
                                    
                                    <div style="flex-shrink: 0; text-align: right; color: #95a5a6; font-size: 0.85rem;">
                                        {$activity.timestamp|date_format:"%b %d, %Y"}
                                        <br>
                                        {$activity.timestamp|date_format:"%H:%M"}
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    </div>
                {else}
                    <div style="background: white; border-radius: 8px; padding: 2rem; text-align: center; color: #95a5a6;">
                        <p>No recent activities to display</p>
                    </div>
                {/if}
            </div>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script src="{$base_url}/js/admin.js"></script>
{/block}
