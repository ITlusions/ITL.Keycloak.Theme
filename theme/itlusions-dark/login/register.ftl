<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm'); section>
    <#if section == "header">
        ${msg("registerTitle")}
    <#elseif section == "form">
        <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.registrationAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <label for="firstName" class="${properties.kcLabelClass!}">${msg("firstName")}</label>
                <input type="text" id="firstName" class="${properties.kcInputClass!}" name="firstName" 
                       value="${(register.formData.firstName!'')}" 
                       autocomplete="given-name"
                       placeholder="Enter your first name"
                       aria-invalid="<#if messagesPerField.existsError('firstName')>true</#if>" />
                <#if messagesPerField.existsError('firstName')>
                    <span class="${properties.kcInputErrorMessageClass!}">
                        ${kcSanitize(messagesPerField.get('firstName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <label for="lastName" class="${properties.kcLabelClass!}">${msg("lastName")}</label>
                <input type="text" id="lastName" class="${properties.kcInputClass!}" name="lastName" 
                       value="${(register.formData.lastName!'')}" 
                       autocomplete="family-name"
                       placeholder="Enter your last name"
                       aria-invalid="<#if messagesPerField.existsError('lastName')>true</#if>" />
                <#if messagesPerField.existsError('lastName')>
                    <span class="${properties.kcInputErrorMessageClass!}">
                        ${kcSanitize(messagesPerField.get('lastName'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label>
                <input type="text" id="email" class="${properties.kcInputClass!}" name="email" 
                       value="${(register.formData.email!'')}" 
                       autocomplete="email"
                       placeholder="Enter your email address"
                       aria-invalid="<#if messagesPerField.existsError('email')>true</#if>" />
                <#if messagesPerField.existsError('email')>
                    <span class="${properties.kcInputErrorMessageClass!}">
                        ${kcSanitize(messagesPerField.get('email'))?no_esc}
                    </span>
                </#if>
            </div>

            <#if !realm.registrationEmailAsUsername>
                <div class="${properties.kcFormGroupClass!}">
                    <label for="username" class="${properties.kcLabelClass!}">${msg("username")}</label>
                    <input type="text" id="username" class="${properties.kcInputClass!}" name="username" 
                           value="${(register.formData.username!'')}" 
                           autocomplete="username"
                           placeholder="Choose a username"
                           aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />
                    <#if messagesPerField.existsError('username')>
                        <span class="${properties.kcInputErrorMessageClass!}">
                            ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <#if passwordRequired??>
                <div class="${properties.kcFormGroupClass!}">
                    <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
                    <input type="password" id="password" class="${properties.kcInputClass!}" name="password" 
                           autocomplete="new-password"
                           placeholder="Create a secure password"
                           aria-invalid="<#if messagesPerField.existsError('password')>true</#if>" />
                    <#if messagesPerField.existsError('password')>
                        <span class="${properties.kcInputErrorMessageClass!}">
                            ${kcSanitize(messagesPerField.get('password'))?no_esc}
                        </span>
                    </#if>
                </div>

                <div class="${properties.kcFormGroupClass!}">
                    <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("confirmPassword")}</label>
                    <input type="password" id="password-confirm" class="${properties.kcInputClass!}" name="password-confirm" 
                           autocomplete="new-password"
                           placeholder="Confirm your password"
                           aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>" />
                    <#if messagesPerField.existsError('password-confirm')>
                        <span class="${properties.kcInputErrorMessageClass!}">
                            ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                        </span>
                    </#if>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <input class="${properties.kcButtonClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("doRegister")}"/>
            </div>

            <div class="${properties.kcFormOptionsClass!}">
                <a href="${url.loginUrl}">${msg("backToLogin")}</a>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>