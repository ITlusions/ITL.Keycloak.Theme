<#import "template.ftl" as layout>
<#-- displayInfo is intentionally false: the "info" section below only ever duplicated the
     Create Account link already shown in the form's own itlusions-form-options row. Removing
     it reclaims real vertical space on shorter viewports (e.g. laptop windows, tablets in
     landscape), where every optional login feature enabled at once was pushing social login
     buttons entirely below the fold. -->
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=false; section>
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

                    <div class="${properties.kcFormGroupClass!}">
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

                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                    <button tabindex="5"
                            class="${properties.kcButtonClass!}"
                            name="login"
                            id="kc-login"
                            type="submit">
                        ${msg("doLogIn")}
                    </button>

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
                            <#-- Keycloak's built-in identity providers (GitHub, Google, etc.) don't
                                 populate iconClasses (a legacy Font-Awesome-era property), so fall
                                 back to inline SVGs keyed by provider alias for the common ones. -->
                            <#elseif p.alias == "github">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                                    <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
                                </svg>
                            <#elseif p.alias == "google">
                                <svg width="20" height="20" viewBox="0 0 24 24" aria-hidden="true">
                                    <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                                    <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                                    <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                                    <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                                </svg>
                            <#elseif p.alias == "microsoft">
                                <svg width="20" height="20" viewBox="0 0 24 24" aria-hidden="true">
                                    <path fill="#F25022" d="M1 1h10.5v10.5H1z"/>
                                    <path fill="#7FBA00" d="M12.5 1H23v10.5H12.5z"/>
                                    <path fill="#00A4EF" d="M1 12.5h10.5V23H1z"/>
                                    <path fill="#FFB900" d="M12.5 12.5H23V23H12.5z"/>
                                </svg>
                            </#if>
                            <span>${p.displayName!}</span>
                        </a>
                    </#list>
                </div>
            </#if>
        </div>
    <#-- section == "info" intentionally not handled: displayInfo=false above means
         template.ftl never requests it, since it only ever duplicated the Create Account
         link already shown in itlusions-form-options within the form itself. -->
    </#if>
</@layout.registrationLayout>