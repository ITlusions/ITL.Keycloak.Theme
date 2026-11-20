<#--
  ITlusions Keycloak Theme - Login (FreeMarker preview)

  This is a FreeMarker version of preview/light/login.html, kept next to the
  static preview so the two can be diffed visually. It follows the exact
  markup/classes used by login.css and login.js in this folder.

  To promote into the real theme:
    - The "header"/"form"/"info" sections below map 1:1 onto
      theme/itlusions/login/login.ftl (rendered inside
      theme/itlusions/login/template.ftl's registrationLayout macro).
    - login.css in this folder already matches
      theme/itlusions/login/resources/css/login.css.
    - login.js's mouse-tracking logic already matches
      theme/itlusions/login/resources/js/interactive-background.js
      (loaded there via theme.properties: scripts=js/interactive-background.js).
    - The <#if>/<#list>/${...} directives below are the same ones Keycloak's
      base theme uses, so this file can replace login.ftl content directly.
-->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section == "header">
        ${msg("loginAccountTitle")}
    <#elseif section == "form">
        <div id="kc-form">
            <#if realm.password>
                <form id="kc-form-login" class="itlusions-form" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
                    <#if !usernameHidden??>
                        <div class="itlusions-form-group">
                            <label for="username" class="itlusions-label">
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
                                   class="itlusions-input"
                                   name="username"
                                   value="${(login.username!'')}"
                                   type="text"
                                   autofocus
                                   autocomplete="username"
                                   placeholder="<#if !realm.loginWithEmailAllowed>Enter your username<#elseif !realm.registrationEmailAsUsername>Enter username or email<#else>Enter your email</#if>"
                                   aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
                            <#if messagesPerField.existsError('username','password')>
                                <span class="itlusions-alert itlusions-alert--error">
                                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                </span>
                            </#if>
                        </div>
                    </#if>

                    <div class="itlusions-form-group">
                        <label for="password" class="itlusions-label">
                            ${msg("password")}
                        </label>
                        <input tabindex="3"
                               id="password"
                               class="itlusions-input"
                               name="password"
                               type="password"
                               autocomplete="current-password"
                               placeholder="Enter your password"
                               aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>" />
                        <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                            <span class="itlusions-alert itlusions-alert--error">
                                ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                            </span>
                        </#if>
                    </div>

                    <div class="itlusions-form-group">
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
                            class="itlusions-button itlusions-button--primary"
                            name="login"
                            id="kc-login"
                            type="submit"
                            style="animation: scaleIn 0.6s ease-out 0.45s backwards;">
                        ${msg("doLogIn")}
                    </button>

                    <div class="itlusions-form-options">
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
                <div class="itlusions-social-providers">
                    <#list social.providers as p>
                        <a id="social-${p.alias}"
                           class="itlusions-button itlusions-button--social"
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
