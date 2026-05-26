{extends file="layout.tpl"}

{block name="title"}Checkout - E-Commerce Store{/block}

{block name="content"}
    <section class="checkout-container">
        <h2>Order Summary</h2>
        
        <div class="checkout-content">
            <div class="order-items-section">
                <h3>Your Items</h3>
                <div class="checkout-items">
                    {foreach from=$cart_items item=item}
                    <div class="checkout-item">
                        <div class="item-details">
                            <h4>{$item.name}</h4>
                            <p class="item-price">${$item.price|number_format:2}</p>
                        </div>
                        <div class="item-quantity">
                            <span>Qty: {$item.quantity}</span>
                        </div>
                        <div class="item-total">
                            ${$item.total|number_format:2}
                        </div>
                    </div>
                    {/foreach}
                </div>

                <div class="checkout-summary">
                    <div class="summary-row">
                        <span>Subtotal:</span>
                        <span>${$total_amount|number_format:2}</span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping:</span>
                        <span>FREE</span>
                    </div>
                    <div class="summary-row total">
                        <span>Total:</span>
                        <span>${$total_amount|number_format:2}</span>
                    </div>
                </div>
            </div>

            <div class="checkout-form-section">
                <h3>Shipping Information</h3>
                <form id="checkoutForm">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="{$user_name}" readonly>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" placeholder="Enter your email" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" placeholder="Enter your phone number" required>
                    </div>

                    <div class="form-group">
                        <label for="address">Street Address</label>
                        <input type="text" id="address" name="address" placeholder="Enter your address" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="city">City</label>
                            <input type="text" id="city" name="city" placeholder="Enter your city" required>
                        </div>
                        <div class="form-group">
                            <label for="state">State/Province</label>
                            <input type="text" id="state" name="state" placeholder="Enter state" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="zipcode">ZIP/Postal Code</label>
                            <input type="text" id="zipcode" name="zipcode" placeholder="Enter ZIP code" required>
                        </div>
                        <div class="form-group">
                            <label for="country">Country</label>
                            <input type="text" id="country" name="country" placeholder="Enter country" required>
                        </div>
                    </div>

                    <div class="form-group checkbox">
                        <input type="checkbox" id="agreeTerms" name="agreeTerms" required>
                        <label for="agreeTerms">I agree to the terms and conditions</label>
                    </div>

                    <div class="checkout-actions">
                        <button type="button" class="btn-secondary" onclick="window.location.href='{$base_url}/cart'">Back to Cart</button>
                        <button type="button" class="btn-primary" onclick="placeOrder()">Place Order</button>
                    </div>
                </form>
            </div>
        </div>
    </section>
{/block}

{block name="extra_scripts"}
    <script>
{literal}
        function placeOrder() {
            // Validate form
            const form = document.getElementById('checkoutForm');
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const address = document.getElementById('address').value.trim();
            const city = document.getElementById('city').value.trim();
            const state = document.getElementById('state').value.trim();
            const zipcode = document.getElementById('zipcode').value.trim();
            const country = document.getElementById('country').value.trim();
            const agreeTerms = document.getElementById('agreeTerms').checked;

            if (!email || !phone || !address || !city || !state || !zipcode || !country) {
                toastr.error('Please fill in all shipping information');
                return;
            }

            if (!agreeTerms) {
                toastr.error('Please agree to the terms and conditions');
                return;
            }

            // Disable button to prevent multiple clicks
            const button = event.target;
            button.disabled = true;
            button.textContent = 'Placing Order...';

            // Send checkout request
            fetch(baseUrl + '/api/checkout/store', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    email: email,
                    phone: phone,
                    address: address,
                    city: city,
                    state: state,
                    zipcode: zipcode,
                    country: country
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success('Order placed successfully!');
                    setTimeout(() => {
                        window.location.href = data.redirect;
                    }, 1500);
                } else {
                    toastr.error(data.message || 'Failed to place order');
                    button.disabled = false;
                    button.textContent = 'Place Order';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                toastr.error('An error occurred while placing your order');
                button.disabled = false;
                button.textContent = 'Place Order';
            });
        }
{/literal}
    </script>
{/block}
