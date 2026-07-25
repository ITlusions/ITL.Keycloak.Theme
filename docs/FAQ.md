# FAQ & Quick Reference

Quick answers to common questions about the ITLusions Keycloak theme.

---

## Frequently Asked Questions

### Setup & Installation

**Q: How do I install the theme?**
A: See [Deployment Guide](DEPLOYMENT.md). TL;DR:
1. `npm install && npm run build`
2. Copy `theme/itlusions` to Keycloak's `themes/` folder
3. Go to Admin Console → Select Theme → Choose "itlusions"

**Q: What's the minimum Keycloak version?**
A: Keycloak 1.9+ (tested on recent versions, likely works on earlier versions)

**Q: Do I need Node.js to use the theme?**
A: Only if you want to customize it. The compiled theme works with just Keycloak.

**Q: Can I use this on Windows?**
A: Yes, just use `npm` commands in PowerShell or WSL.

---

### Customization

**Q: How do I change the primary color?**
A: Edit `theme/itlusions/login/resources/css/login.css` line 3:
```css
--itl-primary: #your-color;  /* Change this */
```

**Q: How do I use a different font?**
A: Import in CSS and update the variable:
```css
@import url('https://fonts.googleapis.com/css2?family=YourFont');
--itl-font-family: 'YourFont', sans-serif;
```

**Q: Can I have multiple color schemes?**
A: Yes, create multiple theme folders (e.g., `itlusions-dark`, `itlusions-neon`)

**Q: How do I add/remove form fields?**
A: Edit `theme/itlusions/login/register.ftl` and add/remove form groups

---

### Responsive Design

**Q: Why is my page not responsive on mobile?**
A: Check:
1. Viewport meta tag exists (should be in `template.ftl`)
2. Media queries present in CSS (use F12 → DevTools)
3. Clear browser cache (Ctrl+Shift+Delete)

**Q: What breakpoints are supported?**
A: 320px, 375px, 426px, 641px, 769px, 1025px (and up)

**Q: How do I test on a real phone?**
A: See [Development Guide](DEVELOPMENT.md) → Testing section

---

### Deployment

**Q: How do I deploy to production?**
A: See [Deployment Guide](DEPLOYMENT.md). Three methods:
1. Docker volume mount (dev)
2. Docker build (prod, recommended)
3. Direct file copy (standalone Keycloak)

**Q: How do I update without breaking things?**
A: Backup first:
```bash
cp -r /opt/keycloak/themes/itlusions /opt/keycloak/themes/itlusions.backup
```

**Q: How long does theme caching last?**
A: Default is 24 hours. Change with: `KC_SPI_THEME_CACHE_STATIC_MAX_AGE=86400`

---

### Troubleshooting

**Q: Theme not showing, seeing default Keycloak theme**
A: 
1. Verify file copied: `ls /opt/keycloak/themes/itlusions`
2. Clear cache: Admin Console → Realm Settings → Clear cache
3. Restart Keycloak
4. Check logs: `tail -f /var/log/keycloak/server.log`

**Q: CSS/JavaScript not loading**
A: 
1. Check DevTools Network tab (F12 → Network)
2. Verify files exist: `ls /opt/keycloak/themes/itlusions/login/resources/`
3. Check permissions: `ls -la /opt/keycloak/themes/`
4. Disable caching: `KC_SPI_THEME_CACHE_STATIC_MAX_AGE=0`

**Q: Animations are stuttering on mobile**
A: Normal on low-end devices. Check:
1. Device performance (Use another device to compare)
2. CSS uses `transform`/`opacity` (GPU-accelerated)
3. Browser DevTools → Throttling (simulate slower network)

**Q: Form isn't submitting**
A: 
1. Check form `action` URL (should be `${url.loginAction}`)
2. Verify no JavaScript errors (F12 → Console)
3. Check CSRF token is included (Keycloak adds automatically)

---

## Quick Reference

### File Locations

```
theme/itlusions/login/resources/
├── css/
│   ├── login.css             ← Edit for styling
│   └── authenticated.css
├── js/
│   ├── interactive-background.js
│   └── authenticated.js
└── img/
    ├── hero-bg.jpg
    └── logo.png
```

### Common Edits

| Change | File | What to Edit |
|---|---|---|
| Colors | `login.css` | `:root` variables |
| Fonts | `login.css` | `@import` + `--itl-font-family` |
| Spacing | `login.css` | `--itl-spacing-*` variables |
| Responsive | `login.css` | `@media` queries |
| Form fields | `register.ftl` | Form groups |
| Messages | `messages/*.properties` | Strings |

### Build Commands

```bash
npm run build            # Production build
npm run watch           # Watch mode (auto-rebuild)
npm run serve           # Start preview server
npm run clean           # Delete build output
npm run dev             # Build + watch + serve
```

### CSS Variables Cheat Sheet

```css
/* Colors */
--itl-primary                    /* Main brand color */
--itl-error                      /* Error red */
--itl-success                    /* Success green */
--itl-warning                    /* Warning orange */

/* Spacing */
--itl-spacing-sm                 /* 8px */
--itl-spacing-md                 /* 16px */
--itl-spacing-lg                 /* 24px */
--itl-spacing-xl                 /* 32px */

/* Typography */
--itl-font-family                /* Primary font */
--itl-font-mono                  /* Monospace font */

/* Sizing */
--itl-border-radius              /* 0.375rem (6px) */
--itl-border-width               /* 1px */
```

### FreeMarker Quick Syntax

```ftl
${var}                           <!-- Output variable -->
${msg("key")}                    <!-- Get translation -->
<#if condition> ... </#if>       <!-- Conditional -->
<#list items as item> ... </#list> <!-- Loop -->
${value!'default'}               <!-- Default value -->
${value?no_esc}                  <!-- Don't escape HTML -->
```

---

## Troubleshooting Checklist

### Before Reporting Issues

- [ ] Cleared browser cache (Ctrl+Shift+Delete)
- [ ] Hard refreshed page (Ctrl+Shift+R)
- [ ] Checked browser console (F12 → Console tab)
- [ ] Checked Network tab for 404s (F12 → Network)
- [ ] Tested on different browser
- [ ] Tested on different device
- [ ] Tried disabling browser extensions
- [ ] Restarted Keycloak
- [ ] Checked Keycloak logs

### Info to Include in Bug Report

- [ ] Keycloak version
- [ ] Theme version
- [ ] Browser + version
- [ ] Device/OS
- [ ] Screenshots
- [ ] Error messages (from console)
- [ ] Steps to reproduce

---

## Performance Tips

### For Development

```bash
# Disable all caching during development
KC_SPI_THEME_CACHE_THEMES=false
KC_SPI_THEME_CACHE_STATIC_MAX_AGE=0
```

### For Production

```bash
# Enable caching for better performance
KC_SPI_THEME_CACHE_THEMES=true
KC_SPI_THEME_CACHE_STATIC_MAX_AGE=86400  # 24 hours
```

### CSS/JS Size

| File | Size | Status |
|---|---|---|
| login.css | ~20KB | Minified |
| authenticated.css | ~5KB | Minified |
| interactive-background.js | ~3KB | Minified |
| authenticated.js | ~2KB | Minified |
| **Total** | **~30KB** | [OK] Good |

---

## Browser Support

| Browser | Version | Support |
|---|---|---|
| Chrome/Edge | Latest 2 | [OK] Full |
| Firefox | Latest 2 | [OK] Full |
| Safari | Latest 2 | [OK] Full |
| Mobile Safari (iOS) | 12+ | [OK] Full |
| Chrome Mobile | Latest | [OK] Full |
| Samsung Internet | Latest | [OK] Full |

---

## 📱 Device Support

| Device | Screen | Support |
|---|---|---|
| iPhone SE | 375x667 | [OK] Full |
| iPhone 14 Pro | 393x852 | [OK] Full |
| Galaxy S22 | 360x800 | [OK] Full |
| iPad Mini | 768x1024 | [OK] Full |
| iPad Air | 1024x1366 | [OK] Full |
| Desktop 1080p | 1920x1080 | [OK] Full |

---

## Security Checklist

- [ ] No sensitive data in templates
- [ ] CSRF token included (automatic)
- [ ] Inputs properly escaped (automatic)
- [ ] HTTPS enabled in production
- [ ] File permissions correct (755 for dirs, 644 for files)
- [ ] No credentials in code
- [ ] Dependencies up-to-date

---

## Additional Resources

- **Keycloak Docs:** https://www.keycloak.org/docs/
- **FreeMarker Guide:** https://freemarker.apache.org/docs/
- **CSS Reference:** https://developer.mozilla.org/en-US/docs/Web/CSS
- **Responsive Design:** https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design

---

## 🆘 Getting Help

1. **Check this FAQ first** → Answer might be here
2. **See relevant guide:**
   - Setup issues → [Development Guide](DEVELOPMENT.md)
   - Colors/fonts → [Customization Guide](CUSTOMIZATION.md)
   - Deployment → [Deployment Guide](DEPLOYMENT.md)
   - Architecture → [Architecture Guide](ARCHITECTURE.md)
3. **Search issues** → Check GitHub issues for similar problems
4. **Ask in Keycloak community** → If still stuck

---

**FAQ & Quick Reference Version:** 1.0.0  
**Last Updated:** 2026-07-26  
**Maintained by:** ITLusions Team
