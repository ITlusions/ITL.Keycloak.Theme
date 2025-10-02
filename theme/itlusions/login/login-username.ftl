<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username') displayInfo=(realm.password && realm.registrationAllowed && !registrationDisabled??); section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section == "socialProviders">
        <#if realm.password && social?? && social.providers?has_content>
            <div id="kc-social-providers" class="itl-social-providers">
                <#list social.providers as provider>
                    <a 
                        id="social-${provider.alias}"
                        class="itl-button <#if provider?index == 0>itl-button--social-primary<#else>itl-button--social-secondary</#if> itl-button--full-width"
                        href="${provider.loginUrl}"
                    >
                        <#if provider.iconClasses?has_content>
                            <span class="itl-social-icon ${provider.iconClasses!}" aria-hidden="true"></span>
                        </#if>
                        <span class="itl-social-text">${provider.displayName!}</span>
                    </a>
                </#list>
            </div>
        </#if>
    <#elseif section = "form">
        <form id="kc-form-login" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
            <div class="itl-form-container">
                <div class="itl-form-fieldset">
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
                        <#if messagesPerField.existsError('username','password')>
                            <div class="itl-error-message" role="alert">
                                <span class="itl-error-icon">⚠</span>
                                ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                            </div>
                        </#if>
                        
                        <input 
                            tabindex="1" 
                            id="username" 
                            class="itl-input <#if messagesPerField.existsError('username','password')>itl-input--error</#if>" 
                            name="username" 
                            value="${(login.username!'')}" 
                            type="text" 
                            autofocus 
                            autocomplete="<#if realm.loginWithEmailAllowed>email<#else>username</#if>" 
                            dir="auto"
                            aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                            placeholder="<#if !realm.loginWithEmailAllowed>${msg('username')}<#elseif !realm.registrationEmailAsUsername>${msg('usernameOrEmail')}<#else>${msg('email')}</#if>"
                        />
                    </div>
                </div>

                <div class="itl-form-actions">
                    <input 
                        tabindex="3" 
                        class="itl-button itl-button--primary" 
                        name="login" 
                        id="kc-login" 
                        type="submit" 
                        value="${msg('doContinue')}"
                    />
                </div>
            </div>
        </form>
    <#elseif section = "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container" class="itl-info-section">
                <div id="kc-registration">
                    <span class="itl-info-text">
                        ${msg("noAccount")} 
                        <a tabindex="6" href="${url.registrationUrl}" class="itl-link">
                            ${msg("doRegister")}
                        </a>
                    </span>
                </div>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>