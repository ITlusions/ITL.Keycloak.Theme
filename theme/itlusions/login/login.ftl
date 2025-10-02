<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section == "header">
        ${msg("loginAccountTitle")}
    <#elseif section == "form">
        <div id="kc-form">
            <#if realm.password>
                <form id="kc-form-login" class="${properties.kcFormClass!}" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                    <#if !usernameHidden??>
                        <div class="${properties.kcFormGroupClass!}">
                            <label for="username" class="${properties.kcLabelClass!}">
                                <#if !realm.loginWithEmailAllowed>
                                    ${msg("username")}
                                <#elseif !realm.registrationEmailAsUsername>
                                    ${msg("usernameOrEmail")}
                                <#else>
                                    ${msg("email")}
                                </#if>
                            </label>
                            <input tabindex="2" 
                                   id="username" 
                                   class="${properties.kcInputClass!}" 
                                   name="username" 
                                   value="${(login.username!'')}" 
                                   type="text" 
                                   autofocus 
                                   autocomplete="username"
                                   placeholder="<#if !realm.loginWithEmailAllowed>Enter your username<#elseif !realm.registrationEmailAsUsername>Enter username or email<#else>Enter your email</#if>"
                                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
                            <#if messagesPerField.existsError('username','password')>
                                <span class="${properties.kcInputErrorMessageClass!}">
                                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </#if>

                    <div class="${properties.kcFormGroupClass!}">
                        <label for="password" class="${properties.kcLabelClass!}">
                            ${msg("password")}
                        </label>
                        <input tabindex="3" 
                               id="password" 
                               class="${properties.kcInputClass!}" 
                               name="password" 
                               type="password" 
                               autocomplete="current-password"
                               placeholder="Enter your password"
                               aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
                        <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                            <span class="${properties.kcInputErrorMessageClass!}">
                                ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="${properties.kcFormGroupClass!}" style="display: flex; align-items: center; gap: 0.5rem;">
                        <#if realm.rememberMe && !usernameHidden??>
                            <div class="itlusions-checkbox">
                                <input tabindex="4" 
                                       id="rememberMe" 
                                       name="rememberMe" 
                                       type="checkbox"
                                       <#if login.rememberMe??>checked</#if> />
                                <label for="rememberMe">${msg("rememberMe")}</label>
                            </div>
                        </#if>
                    </div>

                    <div class="${properties.kcFormGroupClass!}">
                        <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                        <input tabindex="5" 
                               class="${properties.kcButtonClass!} ${properties.kcButtonLargeClass!}" 
                               name="login" 
                               id="kc-login" 
                               type="submit" 
                               value="${msg("doLogIn")}" />
                    </div>

                    <div class="${properties.kcFormOptionsClass!}">
                        <#if realm.resetPasswordAllowed>
                            <a tabindex="6" href="${url.loginResetCredentialsUrl}">
                                ${msg("doForgotPassword")}
                            </a>
                        </#if>
                        <#if realm.registrationAllowed && !registrationDisabled??>
                            <a tabindex="7" href="${url.registrationUrl}">
                                ${msg("doRegister")}
                            </a>
                        </#if>
                    </div>
                </form>
            </#if>

            <#if social?? && social.providers?has_content>
                <div class="${properties.kcFormSocialAccountListClass!}">
                    <#list social.providers as p>
                        <a id="social-${p.alias}" 
                           class="${properties.kcFormSocialAccountListButtonClass!}" 
                           type="button" 
                           href="${p.loginUrl}">
                            <#if p.iconClasses?has_content>
                                <i class="${p.iconClasses!}" aria-hidden="true"></i>
                            </#if>
                            <span>${p.displayName!}</span>
                        </a>
                    </#list>
                </div>
            </#if>
        </div>
    <#elseif section == "info">
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="itlusions-form-options">
                <span>
                    ${msg("noAccount")}
                    <a tabindex="8" href="${url.registrationUrl}">${msg("doRegister")}</a>
                </span>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>