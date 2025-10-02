<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('firstName','lastName','email','username','password','password-confirm') displayRequiredFields=true; section>
    <#if section = "header">
        <div class="kc-logo-text">ITlusions</div>
    <#elseif section = "form">
        <div class="itl-form-container">
            <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.registrationAction}" method="post">
                <div class="itl-form-field">
                    <label for="firstName" class="itl-label">${msg("firstName")} <span class="required">*</span></label>
                    <input type="text" 
                           id="firstName" 
                           class="itl-input <#if messagesPerField.existsError('firstName')>itl-input--error</#if>" 
                           name="firstName" 
                           value="${(register.formData.firstName!'')}" 
                           autocomplete="given-name"
                           placeholder="${msg("firstName")}"
                           aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>" />

                    <#if messagesPerField.existsError('firstName')>
                        <div class="itl-error-message">
                            <span class="itl-error-icon">⚠</span>
                            <span aria-live="polite">
                                ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                            </span>
                        </div>
                    </#if>
                </div>

                <div class="itl-form-field">
                    <label for="lastName" class="itl-label">${msg("lastName")} <span class="required">*</span></label>
                    <input type="text" 
                           id="lastName" 
                           class="itl-input <#if messagesPerField.existsError('lastName')>itl-input--error</#if>" 
                           name="lastName" 
                           value="${(register.formData.lastName!'')}" 
                           autocomplete="family-name"
                           placeholder="${msg("lastName")}"
                           aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>" />

                    <#if messagesPerField.existsError('lastName')>
                        <div class="itl-error-message">
                            <span class="itl-error-icon">⚠</span>
                            <span aria-live="polite">
                                ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                            </span>
                        </div>
                    </#if>
                </div>

                <div class="itl-form-field">
                    <label for="email" class="itl-label">${msg("email")} <span class="required">*</span></label>
                    <input type="text" 
                           id="email" 
                           class="itl-input <#if messagesPerField.existsError('email')>itl-input--error</#if>" 
                           name="email" 
                           value="${(register.formData.email!'')}" 
                           autocomplete="email"
                           placeholder="${msg("email")}"
                           aria-invalid="<#if messagesPerField.existsError('email')>true</#if>" />

                    <#if messagesPerField.existsError('email')>
                        <div class="itl-error-message">
                            <span class="itl-error-icon">⚠</span>
                            <span aria-live="polite">
                                ${kcSanitize(messagesPerField.get('email'))?no_esc}
                            </span>
                        </div>
                    </#if>
                </div>

                <#if !realm.registrationEmailAsUsername>
                    <div class="itl-form-field">
                        <label for="username" class="itl-label">${msg("username")} <span class="required">*</span></label>
                        <input type="text" 
                               id="username" 
                               class="itl-input <#if messagesPerField.existsError('username')>itl-input--error</#if>" 
                               name="username" 
                               value="${(register.formData.username!'')}" 
                               autocomplete="username"
                               placeholder="${msg("username")}"
                               aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />

                        <#if messagesPerField.existsError('username')>
                            <div class="itl-error-message">
                                <span class="itl-error-icon">⚠</span>
                                <span aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('username'))?no_esc}
                                </span>
                            </div>
                        </#if>
                    </div>
                </#if>

                <#if passwordRequired??>
                    <div class="itl-form-field">
                        <label for="password" class="itl-label">${msg("password")} <span class="required">*</span></label>
                        <div class="itl-password-field">
                            <input type="password" 
                                   id="password" 
                                   class="itl-input <#if messagesPerField.existsError('password')>itl-input--error</#if>" 
                                   name="password" 
                                   autocomplete="new-password"
                                   placeholder="${msg("password")}"
                                   aria-invalid="<#if messagesPerField.existsError('password')>true</#if>" />
                            <button type="button" class="itl-password-toggle" tabindex="-1" aria-label="Toggle password visibility">
                                👁
                            </button>
                        </div>

                        <#if messagesPerField.existsError('password')>
                            <div class="itl-error-message">
                                <span class="itl-error-icon">⚠</span>
                                <span aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('password'))?no_esc}
                                </span>
                            </div>
                        </#if>
                    </div>

                    <div class="itl-form-field">
                        <label for="password-confirm" class="itl-label">${msg("passwordConfirm")} <span class="required">*</span></label>
                        <div class="itl-password-field">
                            <input type="password" 
                                   id="password-confirm" 
                                   class="itl-input <#if messagesPerField.existsError('password-confirm')>itl-input--error</#if>" 
                                   name="password-confirm" 
                                   autocomplete="new-password"
                                   placeholder="${msg("passwordConfirm")}"
                                   aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
                            <button type="button" class="itl-password-toggle" tabindex="-1" aria-label="Toggle password confirmation visibility">
                                👁
                            </button>
                        </div>

                        <#if messagesPerField.existsError('password-confirm')>
                            <div class="itl-error-message">
                                <span class="itl-error-icon">⚠</span>
                                <span aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                                </span>
                            </div>
                        </#if>
                    </div>
                </#if>

                <#if recaptchaRequired??>
                    <div class="itl-form-field">
                        <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
                    </div>
                </#if>

                <div class="itl-form-actions">
                    <input class="itl-button itl-button--primary itl-button--full-width" 
                           type="submit" 
                           value="${msg("doRegister")}"/>
                </div>
            </form>
            
            <div class="itl-info-section">
                <span class="itl-info-text">
                    ${msg("alreadyHaveAccount")} 
                    <a href="${url.loginUrl}" class="itl-link">${msg("doLogIn")}</a>
                </span>
            </div>
        </div>

        <script>
            // Password toggle functionality for both password fields
            document.querySelectorAll('.itl-password-toggle').forEach(toggle => {
                toggle.addEventListener('click', function() {
                    const passwordInput = this.previousElementSibling;
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);
                    this.textContent = type === 'password' ? '👁' : '🙈';
                });
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

            // Real-time password confirmation validation
            const password = document.getElementById('password');
            const passwordConfirm = document.getElementById('password-confirm');
            
            if (password && passwordConfirm) {
                passwordConfirm.addEventListener('input', function() {
                    if (this.value && password.value !== this.value) {
                        this.classList.add('itl-input--error');
                    } else {
                        this.classList.remove('itl-input--error');
                    }
                });
            }
        </script>
    </#if>
</@layout.registrationLayout>