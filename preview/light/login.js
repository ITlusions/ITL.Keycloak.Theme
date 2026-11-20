// Language translations
const translations = {
    en: {
        'form-title': 'Welcome to ITlusions',
        'form-subtitle': 'Empowering Your DevOps Transformation',
        'label-username': 'Username or Email',
        'label-password': 'Password',
        'label-remember': 'Remember me',
        'btn-signin': 'Sign In',
        'forgot-password': 'Forgot Password?',
        'create-account': 'Create Account',
        'social-github-text': 'Github'
    },
    nl: {
        'form-title': 'Welkom bij ITlusions',
        'form-subtitle': 'Versterk Uw DevOps Transformatie',
        'label-username': 'Gebruikersnaam of E-mailadres',
        'label-password': 'Wachtwoord',
        'label-remember': 'Onthoud mij',
        'btn-signin': 'Inloggen',
        'forgot-password': 'Wachtwoord vergeten?',
        'create-account': 'Account aanmaken',
        'social-github-text': 'Github'
    }
};

let currentLang = 'en';

function setLanguage(lang) {
    currentLang = lang;
    document.getElementById('lang-btn').textContent = lang;

    Object.keys(translations[lang]).forEach(key => {
        const element = document.getElementById(key);
        if (element) {
            element.textContent = translations[lang][key];
        }
    });
}

function handleSubmit(event) {
    event.preventDefault();
    alert('Form submitted (preview mode)');
}

// Interactive background effect - mouse tracking
function initInteractiveBackground() {
    const themeElement = document.querySelector('.itlusions-theme');

    if (!themeElement) {
        console.log('ITlusions theme element not found');
        return;
    }

    const mouseSensitivity = 20;

    function handleMouseMove(e) {
        const windowWidth = window.innerWidth;
        const windowHeight = window.innerHeight;

        const mouseX = (e.clientX / windowWidth) * 100;
        const mouseY = (e.clientY / windowHeight) * 100;

        const moveX = (mouseX - 50) / mouseSensitivity;
        const moveY = (mouseY - 50) / mouseSensitivity;

        themeElement.style.setProperty('--mouse-x', `${moveX}%`);
        themeElement.style.setProperty('--mouse-y', `${moveY}%`);
    }

    document.addEventListener('mousemove', handleMouseMove);

    document.addEventListener('mouseleave', function() {
        themeElement.style.setProperty('--mouse-x', '0%');
        themeElement.style.setProperty('--mouse-y', '0%');
    });

    themeElement.style.setProperty('--mouse-x', '0%');
    themeElement.style.setProperty('--mouse-y', '0%');

    console.log('ITlusions interactive background initialized');
}

// Initialize on DOM ready
if (document.readyState !== 'loading') {
    initInteractiveBackground();
} else {
    document.addEventListener('DOMContentLoaded', initInteractiveBackground);
}
