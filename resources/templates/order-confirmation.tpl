{extends file="layout.tpl"}

{block name="title"}Order Confirmation - E-Commerce Store{/block}

{block name="content"}
    <section class="order-confirmation">
        <div class="confirmation-content">
            <div class="success-message">
                <div class="success-icon">✓</div>
                <h2>Order Placed Successfully!</h2>
                <p>Thank you for your purchase. Your order has been received and is being processed.</p>
            </div>

            <div class="order-details-card">
                <h3>Order Details</h3>
                <div class="order-header">
                    <div class="order-info-row">
                        <span class="label">Order Number:</span>
                        <span class="value">{$order->getOrderNumber()}</span>
                    </div>
                    <div class="order-info-row">
                        <span class="label">Order Date:</span>
                        <span class="value">{$order->getCreatedAt()}</span>
                    </div>
                    <div class="order-info-row">
                        <span class="label">Order Status:</span>
                        <span class="value status-badge status-{$order->getStatus()}">{$order->getStatus()|ucfirst}</span>
                    </div>
                </div>

                <div class="order-items-table">
                    <h4>Items Ordered</h4>
                    <table>
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Unit Price</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$items item=item}
                            {assign var="subtotal" value=$item.quantity * $item.price}
                            <tr>
                                <td>{$item.name}</td>
                                <td>{$item.quantity}</td>
                                <td>${$item.price|number_format:2}</td>
                                <td>${$subtotal|number_format:2}</td>
                            </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>

                <div class="order-summary">
                    <div class="summary-row">
                        <span>Subtotal:</span>
                        <span>${$order->getTotal()|number_format:2}</span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping:</span>
                        <span>FREE</span>
                    </div>
                    <div class="summary-row total">
                        <span>Total Amount:</span>
                        <span>${$order->getTotal()|number_format:2}</span>
                    </div>
                </div>

                <div class="next-steps">
                    <h4>What's Next?</h4>
                    <ul>
                        <li>You will receive an email confirmation shortly</li>
                        <li>Track your order status from your account dashboard</li>
                        <li>We will notify you when your order ships</li>
                        <li>Estimated delivery: 3-5 business days</li>
                    </ul>
                </div>

                <div class="confirmation-actions">
                    <a href="{$base_url}/" class="btn-continue-shopping">Continue Shopping</a>
                    <a href="{$base_url}/account" class="btn-view-orders">View My Orders</a>
                </div>
            </div>

            <div class="support-contact">
                <h3>Need Help?</h3>
                <p>If you have any questions about your order, please contact our customer support team.</p>
                <p class="contact-info">
                    <strong>Email:</strong> support@estore.com<br>
                    <strong>Phone:</strong> 1-800-ESTORE-1<br>
                    <strong>Hours:</strong> Monday - Friday, 9 AM - 6 PM EST
                </p>
            </div>
        </div>
    </section>
{/block}

{block name="extra_scripts"}
    <script>
        // Print order confirmation if requested
        function printOrder() {
            window.print();
        }
    </script>
{/block}
