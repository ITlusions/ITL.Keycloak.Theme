<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username') displayRequiredFields=false; section>
    <#if section = "header">
        <div class="kc-logo-text">ITlusions</div>
    <#elseif section = "form">
        <div class="itl-form-container">
            <form id="kc-reset-password-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
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
                    <input type="text" 
                           id="username" 
                           name="username" 
                           class="itl-input <#if messagesPerField.existsError('username')>itl-input--error</#if>" 
                           autofocus 
                           value="${(auth.attemptedUsername!'')}"
                           placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"
                           autocomplete="username"
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

                <div class="itl-form-actions">
                    <input class="itl-button itl-button--primary itl-button--full-width" 
                           type="submit" 
                           value="${msg("doSubmit")}"/>
                </div>
            </form>
            
            <div class="itl-info-section">
                <span class="itl-info-text">
                    <a href="${url.loginUrl}" class="itl-link">« ${msg("backToLogin")}</a>
                </span>
            </div>
        </div>

        <script>
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
            <span class="itl-info-text">${msg("emailInstruction")}</span>
        </div>
    </#if>
</@layout.registrationLayout>