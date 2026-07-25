# Development Guide

This guide explains how to set up your development environment, build the theme, and test it locally.

---

## Prerequisites

- **Node.js** ≥ 16.x (Check: `node --version`)
- **npm** ≥ 8.x (Check: `npm --version`)
- **Docker** (optional, for full Keycloak testing)
- **Git** (for version control)

---

## Setup

### 1. Install Dependencies

```bash
cd d:\repos\ITL.Keycloak.Theme
npm install
```

### 2. Build the Theme

```bash
# Production build
npm run build

# Output: theme/ directory with compiled assets
```

### 3. Watch Mode (for development)

```bash
# Rebuilds on file changes
npm run watch

# Open another terminal and start preview server
npm run serve
```

---

## Available npm Scripts

| Script | Purpose |
|---|---|
| `npm run build` | Production build |
| `npm run watch` | Watch mode (rebuild on changes) |
| `npm run serve` | Start preview HTTP server |
| `npm run clean` | Delete build output |
| `npm run dev` | Build + watch + serve (all-in-one) |

---

## Preview & Testing

### HTML Preview (No Server Needed)

The `preview/` folder contains standalone HTML files that mimic Keycloak output:

```
preview/
├── light/
│   ├── index.html              # Navigation page
│   ├── login.html
│   ├── register.html
│   ├── error.html
│   ├── otp.html
│   ├── reset-password.html
│   └── authenticated.html
└── dark/
    ├── index.html
    ├── login.html
    ├── register.html
    └── ... (same structure)
```

**To view:**
1. Open `preview/light/index.html` in browser
2. Click links to navigate between pages
3. Test responsive design with DevTools (F12 → Device Toolbar)

### Local Preview Server

```bash
npm run serve

# Open: http://localhost:8080/preview/
```

---

## Responsive Testing

### Chrome DevTools Method

1. Open DevTools (F12)
2. Click device toolbar icon (or Ctrl+Shift+M)
3. Select preset device or custom dimensions:
   - 320px — iPhone SE, extra-small phones
   - 375px — iPhone X, 12, 13
   - 426px — Android standard
   - 768px — iPad Mini
   - 1024px — iPad Air
   - 1920px — Desktop

### Device Testing (Recommended)

Test on actual devices for best results:

| Device | Recommended Sizes |
|---|---|
| iPhone SE | 375×667 |
| iPhone 14 Pro | 393×852 |
| Samsung Galaxy S22 | 360×800 |
| iPad Mini | 768×1024 |
| iPad Air | 1024×1366 |
| Desktop | 1920×1080 |

---

## File Structure

### CSS Files

```
theme/itlusions/login/resources/css/
├── login.css              # Main login/register/error/otp styles
└── authenticated.css      # Success page styles
```

**Make CSS changes here** — imported into FreeMarker templates

### JavaScript Files

```
theme/itlusions/login/resources/js/
├── interactive-background.js   # Mouse-tracking background
└── authenticated.js            # Success page animations
```

### FreeMarker Templates

```
theme/itlusions/login/
├── template.ftl                # Base template
├── login.ftl                   # Login page
├── register.ftl                # Registration page
├── error.ftl                   # Error page
├── login-otp.ftl               # OTP input
├── login-reset-password.ftl    # Password reset
└── authenticated.ftl           # Success page
```

**FreeMarker automatically includes CSS/JS** — no manual wiring needed

---

## Common Development Tasks

### Change Theme Colors

Edit `theme/itlusions/login/resources/css/login.css`:

```css
:root {
  --itl-primary: #2563eb;        /* Change blue primary color */
  --itl-primary-dark: #1d4ed8;
  --itl-error: #dc2626;          /* Change error red */
  /* ... other colors */
}
```

Save → Rebuild (`npm run build`) → Refresh browser

### Add Responsive Rule

Edit media query section in `login.css`:

```css
@media (max-width: 640px) {
  /* Mobile styles here */
  .itlusions-card {
    padding: 1rem;  /* Smaller on mobile */
  }
}

@media (min-width: 641px) {
  /* Tablet+ styles here */
  .itlusions-card {
    padding: 2rem;  /* Larger on desktop */
  }
}
```

### Modify Form Fields

Edit `theme/itlusions/login/register.ftl`:

```ftl
<div class="${properties.kcFormGroupClass!}">
  <label for="email" class="${properties.kcLabelClass!}">${msg("email")}</label>
  <input type="email" id="email" class="${properties.kcInputClass!}" name="email" />
</div>
```

Changes appear in next build.

### Add New Animation

Edit `theme/itlusions/login/resources/css/login.css`:

```css
@keyframes slideInRight {
  from {
    opacity: 0;
    transform: translateX(20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* Apply to element */
.itlusions-card {
  animation: slideInRight 0.6s ease-out;
}
```

---

## Testing Checklist

### Visual Testing
- [ ] All pages render correctly in preview
- [ ] Colors match design specifications
- [ ] Animations are smooth (60fps)
- [ ] Typography is readable on all sizes

### Responsive Testing
- [ ] 320px mobile — no horizontal scroll
- [ ] 375px phone — form fields fit
- [ ] 768px tablet — layout adapts
- [ ] 1920px desktop — content centered
- [ ] Landscape orientation — works on phones

### Functionality Testing
- [ ] Form inputs accept text
- [ ] Buttons are clickable
- [ ] Links work (if present)
- [ ] Error messages display
- [ ] Links in footer work

### Accessibility Testing
- [ ] Keyboard navigation works (Tab key)
- [ ] Focus states visible
- [ ] Color contrast adequate
- [ ] Text readable at 200% zoom
- [ ] Screen reader friendly (test with NVDA/JAWS)

### Browser Testing
- [ ] Chrome/Edge (latest)
- [ ] Firefox (latest)
- [ ] Safari (macOS/iOS if available)
- [ ] Mobile browsers

---

## Debugging

### CSS Not Updating?

1. Clear browser cache: `Ctrl+Shift+Delete`
2. Rebuild theme: `npm run build`
3. Hard refresh: `Ctrl+Shift+R` (or Cmd+Shift+R on Mac)

### Animations Stuttering?

1. Check CSS is using GPU-accelerated properties:
    - [OK] Good: `transform`, `opacity`
   - ❌ Avoid: `left`, `top`, `width`
2. Reduce animation duration on mobile
3. Check device performance (DevTools → Performance tab)

### Layout Issues?

1. Check responsive breakpoints match your viewport
2. Verify media query syntax is correct
3. Test in incognito mode (no extensions interfering)
4. Check browser console for errors (F12 → Console tab)

---

## File Dependencies

```
login.ftl
  └── template.ftl
       ├── login.css
       ├── interactive-background.js
       └── (other resources)

authenticated.ftl
  └── template.ftl
       ├── authenticated.css
       ├── authenticated.js
       └── (other resources)
```

**Important:** CSS/JS are automatically loaded from `resources/` folder by Keycloak.

---

## 🔄 Build Process

### What Happens During Build?

```
npm run build

1. Webpack processes source files
2. CSS is minified
3. JS is transpiled and minified
4. Assets copied to theme/ folder
5. Ready for deployment!
```

### Output Structure

```
theme/itlusions/
├── login/
│   ├── resources/
│   │   ├── css/
│   │   │   ├── login.css (production)
│   │   │   └── authenticated.css
│   │   ├── js/
│   │   │   └── (compiled JS)
│   │   └── img/
│   │       └── (images)
│   ├── *.ftl files (unchanged)
│   └── messages/
│       └── (translations)
```

---

## 🚀 Next Steps

- **Ready to test?** → Open `preview/light/index.html` in browser
- **Want to customize?** → Edit `theme/itlusions/login/resources/css/login.css`
- **Ready to deploy?** → See [Deployment Guide](DEPLOYMENT.md)
- **Questions?** → Check specific documentation pages

---

**Happy developing! 🎨**
