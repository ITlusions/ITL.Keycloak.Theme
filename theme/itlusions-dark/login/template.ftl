<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="robots" content="noindex, nofollow">
    <meta name="color-scheme" content="dark">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title><#if realm.displayName??>${realm.displayName}<#else>ITlusions Dark</#if> - Authentication</title>
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
    <div class="login-pf-page">
        <div class="card-pf itlusions-card">
            <!-- Logo and Header -->
            <div class="itl-form-container">
                <div class="kc-logo-text">
                    🌙 ITlusions
                </div>
                
                <!-- Language Selector -->
                <#if realm.internationalizationEnabled && locale.supported?size gt 1>
                    <div class="language-selector">
                        <select onchange="window.location.href=this.value" class="itl-input">
                            <#list locale.supported as l>
                                <option value="${l.url}" <#if locale.currentLanguageTag == l.label>selected</#if>>${l.label}</option>
                            </#list>
                        </select>
                    </div>
                </#if>

                <!-- Messages -->
                <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                    <div class="itl-message-container">
                        <div class="<#if message.type = 'success'>itl-success-message<#elseif message.type = 'warning'>itl-warning-message<#elseif message.type = 'error'>itl-error-message<#elseif message.type = 'info'>itl-info-message</#if>">
                            <span class="itl-message-icon">
                                <#if message.type = 'success'>✅<#elseif message.type = 'warning'>⚠️<#elseif message.type = 'error'>❌<#elseif message.type = 'info'>ℹ️</#if>
                            </span>
                            <span>${kcSanitize(message.summary)?no_esc}</span>
                        </div>
                    </div>
                </#if>

                <!-- Social Providers Section -->
                <#nested "socialProviders">

                <!-- Main Form Content -->
                <div class="itl-form-header">
                    <#nested "header">
                </div>

                <#nested "form">

                <!-- Additional Info -->
                <#if displayInfo>
                    <#nested "info">
                </#if>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="itl-footer">
        <p style="text-align: center; color: var(--itl-dark-text-muted); font-size: 0.75rem; margin-top: 2rem;">
            &copy; ${.now?string('yyyy')} 
            <a href="https://itlusions.nl" target="_blank" style="color: var(--itl-primary-light);">ITlusions</a> 
            - Dark Mode
        </p>
    </div>

    <!-- Dark Theme Enhanced Scripts -->
    <script>
        // Auto-focus first input
        document.addEventListener('DOMContentLoaded', function() {
            const firstInput = document.querySelector('input[type="text"], input[type="email"], input[type="password"]');
            if (firstInput) {
                firstInput.focus();
            }
        });

        // Enhanced form validation with dark theme styling
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const submitButton = form.querySelector('input[type="submit"], button[type="submit"]');
                    if (submitButton) {
                        submitButton.disabled = true;
                        const originalText = submitButton.value || submitButton.innerHTML;
                        submitButton.value = '🔄 Processing...';
                        submitButton.style.opacity = '0.7';
                        
                        // Reset after 10 seconds if still processing
                        setTimeout(function() {
                            if (submitButton.disabled) {
                                submitButton.disabled = false;
                                submitButton.value = originalText;
                                submitButton.style.opacity = '1';
                            }
                        }, 10000);
                    }
                });
            }
        });

        // Dark theme preference detection and storage
        document.addEventListener('DOMContentLoaded', function() {
            // Store user's preference for dark theme
            localStorage.setItem('itlusions-theme-preference', 'dark');
            
            // Add smooth transitions
            document.body.style.transition = 'background-color 0.3s ease, color 0.3s ease';
            
            // Enhanced input focus effects for dark theme
            const inputs = document.querySelectorAll('.itl-input');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.style.transform = 'scale(1.02)';
                    this.style.transition = 'transform 0.2s ease, box-shadow 0.2s ease';
                });
                
                input.addEventListener('blur', function() {
                    this.style.transform = 'scale(1)';
                });
            });
        });

        // Keyboard navigation enhancement
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Tab') {
                document.body.classList.add('keyboard-navigation');
            }
        });

        document.addEventListener('mousedown', function() {
            document.body.classList.remove('keyboard-navigation');
        });
    </script>

    <style>
        /* Additional dark theme enhancements */
        .language-selector {
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .language-selector select {
            max-width: 150px;
            margin: 0 auto;
        }

        .itl-form-title {
            color: var(--itl-dark-text);
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .itl-message-container {
            margin-bottom: 1.5rem;
        }

        .itl-warning-message {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            background: rgba(245, 158, 11, 0.1);
            border: 1px solid rgba(245, 158, 11, 0.3);
            border-radius: 0.5rem;
            color: #fcd34d;
            font-size: 0.875rem;
        }

        .itl-info-message {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            background: rgba(6, 182, 212, 0.1);
            border: 1px solid rgba(6, 182, 212, 0.3);
            border-radius: 0.5rem;
            color: #67e8f9;
            font-size: 0.875rem;
        }

        /* Keyboard navigation styles for dark theme */
        .keyboard-navigation *:focus {
            outline: 2px solid var(--itl-primary) !important;
            outline-offset: 2px !important;
        }

        /* Loading animation for dark theme */
        @keyframes spin-dark {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .itl-loading {
            display: inline-block;
            width: 1rem;
            height: 1rem;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin-dark 1s linear infinite;
        }
    </style>
</body>
</html>
</#macro>