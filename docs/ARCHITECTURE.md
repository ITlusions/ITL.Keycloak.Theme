# Architecture Guide

This guide explains how the ITLusions Keycloak theme is structured and how its components work together.

---

## Overall Architecture

```
User Browser
     ↓
Keycloak Server
     ↓
Theme (itlusions)
  ├── FreeMarker Templates (.ftl files)
  │    └── Render HTML pages
  ├── CSS Stylesheets (.css files)
  │    └── Style the pages (responsive design)
  ├── JavaScript (.js files)
  │    └── Add interactivity (animations, events)
  └── Resources (images, fonts)
       └── Static assets
```

---

## Directory Structure

### Production Theme

```
theme/itlusions/
├── account/                    # Account management (profile, password)
│   └── theme.properties       # Account theme config
├── login/                      # Login/auth pages (main theme)
│   ├── template.ftl           # Base template for all login pages
│   ├── login.ftl              # Login form page
│   ├── register.ftl           # Registration form page
│   ├── error.ftl              # Error page
│   ├── authenticated.ftl      # Success/authenticated page
│   ├── login-otp.ftl          # OTP/2FA input page
│   ├── login-reset-password.ftl # Password reset page
│   ├── user-profile-commons.ftl # User profile fields
│   ├── theme.properties       # Login theme config
│   ├── messages/              # Translations
│   │   ├── messages_en.properties
│   │   └── messages_nl.properties
│   └── resources/
│       ├── css/
│       │   ├── login.css          # Main styles (responsive + animations)
│       │   └── authenticated.css  # Success page styles
│       ├── js/
│       │   ├── interactive-background.js  # Background animation
│       │   └── authenticated.js           # Success page animation
│       └── img/
│           ├── hero-bg.jpg        # Background image
│           └── logo.png           # Brand logo
└── welcome/                    # Welcome/welcome page
    └── theme.properties
```

### Preview Folder

```
preview/
├── light/                      # Light theme previews (standalone HTML)
│   ├── index.html             # Navigation/index page
│   ├── login.html             # Login preview
│   ├── register.html          # Registration preview
│   ├── error.html             # Error preview
│   ├── authenticated.html     # Success preview
│   ├── otp.html               # OTP preview
│   └── reset-password.html    # Password reset preview
└── dark/                       # Dark theme previews
    ├── index.html
    ├── login.html
    └── (same structure)
```

---

## FreeMarker Template System

### Base Template (`template.ftl`)

All login pages inherit from the base template:

```ftl
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=true; section>
  <#if section == "header">
    <!-- Page title goes here -->
    Page Title
  <#elseif section == "form">
    <!-- Form content goes here -->
    <form>...</form>
  <#else>
    <!-- Info section -->
  </#if>
</@layout.registrationLayout>
```

### Page Sections

| Section | Purpose | Example |
|---|---|---|
| `header` | Page title | `${msg("loginAccountTitle")}` |
| `form` | Main content | `<form id="kc-form-login">...</form>` |
| info | Additional info | Footnotes, links |

### Using Keycloak Variables

```ftl
${msg("key")}                          <!-- Localized message -->
${url.loginAction}                     <!-- Form submit URL -->
${realm.password}                      <!-- Check if password auth enabled -->
${register.formData.username!''}       <!-- Form field value -->
${messagesPerField.get('username')}    <!-- Error message -->
```

---

## CSS Architecture

### CSS Variables System

```css
:root {
  /* Colors */
  --itl-primary: #2563eb;
  --itl-error: #dc2626;
  
  /* Spacing */
  --itl-spacing-md: 1rem;
  --itl-spacing-lg: 1.5rem;
  
  /* Typography */
  --itl-font-family: 'Inter', sans-serif;
}
```

**Benefits:**
- Change colors globally by updating one variable
- Consistent spacing across theme
- Easy dark mode support

### Responsive Design

```css
/* Mobile First - Base styles for 320px */
.card {
  padding: 1rem;
  font-size: 1.25rem;
}

/* Tablet - 641px+ */
@media (min-width: 641px) {
  .card {
    padding: 1.75rem;
    font-size: 1.625rem;
  }
}

/* Desktop - 1025px+ */
@media (min-width: 1025px) {
  .card {
    padding: 2.5rem;
    font-size: 1.875rem;
  }
}
```

### Animation System

```css
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Apply animation with stagger */
.card {
  animation: fadeIn 0.6s ease-out 0.1s both;
}
```

---

## JavaScript Components

### Interactive Background (`interactive-background.js`)

Enables mouse-tracking background effect on login page:

```javascript
// On mouse move, background shifts based on cursor position
document.addEventListener('mousemove', (e) => {
  // Calculate background position
  // Update CSS for parallax effect
});
```

**Usage:** Automatically loaded in `template.ftl`

### Success Page Animation (`authenticated.js`)

Handles animations on authenticated/success page:

```javascript
// Animate checkmark icon
// Animate success message
// Handle countdown timer (if present)
```

**Usage:** Automatically loaded in `authenticated.ftl`

---

## 📊 Component Hierarchy

### Login Form Component

```
template.ftl (base)
  ├── Header section
  │   └── h1 "Sign in to your account"
  │
  ├── Form section
  │   ├── Form Group
  │   │   ├── Label "Username"
  │   │   └── Input field
  │   ├── Form Group
  │   │   ├── Label "Password"
  │   │   └── Input field
  │   ├── Form Group
  │   │   ├── Checkbox "Remember me"
  │   │   └── Login button
  │   └── Form Options
  │       ├── "Forgot password?" link
  │       └── "Register" link
  │
  └── Social login (if enabled)
      ├── Google button
      ├── Microsoft button
      └── Other providers
```

### Registration Form Component

```
template.ftl (base)
  ├── Header section
  │   └── h1 "Create account"
  │
  └── Form section
      ├── Form Group (First Name)
      ├── Form Group (Last Name)
      ├── Form Group (Email)
      ├── Form Group (Username) - if needed
      ├── Form Group (Password)
      ├── Form Group (Confirm Password)
      └── Submit button
```

---

## 🎯 CSS Class Conventions

### Naming Pattern

All CSS classes follow the pattern: `itlusions-<component>`

```css
/* Main layout */
.itlusions-container           /* Outer wrapper */
.itlusions-content-wrapper     /* Content area */
.itlusions-card                /* Form card */

/* Header */
.itlusions-header-wrapper      /* Header container */
.itlusions-header h1           /* Header title */

/* Forms */
.itlusions-form-group          /* Form field wrapper */
.itlusions-label               /* Form label */
.itlusions-input               /* Input fields */
.itlusions-button              /* Buttons */
.itlusions-checkbox            /* Custom checkbox */

/* Animations */
.itlusions-fade-in             /* Fade in animation */
.itlusions-slide-down          /* Slide down animation */
```

### Using in FreeMarker

```ftl
<div class="itlusions-card">
  <h1 class="itlusions-header h1">Sign in</h1>
  <form class="itlusions-form">
    <div class="itlusions-form-group">
      <label class="itlusions-label">Username</label>
      <input class="itlusions-input" />
    </div>
    <button class="itlusions-button">Login</button>
  </form>
</div>
```

---

## 🌍 Localization (i18n)

### Message Files

```
theme/itlusions/login/messages/
├── messages_en.properties     # English
└── messages_nl.properties     # Dutch
```

### Using Messages in Templates

```ftl
${msg("key")}                  <!-- Get localized message -->

<!-- Example -->
${msg("usernameOrEmail")}      <!-- Outputs: "Username or email" (in English) -->
${msg("doLogIn")}              <!-- Outputs: "Sign in" (in English) -->
```

### Common Message Keys

| Key | English | Dutch |
|---|---|---|
| `loginAccountTitle` | Sign in to your account | Meld je aan bij je account |
| `username` | Username | Gebruikersnaam |
| `password` | Password | Wachtwoord |
| `email` | Email | E-mail |
| `doLogIn` | Sign in | Inloggen |
| `doRegister` | Create account | Account maken |
| `doForgotPassword` | Forgot your password? | Wachtwoord vergeten? |

---

## 🔄 Data Flow

### Login Page Flow

```
1. User navigates to login page
   ↓
2. Keycloak renders login.ftl
   ↓
3. template.ftl includes CSS/JS
   ↓
4. Browser displays styled login form
   ↓
5. User enters credentials, clicks "Sign in"
   ↓
6. Form submits to ${url.loginAction}
   ↓
7. Keycloak validates credentials
   ↓
8. If valid → redirects to authenticated.ftl
   If invalid → renders login.ftl with error message
```

### Error Handling

```
error.ftl receives:
  - ${message.summary}           <!-- Error description -->
  - ${client.baseUrl}            <!-- Return to app link -->

Displays:
  - Error message
  - "Back to application" link
```

---

## 🔐 Security Considerations

### No Sensitive Data in Templates

❌ **DON'T:**
```ftl
<!-- Bad - exposes user data -->
<p>${user.password}</p>
```

✅ **DO:**
```ftl
<!-- Good - only reference Keycloak-provided safe variables -->
<input name="password" type="password" />
```

### CSRF Protection

Keycloak automatically handles CSRF tokens:

```ftl
<!-- Keycloak automatically includes CSRF token -->
<form action="${url.loginAction}" method="post">
  <!-- Token is automatically added by Keycloak -->
</form>
```

### Input Validation

```ftl
<!-- Use aria-invalid for accessibility -->
<input aria-invalid="<#if messagesPerField.existsError('username')>true</#if>" />

<!-- Display error messages -->
<#if messagesPerField.existsError('username')>
  <span class="error">${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}</span>
</#if>
```

---

## 📱 Responsive Design Architecture

### Mobile-First Approach

```css
/* Default: Mobile (320px) */
.card { padding: 1rem; font-size: 1.25rem; }

/* Tablet: 641px+ */
@media (min-width: 641px) {
  .card { padding: 1.75rem; font-size: 1.625rem; }
}

/* Desktop: 1025px+ */
@media (min-width: 1025px) {
  .card { padding: 2.5rem; font-size: 1.875rem; }
}
```

### 6 Breakpoints

| Breakpoint | Viewport | Devices |
|---|---|---|
| 0px | Base | Mobile (320px+) |
| 375px | Small phone | iPhone X, 12, 13 |
| 426px | Large phone | iPhone Max, Android |
| 641px | Tablet | iPad Mini |
| 769px | Medium tablet | iPad Air |
| 1025px+ | Desktop | Large screens |

---

## 🎭 Theme Variants

### itlusions (Light - Default)

```
Colors:
  Primary: #2563eb (Blue)
  Background: #ffffff (White)
  Text: #334155 (Dark Gray)
```

### itlusions-dark

```
Colors:
  Primary: #3b82f6 (Light Blue)
  Background: #0f172a (Almost Black)
  Text: #f1f5f9 (Light Gray)
```

### itlusions-neon

```
Colors:
  Primary: #00ff00 (Neon Green)
  Background: #000000 (Pure Black)
  Text: #ffffff (White)
```

---

## 🔗 File Dependencies

```
login.ftl
  imports template.ftl
    includes login.css
    includes interactive-background.js

authenticated.ftl
  imports template.ftl
    includes authenticated.css
    includes authenticated.js

register.ftl
  imports template.ftl
    includes login.css

error.ftl
  imports template.ftl
    includes login.css
```

---

## 🚀 Deployment Architecture

### How Keycloak Loads Themes

```
Keycloak Server
  ├── Theme directory: /themes/
  │   └── itlusions/
  │       ├── login/
  │       │   ├── resources/css/
  │       │   ├── resources/js/
  │       │   └── *.ftl files
  │       └── account/
  └── When user logs in → Renders login.ftl
      └── Automatically loads CSS/JS from resources/
```

### URL Mapping

| URL | Template |
|---|---|
| `/realms/master/login` | `login.ftl` |
| `/realms/master/register` | `register.ftl` |
| `/realms/master/login-actions/authenticate` | Handles login |
| `/realms/master/login-error` | `error.ftl` |

---

## 📚 Learning Resources

- [FreeMarker Documentation](https://freemarker.apache.org/docs/)
- [Keycloak Theme Development](https://www.keycloak.org/docs/latest/server_development/#_themes)
- [CSS Custom Properties](https://developer.mozilla.org/en-US/docs/Web/CSS/--*)
- [Responsive Design Basics](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design)

---

**Architecture Version:** 1.0.0  
**Last Updated:** 2026-07-26
