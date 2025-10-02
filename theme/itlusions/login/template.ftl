<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title><#if realm.displayName??>${realm.displayName}<#else>ITlusions</#if> - Authentication</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    
    <!-- Google Fonts for Inter font family -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>

<body class="${properties.kcBodyClass!} ${bodyClass}">
    <!-- Header -->
    <header class="${properties.kcHeaderClass!}">
        <div class="${properties.kcHeaderWrapperClass!}">
            <h1>ITlusions</h1>
            <#if realm.internationalizationEnabled && locale.supported?size gt 1>
                <div class="language-dropdown">
                    <button class="itlusions-button itlusions-button--secondary" type="button">
                        ${locale.currentLanguageTag}
                    </button>
                    <div class="language-dropdown-content">
                        <#list locale.supported as l>
                            <a href="${l.url}">${l.label}</a>
                        </#list>
                    </div>
                </div>
            </#if>
        </div>
    </header>

    <!-- Main Content -->
    <main class="${properties.kcContentWrapperClass!}">
        <div class="${properties.kcFormCardClass!}">
            <!-- Form Header -->
            <div class="${properties.kcFormHeaderClass!}">
                <h1>
                    <#if realm.displayName??>
                        ${realm.displayName}
                    <#else>
                        Welcome to ITlusions
                    </#if>
                </h1>
                <p>Empowering Your DevOps Transformation</p>
            </div>

            <!-- Messages -->
            <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                <div class="alert-wrapper">
                    <div class="${properties.kcAlertClass!} <#if message.type = 'success'>${properties.kcAlertSuccessClass!}<#elseif message.type = 'warning'>${properties.kcAlertWarningClass!}<#elseif message.type = 'error'>${properties.kcAlertErrorClass!}<#elseif message.type = 'info'>${properties.kcAlertInfoClass!}</#if>">
                        <span>${kcSanitize(message.summary)?no_esc}</span>
                    </div>
                </div>
            </#if>

            <!-- Main Form Content -->
            <#nested "form">

            <!-- Additional Info -->
            <#if displayInfo>
                <div class="itlusions-form-options">
                    <#nested "info">
                </div>
            </#if>
        </div>
    </main>

    <!-- Footer -->
    <footer class="itlusions-footer">
        <p>
            &copy; ${.now?string('yyyy')} 
            <a href="https://itlusions.nl" target="_blank">ITlusions</a>. 
            Your trusted partner in digital transformation.
        </p>
    </footer>

    <!-- Scripts -->
    <script>
        // Auto-focus first input
        document.addEventListener('DOMContentLoaded', function() {
            const firstInput = document.querySelector('input[type="text"], input[type="email"], input[type="password"]');
            if (firstInput) {
                firstInput.focus();
            }
        });

        // Enhanced form validation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const submitButton = form.querySelector('input[type="submit"], button[type="submit"]');
                    if (submitButton) {
                        submitButton.disabled = true;
                        submitButton.innerHTML = '<span class="itlusions-loading"></span> Processing...';
                    }
                });
            }
        });

        // Language dropdown functionality
        document.addEventListener('DOMContentLoaded', function() {
            const dropdown = document.querySelector('.language-dropdown');
            if (dropdown) {
                const button = dropdown.querySelector('button');
                const content = dropdown.querySelector('.language-dropdown-content');
                
                if (button && content) {
                    button.addEventListener('click', function(e) {
                        e.preventDefault();
                        content.style.display = content.style.display === 'block' ? 'none' : 'block';
                    });
                    
                    // Close dropdown when clicking outside
                    document.addEventListener('click', function(e) {
                        if (!dropdown.contains(e.target)) {
                            content.style.display = 'none';
                        }
                    });
                }
            }
        });
    </script>
</body>
</html>
</#macro>