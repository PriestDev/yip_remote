// Admin Dashboard Functions

/**
 * Check if user is logged in via session
 */
function checkAuth() {
    // Server-side session check is done in controller
    // Client-side validation for immediate feedback
}

/**
 * Handle logout - uses relative path from current location
 */
function logout() {
    // Navigate to logout endpoint (works from any admin page)
    window.location.href = '/yip_remote/public/logout';
}

/**
 * Initialize admin dashboard on page load
 */
document.addEventListener('DOMContentLoaded', function() {
    checkAuth();
});
