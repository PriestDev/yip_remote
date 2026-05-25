<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{block name="title"}Electronics Store - Premium Tech Products{/block}</title>
    <link rel="stylesheet" href="/yip_remote/public/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    {block name="extra_css"}{/block}
</head>
<body>
    <header>
        <nav class="navbar">
            <div class="container">
                <h1 class="logo">E-Store</h1>
                <ul class="nav-links">
                    <li><a href="{$base_url}/">Home</a></li>
                    <li><a href="{$base_url}/cart">Cart</a></li>
                    {if isset($smarty.session.user_id)}
                        <li><span class="user-name">Hello, {$smarty.session.user_name}</span></li>
                        <li><a href="{$base_url}/logout" class="logout-btn">Logout</a></li>
                    {/if}
                </ul>
            </div>
        </nav>
    </header>

    <main class="container">
        {block name="content"}{/block}
    </main>

    <footer>
        <p>&copy; 2026 E-Commerce Store by Priest(Francis). All rights reserved.</p>
    </footer>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    {block name="extra_scripts"}{/block}
</body>
</html>
