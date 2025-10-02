<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section == "header">
        ${msg("emailForgotTitle")}
    <#elseif section == "form">
        <form id="kc-reset-password-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <label for="username" class="${properties.kcLabelClass!}">
                    <#if !realm.loginWithEmailAllowed>
                        ${msg("username")}
                    <#else>
                        ${msg("usernameOrEmail")}
                    </#if>
                </label>
                <input type="text" id="username" name="username" class="${properties.kcInputClass!}" 
                       autofocus 
                       value="${(auth.attemptedUsername!'')}"
                       placeholder="<#if !realm.loginWithEmailAllowed>Enter your username<#else>Enter your username or email</#if>"
                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                <#if messagesPerField.existsError('username')>
                    <span class="${properties.kcInputErrorMessageClass!}">
                        ${kcSanitize(messagesPerField.get('username'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <input class="${properties.kcButtonClass!} ${properties.kcButtonLargeClass!}" 
                       type="submit" 
                       value="${msg("doSubmit")}" />
            </div>

            <div class="${properties.kcFormOptionsClass!}">
                <a href="${url.loginUrl}">${msg("backToLogin")}</a>
            </div>
        </form>
    <#elseif section == "info">
        <div class="itlusions-form-options">
            ${msg("resetPasswordMessage")}
        </div>
    </#if>
</@layout.registrationLayout>