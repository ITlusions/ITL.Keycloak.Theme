# Deployment Guide

This guide explains how to deploy the ITLusions Keycloak theme to production Keycloak instances.

---

## Pre-Deployment Checklist

- [ ] Theme built successfully: `npm run build`
- [ ] All pages tested in `preview/` folder
- [ ] Responsive design tested on multiple devices
- [ ] Accessibility verified (keyboard, screen reader)
- [ ] All language translations completed
- [ ] Theme variant selected (light/dark/neon)
- [ ] Keycloak version compatible (1.9+)
- [ ] Backup of existing theme (if upgrading)

---

## Deployment Methods

### Method 1: Docker Volume Mount (Recommended for Development)

**Pros:** Quick iteration, easy testing
**Cons:** Only works with Docker, doesn't persist rebuilds

```bash
# Build theme
npm run build

# Mount theme volume in docker-compose
docker run -v $(pwd)/theme:/opt/keycloak/themes/itlusions \
  quay.io/keycloak/keycloak:latest
```

### Method 2: Docker Build (Recommended for Production)

**Pros:** Self-contained, portable, reproducible
**Cons:** Requires Docker image build

**Dockerfile:**

```dockerfile
FROM quay.io/keycloak/keycloak:latest

# Copy built theme
COPY theme/itlusions /opt/keycloak/themes/itlusions
COPY theme/itlusions-dark /opt/keycloak/themes/itlusions-dark

# Optional: Set default theme
ENV KEYCLOAK_DEFAULT_THEME=itlusions
```

**Build and run:**

```bash
# Build Docker image
docker build -t keycloak-itlusions:latest .

# Run container
docker run -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  keycloak-itlusions:latest
```

### Method 3: Direct File Copy (for Standalone Keycloak)

**Pros:** Works with any Keycloak installation
**Cons:** Manual process, easy to make mistakes

```bash
# Keycloak installation directory
KEYCLOAK_HOME=/path/to/keycloak

# Build theme
npm run build

# Copy theme to Keycloak
cp -r theme/itlusions $KEYCLOAK_HOME/themes/
cp -r theme/itlusions-dark $KEYCLOAK_HOME/themes/

# Restart Keycloak
systemctl restart keycloak
# or
$KEYCLOAK_HOME/bin/kc.sh start
```

---

## Installation Steps

### Step 1: Build Theme

```bash
cd /path/to/ITL.Keycloak.Theme
npm install
npm run build

# Output: theme/ directory with compiled assets
```

### Step 2: Deploy to Keycloak

Choose one of the deployment methods above based on your setup.

### Step 3: Activate Theme in Realm

1. **Login to Keycloak Admin Console**
   - URL: `https://your-keycloak-server/admin/`
   - Username/password: admin credentials

2. **Select Realm** (top left dropdown)
   - Default: "master"

3. **Go to: Realm Settings → Themes**

4. **Select Login Theme:**
   - Dropdown → Select "itlusions" (or "itlusions-dark")
   - Click "Save"

5. **Select Account Theme (optional):**
   - Dropdown → Select "itlusions"
   - Click "Save"

### Step 4: Verify Installation

1. **Test Login Page**
   - Navigate to: `https://your-keycloak-server/realms/master/account`
   - Click "Sign in"
   - Should see ITLusions theme

2. **Test Error Page**
   - Navigate to: `https://your-keycloak-server/realms/master/login?error=test`
   - Should see custom error page

3. **Test Responsive Design**
   - Open DevTools (F12)
   - Toggle device toolbar (Ctrl+Shift+M)
   - Test 320px, 768px, 1920px viewports

---

## Keycloak Configuration

### Environment Variables

```bash
# Set default theme
KEYCLOAK_DEFAULT_THEME=itlusions

# Set default realm theme
REALM_THEME=itlusions

# Disable theme caching (development only)
KC_SPI_THEME_CACHE_THEMES=false

# Disable static resource caching (development only)
KC_SPI_THEME_CACHE_STATIC_MAX_AGE=0
```

### Docker Compose Example

```yaml
version: '3.8'

services:
  keycloak:
    image: quay.io/keycloak/keycloak:latest
    ports:
      - "8080:8080"
    environment:
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
      KEYCLOAK_DEFAULT_THEME: itlusions
    volumes:
      - ./theme/itlusions:/opt/keycloak/themes/itlusions
      - ./theme/itlusions-dark:/opt/keycloak/themes/itlusions-dark
    command: start-dev
```

---

## Multi-Realm Deployment

### Deploy to Multiple Realms

Each realm can use different themes:

```
Keycloak Admin Console
  ├── Realm: master
  │   └── Themes → itlusions-dark
  ├── Realm: production
  │   └── Themes → itlusions
  └── Realm: staging
      └── Themes → itlusions (with different colors)
```

### Per-Realm Color Customization

Create theme variants in CSS variables:

```css
/* Default: Blue theme */
:root {
  --itl-primary: #2563eb;
}

/* Realm-specific override (if needed) */
:root[data-realm="production"] {
  --itl-primary: #059669;  /* Green for production */
}
```

---

## Updating Existing Theme

### Backup Current Theme

```bash
# Before updating, backup existing theme
cp -r $KEYCLOAK_HOME/themes/itlusions \
      $KEYCLOAK_HOME/themes/itlusions.backup
```

### Update Steps

1. **Build new version**
   ```bash
   npm run build
   ```

2. **Stop Keycloak**
   ```bash
   systemctl stop keycloak
   ```

3. **Replace theme**
   ```bash
   rm -rf $KEYCLOAK_HOME/themes/itlusions
   cp -r theme/itlusions $KEYCLOAK_HOME/themes/
   ```

4. **Start Keycloak**
   ```bash
   systemctl start keycloak
   ```

5. **Clear cache** (if caching enabled)
   - Admin Console → Realm Settings → Clear cache → Clear all

6. **Test login page**
   - Verify new theme is active

### Rollback Procedure

If update causes issues:

```bash
# Stop Keycloak
systemctl stop keycloak

# Restore backup
rm -rf $KEYCLOAK_HOME/themes/itlusions
cp -r $KEYCLOAK_HOME/themes/itlusions.backup \
      $KEYCLOAK_HOME/themes/itlusions

# Start Keycloak
systemctl start keycloak
```

---

## Security Considerations

### Theme Files Permissions

```bash
# Set appropriate permissions (Linux)
chmod 755 /opt/keycloak/themes/itlusions
chmod 644 /opt/keycloak/themes/itlusions/**/*.css
chmod 644 /opt/keycloak/themes/itlusions/**/*.js
chmod 644 /opt/keycloak/themes/itlusions/**/*.ftl
```

### HTTPS Configuration

Always use HTTPS in production:

```bash
# In docker-compose or environment
KC_HTTPS_CERTIFICATE_FILE=/path/to/cert.pem
KC_HTTPS_CERTIFICATE_KEY_FILE=/path/to/key.pem
```

### CORS for Assets

If serving assets from CDN:

```bash
# Enable CORS headers
KC_SPI_THEME_STATIC_ASSETS_PATH=/var/www/keycloak-assets
```

---

## 📱 Testing After Deployment

### Responsive Design Test

| Device | Viewport | How to Test |
|---|---|---|
| Extra-small phone | 320×568 | DevTools mobile |
| Small phone | 375×667 | iPhone X size |
| Large phone | 426×926 | Android XL |
| Tablet | 768×1024 | iPad size |
| Desktop | 1920×1080 | Full screen |

### Functionality Test

- [ ] Login form submits
- [ ] Registration form works
- [ ] Password reset link works
- [ ] OTP/2FA displays correctly
- [ ] Error messages show
- [ ] Success page displays
- [ ] Animations are smooth
- [ ] Links work

### Browser Test

- [ ] Chrome/Edge (latest)
- [ ] Firefox (latest)
- [ ] Safari (if available)
- [ ] Mobile Safari (iOS)
- [ ] Chrome Mobile (Android)

### Accessibility Test

- [ ] Keyboard navigation works (Tab key)
- [ ] Focus states visible
- [ ] Color contrast adequate
- [ ] Screen reader compatible
- [ ] Form labels associated with inputs

---

## ⚡ Performance Optimization

### Caching Strategy

```bash
# Enable theme caching (production)
KC_SPI_THEME_CACHE_THEMES=true
KC_SPI_THEME_CACHE_STATIC_MAX_AGE=86400  # 24 hours

# Disable theme caching (development)
KC_SPI_THEME_CACHE_THEMES=false
KC_SPI_THEME_CACHE_STATIC_MAX_AGE=0
```

### Asset Compression

```bash
# Keycloak automatically gzips responses
# CSS and JS are minified during build
npm run build  # Produces minified assets
```

### CDN Integration (Advanced)

```bash
# Serve static assets from CDN
KC_SPI_THEME_STATIC_ASSETS_PATH=https://cdn.example.com/keycloak-assets
```

---

## Troubleshooting

### Theme Not Appearing

**Problem:** Login page shows default Keycloak theme

**Solutions:**
1. Verify theme copied to correct location:
   ```bash
   ls /opt/keycloak/themes/itlusions
   ```

2. Clear Keycloak cache:
   - Admin Console → Realm Settings → Clear cache → Clear all

3. Restart Keycloak:
   ```bash
   systemctl restart keycloak
   ```

4. Check Keycloak logs:
   ```bash
   tail -f /var/log/keycloak/server.log
   ```

### CSS/JS Not Loading

**Problem:** Page loads but styling/animations missing

**Solutions:**
1. Check browser DevTools (F12 → Network tab)
   - Verify CSS/JS files are loading (200 status)

2. Check browser console (F12 → Console tab)
   - Look for errors

3. Verify assets in theme directory:
   ```bash
   ls /opt/keycloak/themes/itlusions/login/resources/css/
   ```

4. Disable caching:
   - Set `KC_SPI_THEME_CACHE_STATIC_MAX_AGE=0`
   - Restart Keycloak

### Responsive Design Not Working

**Problem:** Page looks wrong on mobile devices

**Solutions:**
1. Verify viewport meta tag in template.ftl:
   ```html
   <meta name="viewport" content="width=device-width, initial-scale=1">
   ```

2. Check media queries in CSS:
   ```bash
   grep "@media" /opt/keycloak/themes/itlusions/login/resources/css/login.css
   ```

3. Test with real device, not just DevTools

4. Check browser zoom (Ctrl+0 to reset)

### Animations Stuttering

**Problem:** Animations are slow or choppy

**Solutions:**
1. Check device performance (may be low-end device)

2. Disable animations in browser:
   - DevTools → Accessibility → Prefers reduced motion

3. Check CSS animations:
   - Ensure using `transform` and `opacity` (GPU-accelerated)
   - Avoid `left`, `top`, `width` changes

---

## 📊 Deployment Checklist

- [ ] Theme built: `npm run build`
- [ ] Theme files copied to Keycloak
- [ ] Keycloak restarted
- [ ] Admin Console → Theme activated
- [ ] Login page tested
- [ ] Responsive design tested (320px, 768px, 1920px)
- [ ] Error page tested
- [ ] Accessibility tested
- [ ] All browsers tested
- [ ] Performance verified
- [ ] Backup created
- [ ] Documentation updated

---

## 🔗 Related Documentation

- [Development Guide](DEVELOPMENT.md)
- [Architecture Guide](ARCHITECTURE.md)
- [Responsive Design](RESPONSIVE_DESIGN.md)

---

**Deployment Guide Version:** 1.0.0  
**Last Updated:** 2026-07-26  
**Keycloak Version:** 1.9+
