<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section == "header">
        Welcome to ITlusions
    <#elseif section == "form">
        <div class="itlusions-card">
            <div class="itlusions-form-header">
                <h1>Welcome to ITlusions</h1>
                <p>Empowering Your DevOps Transformation</p>
                <p>Your Keycloak instance is successfully configured and ready to use.</p>
            </div>
            
            <div class="itlusions-form-options">
                <a href="/auth/admin/" class="itlusions-button itlusions-button--primary">
                    Administration Console
                </a>
                <a href="https://itlusions.nl" class="itlusions-button itlusions-button--secondary" target="_blank">
                    Visit ITlusions.nl
                </a>
            </div>
        </div>
    </#if>
</@layout.registrationLayout>