# ITLusions Keycloak Theme Documentation

Welcome to the ITLusions Keycloak Theme documentation. This theme provides professional, modern authentication pages for Keycloak with full responsive design and accessibility support.

## Documentation Index

### Getting Started
- **[Development Guide](DEVELOPMENT.md)** — How to build, test, and preview the theme locally
- **[Architecture](ARCHITECTURE.md)** — Theme structure, file organization, and how it works

### Design & Features
- **[Responsive Design](RESPONSIVE_DESIGN.md)** — Mobile-first responsive system across 6 breakpoints
- **[Animation System](ANIMATIONS.md)** — Cascading animations and performance optimization

### Operations
- **[Deployment Guide](DEPLOYMENT.md)** — How to deploy to Keycloak instances
- **[Theme Variants](VARIANTS.md)** — Light, Dark, and Neon theme options

---

## Theme Overview

### Available Themes
- **itlusions** — Light theme (default, professional)
- **itlusions-dark** — Dark theme (high contrast, OLED-friendly)
- **itlusions-neon** — Neon theme (experimental, vibrant)

### Pages Included
- Login form (username/password)
- Registration form (multi-field)
- One-Time Password (OTP) verification
- Password reset form
- Error/failure page
- Success/authenticated page

### Key Features
[OK] **Responsive** — 320px phones to 4K desktop
[OK] **Animated** — Smooth, cascading transitions
[OK] **Accessible** — WCAG compliance, touch-friendly
[OK] **Dark Mode** — Full dark theme support
[OK] **Customizable** — CSS variables for easy theming

---

## Quick Start

### Local Preview
```bash
npm install
npm run build
npm run serve
# Open browser: http://localhost:8080/preview/
```

### Local Development
```bash
# Watch mode - rebuilds on file changes
npm run watch

# Build for production
npm run build

# Test specific theme
npm run test:light
```

---

## File Structure

```
ITL.Keycloak.Theme/
├── theme/                      # Production theme files
│   ├── itlusions/             # Light theme
│   ├── itlusions-dark/        # Dark theme
│   └── itlusions-neon/        # Neon theme
├── preview/                    # HTML previews for testing
│   ├── light/                 # Light theme previews
│   └── dark/                  # Dark theme previews
├── docs/                       # This documentation
├── package.json               # NPM dependencies
└── webpack.config.js          # Build configuration
```

---

## Technology Stack

- **FreeMarker** — Template engine for Keycloak
- **CSS3** — Modern styling with custom properties
- **JavaScript** — Interactive features (minimal)
- **Webpack** — Build tool
- **Node.js** — Build environment

---

## Common Tasks

### Add a new UI element
See [Architecture](ARCHITECTURE.md) → "Adding New Components"

### Change colors
Edit CSS variables in `theme/itlusions/login/resources/css/login.css` (`:root` section)

### Modify responsive breakpoints
See [Responsive Design](RESPONSIVE_DESIGN.md) → "Breakpoint Customization"

### Test on different devices
See [Development Guide](DEVELOPMENT.md) → "Testing"

### Deploy to production
See [Deployment Guide](DEPLOYMENT.md) → "Deployment Steps"

---

## Best Practices

1. **Mobile-first** — Design for 320px first, scale up
2. **Progressive Enhancement** — Works without JavaScript
3. **Accessibility** — Test with screen readers, keyboard navigation
4. **Performance** — Minimize animations on low-end devices
5. **Testing** — Always test on real devices, not just DevTools

---

## Troubleshooting

**Page not loading?**
→ Check browser console for CSS/JS errors
→ Verify Keycloak theme is activated in realm settings

**Responsive design not working?**
→ Clear browser cache (Ctrl+Shift+Delete)
→ Check viewport meta tag is present
→ Verify media queries in CSS

**Animations stuttering on mobile?**
→ Check device performance (may be low-end)
→ Try disabling animations in browser DevTools
→ See [Animations](ANIMATIONS.md) for mobile optimization

---

## Support

- **Issues?** Check GitHub issues for this repository
- **Questions?** See documentation files for detailed explanations
- **Contributions?** See main README.md for contribution guidelines

---

## Checklist Before Deployment

- [ ] All pages preview correctly in `preview/` folder
- [ ] Responsive design tested on 320px, 768px, 1920px viewports
- [ ] Accessibility tested (keyboard nav, screen reader)
- [ ] Theme activated in Keycloak realm settings
- [ ] Login flow tested end-to-end
- [ ] Error pages tested
- [ ] All language strings translated

---

**Version:** 1.0.0  
**Last Updated:** 2026-07-26  
**Maintainer:** ITLusions
