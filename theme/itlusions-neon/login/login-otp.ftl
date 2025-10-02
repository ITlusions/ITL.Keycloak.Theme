<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp') displayInfo=true; section>
    <#if section = "header">
        <div class="kc-logo-text">ITlusions</div>
    <#elseif section = "form">
        <div class="itl-form-container">
            <form id="kc-otp-login-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
                <#if otpLogin.userOtpCredentials?size gt 1>
                    <div class="itl-form-field">
                        <label for="kc-otp-credential" class="itl-label">${msg("loginChooseAuthenticator")}</label>
                        <select id="kc-otp-credential" name="selectedCredentialId" class="itl-input">
                            <#list otpLogin.userOtpCredentials as otpCredential>
                                <option value="${otpCredential.id}" <#if otpCredential.id == otpLogin.selectedCredentialId>selected="selected"</#if>>
                                    ${otpCredential.userLabel}
                                </option>
                            </#list>
                        </select>
                    </div>
                </#if>

                <div class="itl-form-field">
                    <label for="otp" class="itl-label">${msg("loginOtpOneTime")}</label>
                    <input id="otp" 
                           name="otp" 
                           autocomplete="off" 
                           type="text" 
                           class="itl-input <#if messagesPerField.existsError('totp')>itl-input--error</#if>" 
                           autofocus 
                           autocomplete="one-time-code"
                           placeholder="${msg("loginOtpOneTime")}"
                           aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>" />
                    
                    <#if messagesPerField.existsError('totp')>
                        <div class="itl-error-message">
                            <span class="itl-error-icon">⚠</span>
                            <span aria-live="polite">
                                ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                            </span>
                        </div>
                    </#if>
                </div>

                <div class="itl-form-actions">
                    <input class="itl-button itl-button--primary itl-button--full-width" 
                           name="login" 
                           id="kc-login" 
                           type="submit" 
                           value="${msg("doLogIn")}"/>
                </div>
            </form>

            <#if auth?has_content && auth.showTryAnotherWayLink()>
                <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                    <div class="itl-info-section">
                        <input type="hidden" name="tryAnotherWay" value="on" />
                        <a href="#" 
                           id="try-another-way" 
                           class="itl-link"
                           onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">
                            ${msg("doTryAnotherWay")}
                        </a>
                    </div>
                </form>
            </#if>
        </div>

        <script>
            // Auto-focus and enhance OTP input
            document.addEventListener('DOMContentLoaded', function() {
                const otpInput = document.getElementById('otp');
                if (otpInput) {
                    otpInput.focus();
                    
                    // Auto-submit when OTP is 6 digits (common length)
                    otpInput.addEventListener('input', function() {
                        if (this.value.length === 6 && /^\d{6}$/.test(this.value)) {
                            // Small delay to allow user to see the complete input
                            setTimeout(() => {
                                document.getElementById('kc-otp-login-form').submit();
                            }, 500);
                        }
                    });
                    
                    // Add neon glow effect when valid
                    otpInput.addEventListener('input', function() {
                        if (/^\d{6}$/.test(this.value)) {
                            this.style.borderColor = 'var(--neon-accent)';
                            this.style.boxShadow = '0 0 20px hsla(var(--hue3), 100%, 65%, 0.4)';
                        } else {
                            this.style.borderColor = '';
                            this.style.boxShadow = '';
                        }
                    });
                }
            });

            // Enhanced form interactions
            document.querySelectorAll('.itl-input').forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.classList.add('focused');
                });
                
                input.addEventListener('blur', function() {
                    this.parentElement.classList.remove('focused');
                });
            });
        </script>
    <#elseif section = "info">
        <div class="itl-info-section">
            <span class="itl-info-text">${msg("loginOtpMsg")}</span>
        </div>
    </#if>
</@layout.registrationLayout>