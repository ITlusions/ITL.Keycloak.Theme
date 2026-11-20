<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false; section>
    <#if section == "header">
        <link rel="stylesheet" href="${url.resourcesPath}/css/authenticated.css">
        <div class="kc-header">
            <h1>ITlusions</h1>
        </div>
        <div class="lang-switch">
            <button data-lang="en" class="active">English</button>
            <button data-lang="nl">Nederlands</button>
        </div>

    <#elseif section == "form">
        <div class="kc-form-wrapper">
            <div id="kc-authenticated">
                <div class="authenticated-content">
                    <div class="authenticated-icon">
                        <svg class="success-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                        </svg>
                    </div>
                    
                    <h1 class="authenticated-title" id="auth-title">
                        <#if locale == "nl">
                            Succesvol Geverifieerd
                        <#else>
                            Successfully Authenticated
                        </#if>
                    </h1>
                    
                    <p class="authenticated-message" id="auth-message">
                        <#if locale == "nl">
                            U bent succesvol aangemeld bij het systeem.
                        <#else>
                            You have successfully logged in to the system.
                        </#if>
                    </p>
                    
                    <p class="authenticated-subtitle" id="auth-subtitle">
                        <#if locale == "nl">
                            Dit venster wordt automatisch gesloten over <span id="countdown">5</span> seconden.
                        <#else>
                            This window will close automatically in <span id="countdown">5</span> seconds.
                        </#if>
                    </p>
                    
                    <#if client?? && client.baseUrl??>
                        <a href="${client.baseUrl}" class="authenticated-button" id="back-button">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                            <span id="button-text">
                                <#if locale == "nl">
                                    Terug naar Applicatie
                                <#else>
                                    Back to Application
                                </#if>
                            </span>
                        </a>
                    </#if>
                </div>
            </div>
        </div>

        <footer>
            <p>&copy; 2026 <a href="https://itlusions.nl" target="_blank">ITlusions</a>. Your trusted partner in digital transformation.</p>
        </footer>

        <script>
            const CLOSE_DELAY = 5000;
            const CLIENT_URL = '${client.baseUrl?default("")}';
            
            const translations = {
                en: {
                    title: 'Successfully Authenticated',
                    message: 'You have successfully logged in to the system.',
                    subtitle_prefix: 'This window will close automatically in ',
                    subtitle_suffix: ' seconds.',
                    button: 'Back to Application'
                },
                nl: {
                    title: 'Succesvol Geverifieerd',
                    message: 'U bent succesvol aangemeld bij het systeem.',
                    subtitle_prefix: 'Dit venster wordt automatisch gesloten over ',
                    subtitle_suffix: ' seconden.',
                    button: 'Terug naar Applicatie'
                }
            };

            let currentLang = '<#if locale == "nl">nl<#else>en</#if>';
            let countdownInterval;
            let remaining = 5;

            function switchLanguage(lang) {
                currentLang = lang;
                document.querySelectorAll('.lang-switch button').forEach(btn => {
                    btn.classList.remove('active');
                    if (btn.dataset.lang === lang) {
                        btn.classList.add('active');
                    }
                });
                updateLanguage();
            }

            function updateLanguage() {
                const t = translations[currentLang];
                document.getElementById('auth-title').textContent = t.title;
                document.getElementById('auth-message').textContent = t.message;
                document.getElementById('button-text').textContent = t.button;
                updateSubtitle();
            }

            function updateSubtitle() {
                const t = translations[currentLang];
                const subtitle = document.getElementById('auth-subtitle');
                subtitle.innerHTML = t.subtitle_prefix + '<span id="countdown">' + remaining + '</span>' + t.subtitle_suffix;
            }

            function startCountdown() {
                remaining = 5;
                updateSubtitle();
                
                countdownInterval = setInterval(function() {
                    remaining--;
                    document.getElementById('countdown').textContent = remaining;
                    
                    if (remaining <= 0) {
                        clearInterval(countdownInterval);
                        if (CLIENT_URL) {
                            window.location.href = CLIENT_URL;
                        }
                    }
                }, 1000);
            }

            document.querySelectorAll('.lang-switch button').forEach(btn => {
                btn.addEventListener('click', function() {
                    switchLanguage(this.dataset.lang);
                });
            });

            startCountdown();
        </script>
    </#if>
</@layout.registrationLayout>
