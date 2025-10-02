<#import "template.ftl" as layout>

<@layout.registrationLayout 
    displayInfo=social.displayInfo 
    displayWide=(realm.password && social.providers??) 
    displayRequiredFields=true; 
    section>

    <#if section = "header">
        <div class="kc-logo-text">ITlusions</div>
    <#elseif section = "form">
        <div class="itl-form-container">
            <div id="kc-form">
                <div id="kc-form-wrapper">
                    <#if realm.password && social.providers??>
                        <div class="itl-social-providers">
                            <#list social.providers as p>
                                <a href="${p.loginUrl}" 
                                   class="itl-button itl-button--social-primary itl-button--full-width"
                                   id="social-${p.alias}">
                                    <#if p.iconClasses?has_content>
                                        <i class="${p.iconClasses!}" aria-hidden="true"></i>
                                    </#if>
                                    <span>${msg("doLogIn")} ${msg("with")} ${p.displayName!}</span>
                                </a>
                            </#list>
                        </div>

                        <hr class="itl-divider">
                    </#if>

                    <#if realm.password>
                        <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                            <div class="itl-form-field">
                                <label for="username" class="itl-label">
                                    <#if !realm.loginWithEmailAllowed>
                                        ${msg("username")}
                                    <#elseif !realm.registrationEmailAsUsername>
                                        ${msg("usernameOrEmail")}
                                    <#else>
                                        ${msg("email")}
                                    </#if>
                                </label>
                                <input tabindex="1" 
                                       id="username" 
                                       class="itl-input <#if messagesPerField.existsError('username','password')>itl-input--error</#if>" 
                                       name="username" 
                                       value="${(login.username!'')}" 
                                       type="text" 
                                       autofocus 
                                       autocomplete="off"
                                       placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"
                                       aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"/>

                                <#if messagesPerField.existsError('username','password')>
                                    <div class="itl-error-message">
                                        <span class="itl-error-icon">⚠</span>
                                        <span aria-live="polite">
                                            ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                        </span>
                                    </div>
                                </#if>
                            </div>

                            <div class="itl-form-field">
                                <label for="password" class="itl-label">${msg("password")}</label>
                                <div class="itl-password-field">
                                    <input tabindex="2" 
                                           id="password" 
                                           class="itl-input <#if messagesPerField.existsError('username','password')>itl-input--error</#if>" 
                                           name="password" 
                                           type="password" 
                                           autocomplete="current-password"
                                           placeholder="${msg("password")}"
                                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"/>
                                    <button type="button" class="itl-password-toggle" tabindex="-1" aria-label="Toggle password visibility">
                                        👁
                                    </button>
                                </div>
                            </div>

                            <div class="itl-form-field">
                                <div id="kc-form-options">
                                    <#if realm.rememberMe && !usernameEditDisabled??>
                                        <div class="itl-radio-option">
                                            <input tabindex="3" 
                                                   id="rememberMe" 
                                                   name="rememberMe" 
                                                   type="checkbox" 
                                                   class="itl-radio"
                                                   <#if login.rememberMe??>checked</#if>>
                                            <label for="rememberMe" class="itl-radio-label">${msg("rememberMe")}</label>
                                        </div>
                                    </#if>
                                </div>
                                
                                <div id="kc-form-buttons" class="itl-form-actions">
                                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                                    <input tabindex="4" 
                                           class="itl-button itl-button--primary itl-button--full-width" 
                                           name="login" 
                                           id="kc-login" 
                                           type="submit" 
                                           value="${msg("doLogIn")}"/>
                                </div>
                            </div>
                        </form>
                    </#if>
                </div>

                <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
                    <div class="itl-info-section">
                        <span class="itl-info-text">
                            ${msg("noAccount")} 
                            <a tabindex="6" href="${url.registrationUrl}" class="itl-link">${msg("doRegister")}</a>
                        </span>
                    </div>
                </#if>

                <#if realm.resetPasswordAllowed>
                    <div class="itl-info-section">
                        <span class="itl-info-text">
                            <a tabindex="5" href="${url.loginResetCredentialsUrl}" class="itl-link">${msg("doForgotPassword")}</a>
                        </span>
                    </div>
                </#if>
            </div>
        </div>

        <script>
            // Password toggle functionality
            document.querySelector('.itl-password-toggle')?.addEventListener('click', function() {
                const passwordInput = document.getElementById('password');
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.textContent = type === 'password' ? '👁' : '🙈';
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

            // Neon effects on button hover
            document.querySelectorAll('.itl-button').forEach(button => {
                button.addEventListener('mouseenter', function() {
                    this.style.boxShadow = `
                        0 0 20px hsla(var(--hue1), 100%, 65%, 0.4),
                        0 10px 40px hsla(var(--hue1), 100%, 65%, 0.2),
                        inset 0 1px 0 var(--glass-shine)
                    `;
                });
                
                button.addEventListener('mouseleave', function() {
                    this.style.boxShadow = '';
                });
            });
        </script>
    <#elseif section = "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container">
                <div id="kc-registration">
                    <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}">${msg("doRegister")}</a></span>
                </div>
            </div>
        </#if>
    </#if>

</@layout.registrationLayout>