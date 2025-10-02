<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password'); section>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">
        <div class="itl-divider"></div>
        
        <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
            <div class="itl-form-container">
                <div class="itl-form-fieldset">
                    <div class="itl-form-field">
                        <label for="password" class="itl-label">${msg("password")}</label>
                        <#if messagesPerField.existsError('password')>
                            <div class="itl-error-message" role="alert">
                                <span class="itl-error-icon">⚠</span>
                                ${kcSanitize(messagesPerField.get('password'))?no_esc}
                            </div>
                        </#if>
                        
                        <div class="itl-password-field">
                            <input 
                                tabindex="2" 
                                id="password" 
                                class="itl-input <#if messagesPerField.existsError('password')>itl-input--error</#if>" 
                                name="password"
                                type="password" 
                                autocomplete="current-password" 
                                autofocus 
                                dir="auto"
                                aria-invalid="<#if messagesPerField.existsError('password')>true</#if>"
                                placeholder="${msg('password')}"
                            />
                            <button 
                                class="itl-password-toggle" 
                                type="button" 
                                aria-label="${msg('showPassword')}"
                                aria-controls="password" 
                                data-password-toggle
                                data-label-show="${msg('showPassword')}" 
                                data-label-hide="${msg('hidePassword')}"
                            >
                                <span class="itl-password-icon itl-password-icon--show">👁</span>
                                <span class="itl-password-icon itl-password-icon--hide" style="display: none;">🙈</span>
                            </button>
                        </div>
                    </div>

                    <div class="itl-form-options">
                        <#if realm.resetPasswordAllowed>
                            <a 
                                tabindex="5"
                                href="${url.loginResetCredentialsUrl}" 
                                class="itl-link itl-link--forgot-password"
                            >
                                ${msg("doForgotPassword")}
                            </a>
                        </#if>
                    </div>
                </div>

                <div class="itl-form-actions">
                    <input 
                        tabindex="4" 
                        class="itl-button itl-button--primary" 
                        name="login" 
                        id="kc-login" 
                        type="submit" 
                        value="${msg('doLogIn')}"
                    />
                </div>
            </div>
        </form>

        <script>
            // Password visibility toggle
            document.addEventListener('DOMContentLoaded', function() {
                const toggleButton = document.querySelector('[data-password-toggle]');
                const passwordInput = document.getElementById('password');
                const showIcon = document.querySelector('.itl-password-icon--show');
                const hideIcon = document.querySelector('.itl-password-icon--hide');

                if (toggleButton && passwordInput) {
                    toggleButton.addEventListener('click', function() {
                        const isPassword = passwordInput.type === 'password';
                        passwordInput.type = isPassword ? 'text' : 'password';
                        showIcon.style.display = isPassword ? 'none' : 'inline';
                        hideIcon.style.display = isPassword ? 'inline' : 'none';
                        toggleButton.setAttribute('aria-label', isPassword ? this.dataset.labelHide : this.dataset.labelShow);
                    });
                }
            });
        </script>
    </#if>
</@layout.registrationLayout>