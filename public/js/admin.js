// Admin Dashboard Functions

/**
 * Check if user is logged in via session
 */
function checkAuth() {
    // Server-side session check is done in controller
    // Client-side validation for immediate feedback
}

/**
 * Handle logout - uses baseUrl variable set in layout
 */
function logout() {
    // Navigate to logout endpoint using dynamic baseUrl
    window.location.href = baseUrl + '/logout';
}

/**
 * Initialize admin dashboard on page load
 */
document.addEventListener('DOMContentLoaded', function() {
    checkAuth();
});
