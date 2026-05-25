// Admin Dashboard Functions

/**
 * Check if user is logged in via session
 */
function checkAuth() {
    // Server-side session check is done in controller
    // Client-side validation for immediate feedback
}

/**
 * Handle logout
 */
function logout() {
    window.location.href = '/logout';
}

/**
 * View order details
 */
function viewOrder(orderId) {
    alert('View order ' + orderId + ' - Feature coming soon');
}

/**
 * Edit order
 */
function editOrder(orderId) {
    alert('Edit order ' + orderId + ' - Feature coming soon');
}

/**
 * Initialize admin dashboard on page load
 */
document.addEventListener('DOMContentLoaded', function() {
    checkAuth();
});
