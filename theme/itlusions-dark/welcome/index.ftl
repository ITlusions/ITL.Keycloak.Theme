<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        <div class="welcome-header">
            <h1 class="welcome-title">🌙 ${msg("welcomeTitle","Welcome to ITlusions Dark")}</h1>
            <p class="welcome-subtitle">${msg("welcomeSubtitle","Professional Dark Mode Authentication")}</p>
        </div>
    <#elseif section = "form">
        <div id="kc-welcome-wrapper" class="itl-welcome-container">
            <div class="itl-welcome-content">
                <h2 style="color: var(--itl-primary); margin-bottom: 1.5rem;">🛡️ Administrator Setup</h2>
                
                <div class="itl-welcome-steps">
                    <div class="itl-welcome-step">
                        <span class="itl-step-icon">👤</span>
                        <div>
                            <h3>Create Admin User</h3>
                            <p>Set up your administrator account to manage this ITlusions Dark theme instance.</p>
                        </div>
                    </div>
                    
                    <div class="itl-welcome-step">
                        <span class="itl-step-icon">🔧</span>
                        <div>
                            <h3>Configure Realm</h3>
                            <p>Customize authentication settings and user management for your organization.</p>
                        </div>
                    </div>
                    
                    <div class="itl-welcome-step">
                        <span class="itl-step-icon">🎨</span>
                        <div>
                            <h3>Apply Dark Theme</h3>
                            <p>ITlusions Dark theme provides a professional dark mode experience.</p>
                        </div>
                    </div>
                </div>

                <form id="kc-form-wrapper" action="${url.welcomeUrl}" method="post" class="itl-welcome-form">
                    <div class="itl-form-field">
                        <label for="username" class="itl-label">${msg("username")}</label>
                        <input tabindex="1" id="username" class="itl-input" name="username" type="text" 
                               placeholder="admin" required autofocus autocomplete="username" />
                    </div>

                    <div class="itl-form-field">
                        <label for="password" class="itl-label">${msg("password")}</label>
                        <div class="itl-password-field">
                            <input tabindex="2" id="password" class="itl-input" name="password" type="password" 
                                   required autocomplete="new-password" placeholder="Choose a strong password" />
                            <button class="itl-password-toggle" type="button" aria-label="Show password">
                                <span class="itl-password-icon itl-password-icon--show">👁</span>
                                <span class="itl-password-icon itl-password-icon--hide" style="display: none;">🙈</span>
                            </button>
                        </div>
                    </div>

                    <div class="itl-form-field">
                        <label for="passwordConfirmation" class="itl-label">${msg("passwordConfirm")}</label>
                        <input tabindex="3" id="passwordConfirmation" class="itl-input" name="passwordConfirmation" 
                               type="password" required autocomplete="new-password" placeholder="Confirm your password" />
                    </div>

                    <div class="itl-form-actions">
                        <input tabindex="4" class="itl-button itl-button--primary itl-button--full-width" 
                               type="submit" value="🚀 ${msg('doContinue','Create Admin & Continue')}" />
                    </div>
                </form>

                <div class="itl-welcome-footer">
                    <p style="color: var(--itl-dark-text-muted); text-align: center; margin-top: 2rem;">
                        Powered by <strong style="color: var(--itl-primary);">ITlusions Dark Theme</strong> 
                        - Professional authentication experience
                    </p>
                </div>
            </div>
        </div>

        <script>
            // Password visibility toggle
            document.addEventListener('DOMContentLoaded', function() {
                const toggleButton = document.querySelector('.itl-password-toggle');
                const passwordInput = document.getElementById('password');
                const showIcon = document.querySelector('.itl-password-icon--show');
                const hideIcon = document.querySelector('.itl-password-icon--hide');

                if (toggleButton && passwordInput) {
                    toggleButton.addEventListener('click', function() {
                        const isPassword = passwordInput.type === 'password';
                        passwordInput.type = isPassword ? 'text' : 'password';
                        showIcon.style.display = isPassword ? 'none' : 'inline';
                        hideIcon.style.display = isPassword ? 'inline' : 'none';
                    });
                }

                // Password confirmation validation
                const passwordConfirm = document.getElementById('passwordConfirmation');
                if (passwordConfirm) {
                    passwordConfirm.addEventListener('input', function() {
                        if (this.value && this.value !== passwordInput.value) {
                            this.style.borderColor = 'var(--itl-error)';
                        } else {
                            this.style.borderColor = 'var(--itl-input-border)';
                        }
                    });
                }
            });
        </script>

        <style>
            .itl-welcome-container {
                max-width: 500px;
                margin: 0 auto;
                padding: 2rem;
            }

            .itl-welcome-content {
                background: var(--itl-card-bg);
                border: 1px solid var(--itl-card-border);
                border-radius: var(--itl-border-radius-lg);
                padding: 2rem;
                box-shadow: var(--itl-shadow-lg);
            }

            .itl-welcome-steps {
                margin: 2rem 0;
            }

            .itl-welcome-step {
                display: flex;
                align-items: center;
                gap: 1rem;
                margin-bottom: 1.5rem;
                padding: 1rem;
                background: var(--itl-dark-surface);
                border-radius: var(--itl-border-radius);
                border: 1px solid var(--itl-dark-border);
            }

            .itl-step-icon {
                font-size: 2rem;
                min-width: 3rem;
                text-align: center;
            }

            .itl-welcome-step h3 {
                color: var(--itl-dark-text);
                margin: 0 0 0.5rem 0;
                font-size: 1.1rem;
                font-weight: 600;
            }

            .itl-welcome-step p {
                color: var(--itl-dark-text-muted);
                margin: 0;
                font-size: 0.9rem;
                line-height: 1.5;
            }

            .itl-welcome-form {
                margin-top: 2rem;
            }

            .itl-welcome-footer {
                margin-top: 2rem;
                padding-top: 2rem;
                border-top: 1px solid var(--itl-dark-border);
            }
        </style>
    </#if>
</@layout.registrationLayout>