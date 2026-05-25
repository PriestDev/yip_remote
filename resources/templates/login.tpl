{extends file="layout.tpl"}

{block name="title"}Login - E-Commerce Store{/block}

{block name="extra_css"}
    <style>
        .auth-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: calc(100vh - 200px);
            padding: 2rem;
        }

        .auth-box {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            width: 100%;
            max-width: 400px;
        }

        .auth-box h2 {
            text-align: center;
            margin-bottom: 2rem;
            color: #333;
            font-size: 1.8rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #555;
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }

        .form-group input::placeholder {
            color: #999;
        }

        .btn-submit {
            width: 100%;
            padding: 0.8rem;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-submit:hover {
            background-color: #2980b9;
        }

        .auth-link {
            text-align: center;
            margin-top: 1.5rem;
            color: #666;
        }

        .auth-link a {
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
        }

        .auth-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 0.75rem;
            border-radius: 4px;
            margin-bottom: 1rem;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        @media (max-width: 768px) {
            .auth-container {
                min-height: auto;
                padding: 1rem;
            }

            .auth-box {
                padding: 1.5rem;
            }

            .auth-box h2 {
                font-size: 1.5rem;
                margin-bottom: 1.5rem;
            }

            .form-group {
                margin-bottom: 1rem;
            }

            .form-group input {
                padding: 0.7rem;
                font-size: 16px;
            }
        }
    </style>
{/block}

{block name="content"}
    <div class="auth-container">
        <div class="auth-box">
            <h2>Login</h2>
            
            <div class="error-message" id="errorMsg"></div>

            <form id="loginForm" method="POST" action="{$base_url}/handleLogin">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        placeholder="Enter your email"
                        required
                    >
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        placeholder="Enter your password"
                        required
                    >
                </div>

                <button type="submit" class="btn-submit">Login</button>
            </form>

            <div class="auth-link">
                Don't have an account? <a href="{$base_url}/register">Register here</a>
            </div>
        </div>
    </div>
{/block}

{block name="extra_scripts"}
    <script>
        // Configure Toastr
        toastr.options = {
            "closeButton": true,
            "progressBar": true,
            "positionClass": "toast-top-right",
            "timeOut": "5000"
        };

        document.getElementById('loginForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            
            fetch('{$base_url}/handleLogin', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    toastr.success(data.message || 'Login successful!');
                    // Redirect on success
                    setTimeout(() => {
                        window.location.href = data.redirect || '/';
                    }, 1000);
                } else {
                    toastr.error(data.message || 'Login failed');
                }
            })
            .catch(error => {
                toastr.error('An error occurred. Please try again.');
            });
        });
    </script>
{/block}
