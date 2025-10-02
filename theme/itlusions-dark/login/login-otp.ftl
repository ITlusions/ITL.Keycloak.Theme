<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section="header">
        ${msg("doLogIn")}
    <#elseif section="form">
        <form id="kc-otp-login-form" class="itl-form" action="${url.loginAction}" method="post">
            <div class="itl-form-container">
                <div class="itl-form-fieldset">
                    <#if otpLogin.userOtpCredentials?size gt 1>
                        <div class="itl-form-field">
                            <label class="itl-label" for="kc-otp-credential">${msg("loginChooseAuthenticator")}</label>
                            
                            <div class="itl-radio-group">
                                <#list otpLogin.userOtpCredentials as otpCredential>
                                    <div class="itl-radio-option">
                                        <input 
                                            id="kc-otp-credential-${otpCredential?index}" 
                                            class="itl-radio" 
                                            type="radio" 
                                            name="selectedCredentialId" 
                                            value="${otpCredential.id}" 
                                            <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if>
                                        >
                                        <label for="kc-otp-credential-${otpCredential?index}" class="itl-radio-label">
                                            ${otpCredential.userLabel}
                                        </label>
                                    </div>
                                </#list>
                            </div>
                        </div>
                    </#if>

                    <div class="itl-form-field">
                        <label class="itl-label" for="otp">${msg("loginOtpOneTime")}</label>
                        <#if messagesPerField.existsError('totp')>
                            <div class="itl-error-message" role="alert">
                                <span class="itl-error-icon">⚠</span>
                                ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                            </div>
                        </#if>
                        <input 
                            id="otp" 
                            name="otp" 
                            autocomplete="off" 
                            type="text" 
                            class="itl-input <#if messagesPerField.existsError('totp')>itl-input--error</#if>"
                            dir="auto" 
                            value="" 
                            aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>"
                            placeholder="${msg('loginOtpOneTime')}"
                        />
                    </div>

                    <div class="itl-form-options">
                        <!-- Additional form options can be added here -->
                    </div>
                </div>

                <div class="itl-form-actions">
                    <input 
                        class="itl-button itl-button--primary" 
                        name="login" 
                        id="kc-login" 
                        type="submit" 
                        value="${msg('doLogIn')}"
                    />
                </div>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>