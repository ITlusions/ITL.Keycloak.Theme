# Theme Implementation Guide

This guide explains how to package and deploy the ITLusions custom themes into Keycloak environments.

---

## Overview

The ITLusions theme is distributed as **packaged JAR files** that Keycloak loads as theme providers. This guide covers:

1. **Building** — Creating JAR theme packages from source
2. **Deploying** — Installing themes in Keycloak
3. **Activating** — Enabling themes in the Admin Console
4. **Verifying** — Testing the deployment

---

## Building Theme JAR Files

### Prerequisites

- Node.js ≥ 16.x
- npm ≥ 8.x
- `npm-pack-all` or similar build tools (optional)

### Build Process

#### 1. Clone/Update Theme Repository

```bash
cd d:\repos\ITL.Keycloak.Theme
git pull origin main
npm install
```

#### 2. Build the Theme

```bash
npm run build

# Output: theme/ directory with compiled CSS/JS
```

#### 3. Package as JAR (for Kubernetes/production)

**Option A: Using Maven (if available)**

```bash
mvn clean package
```

**Option B: Manual JAR Creation**

```bash
# Create JAR structure
mkdir -p keycloak-itlusions-theme/META-INF
cp -r theme/itlusions keycloak-itlusions-theme/

# Create manifest
cat > keycloak-itlusions-theme/META-INF/MANIFEST.MF << EOF
Manifest-Version: 1.0
Created-By: ITLusions
Name: itlusions
Version: 1.0.0
EOF

# Package as JAR
cd keycloak-itlusions-theme
jar -cfm ../keycloak-itlusions-theme.jar META-INF/MANIFEST.MF *
cd ..

# Repeat for dark and neon themes
cp -r theme/itlusions-dark keycloak-itlusions-dark-theme/
jar -cfm ../keycloak-itlusions-dark-theme.jar META-INF/MANIFEST.MF *

cp -r theme/itlusions-neon keycloak-itlusions-neon-theme/
jar -cfm ../keycloak-itlusions-neon-theme.jar META-INF/MANIFEST.MF *
```

#### 4. Create GitHub Release

```bash
# Tag the release
git tag v1.0.0
git push origin v1.0.0

# Create GitHub release and upload JARs
# Go to: https://github.com/ITlusions/ITL.Keycloak.Theme/releases/new
# Upload:
#   - keycloak-itlusions-theme.jar
#   - keycloak-itlusions-dark-theme.jar
#   - keycloak-itlusions-neon-theme.jar
```

---

## Deployment Methods

### Method 1: Kubernetes (Recommended for Production)

Used in `ITL.Keycloack.Tenants` repository.

#### Configuration (`tenants/itlkc01.yaml`)

```yaml
keycloak:
  name: itlkc01-prd
  instances: 2
  
  # Init container downloads themes on pod startup
  initContainers:
    - name: theme-downloader
      image: curlimages/curl:8.4.0
      command:
        - sh
        - -c
      args:
        - |
          echo "Downloading Keycloak themes..."
          
          # Get latest release from GitHub
          latest_release_url="https://api.github.com/repos/ITlusions/ITL.Keycloak.Theme/releases/latest"
          latest_tag=$(curl -s $latest_release_url | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
          base_url="https://github.com/ITlusions/ITL.Keycloak.Theme/releases/download/$latest_tag"
          
          # Download all theme JARs
          curl -L -f "$base_url/keycloak-itlusions-theme.jar" \
            -o /opt/keycloak/providers/keycloak-itlusions-theme.jar
          
          curl -L -f "$base_url/keycloak-itlusions-dark-theme.jar" \
            -o /opt/keycloak/providers/keycloak-itlusions-dark-theme.jar
          
          curl -L -f "$base_url/keycloak-itlusions-neon-theme.jar" \
            -o /opt/keycloak/providers/keycloak-itlusions-neon-theme.jar
          
          echo "Themes downloaded successfully!"
          
      volumeMounts:
        - name: keycloak-providers
          mountPath: /opt/keycloak/providers/
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        allowPrivilegeEscalation: false
        readOnlyRootFilesystem: true
      resources:
        requests:
          memory: 64Mi
          cpu: 50m
        limits:
          memory: 128Mi
          cpu: 100m
  
  # Volume for themes
  additionalVolumes:
    - name: keycloak-providers
      emptyDir: {}
  
  additionalVolumeMounts:
    - name: keycloak-providers
      mountPath: /opt/keycloak/providers/
      readOnly: false
```

#### Deploy to Kubernetes

```bash
# Update Helm chart
cd d:\repos\ITL.Keycloack.Tenants
helm upgrade itlkc01 . -f tenants/itlkc01.yaml

# Verify deployment
kubectl get pods -n keycloak
kubectl describe pod itlkc01-0 -n keycloak
kubectl logs itlkc01-0 -n keycloak -c theme-downloader
```

---

### Method 2: Docker Build

Package themes into a custom Keycloak Docker image.

#### Dockerfile

```dockerfile
FROM quay.io/keycloak/keycloak:latest

# Copy theme JAR files to providers directory
COPY keycloak-itlusions-theme.jar /opt/keycloak/providers/
COPY keycloak-itlusions-dark-theme.jar /opt/keycloak/providers/
COPY keycloak-itlusions-neon-theme.jar /opt/keycloak/providers/

# Optional: Set default theme
ENV KC_SPI_THEME_DEFAULT=itlusions

# Build optimized Keycloak
RUN /opt/keycloak/bin/kc.sh build
```

#### Build and Push

```bash
# Build image
docker build -t keycloak-with-itlusions-themes:1.0.0 .

# Tag for registry
docker tag keycloak-with-itlusions-themes:1.0.0 \
  registry.example.com/keycloak-with-itlusions-themes:1.0.0

# Push to registry
docker push registry.example.com/keycloak-with-itlusions-themes:1.0.0
```

#### docker-compose.yml

```yaml
version: '3.8'

services:
  keycloak:
    image: registry.example.com/keycloak-with-itlusions-themes:1.0.0
    ports:
      - "8080:8080"
    environment:
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://postgres:5432/keycloak
      KC_DB_USERNAME: keycloak
      KC_DB_PASSWORD: keycloak
    depends_on:
      - postgres
    command: start-dev
```

---

### Method 3: Direct File Copy (Standalone Keycloak)

For non-containerized Keycloak installations.

#### Installation Steps

1. **Find Keycloak installation**

```bash
# Linux/macOS
KEYCLOAK_HOME=/opt/keycloak

# or if not in PATH
which keycloak  # shows installation location
```

2. **Copy JAR files**

```bash
# Copy theme JARs to providers directory
cp keycloak-itlusions-theme.jar $KEYCLOAK_HOME/providers/
cp keycloak-itlusions-dark-theme.jar $KEYCLOAK_HOME/providers/
cp keycloak-itlusions-neon-theme.jar $KEYCLOAK_HOME/providers/

# Verify
ls -la $KEYCLOAK_HOME/providers/ | grep itlusions
```

3. **Restart Keycloak**

```bash
# Using systemd
sudo systemctl restart keycloak

# or direct command
$KEYCLOAK_HOME/bin/kc.sh start

# or using docker
docker restart keycloak
```

4. **Verify Installation**

```bash
# Check logs for theme loading
tail -f $KEYCLOAK_HOME/data/keycloak.log | grep -i theme

# Should see output like:
# "Theme 'itlusions' loaded successfully"
```

---

## Activation in Keycloak

### Step 1: Access Admin Console

```
URL: https://your-keycloak-server/admin/
Username: admin
Password: (your admin password)
```

### Step 2: Select Realm

1. Click realm selector (top left)
2. Select target realm (e.g., "master")

### Step 3: Configure Themes

1. Go to: **Realm Settings** → **Themes** tab

2. **Login Theme**: Select "itlusions"
   - This is the theme used for login, registration, password reset, etc.

3. **Account Theme**: Select "itlusions"
   - This is the theme for the account management console

4. **Welcome Theme**: Select "itlusions"
   - This is the theme for the welcome page

5. **Email Theme**: Select "base" (or customize later)
   - Email messages use different templates

6. **Admin Theme** (optional): Select "base"
   - Keep default for admin console

### Step 4: Save

Click **Save** button.

### Step 5: Verify

1. Navigate to: `https://your-keycloak-server/realms/your-realm/account`
2. Click **Sign in** (or login link)
3. Should see ITLusions login theme

---

## Configuration Variants

### Light Theme (Default)

```yaml
loginTheme: itlusions
accountTheme: itlusions
welcomeTheme: itlusions
```

### Dark Theme

```yaml
loginTheme: itlusions-dark
accountTheme: itlusions-dark
welcomeTheme: itlusions-dark
```

### Neon Theme (Experimental)

```yaml
loginTheme: itlusions-neon
accountTheme: itlusions-neon
welcomeTheme: itlusions-neon
```

### Mixed Themes (Different for Each)

```yaml
loginTheme: itlusions          # Light for login
accountTheme: itlusions-dark   # Dark for account
welcomeTheme: itlusions        # Light for welcome
```

---

## Update Procedure

### When New Theme Version Released

#### 1. Kubernetes (Automatic)

The init container automatically downloads the latest release:

```bash
# New pods will get latest theme automatically
kubectl rollout restart deployment keycloak -n keycloak

# Or:
helm upgrade itlkc01 . -f tenants/itlkc01.yaml
```

#### 2. Docker

```bash
# Rebuild image with new theme JAR
docker build -t keycloak-with-itlusions-themes:1.1.0 .

# Push to registry
docker push registry.example.com/keycloak-with-itlusions-themes:1.1.0

# Update deployment to use new image tag
kubectl set image deployment/keycloak \
  keycloak=registry.example.com/keycloak-with-itlusions-themes:1.1.0
```

#### 3. Standalone

```bash
# Stop Keycloak
sudo systemctl stop keycloak

# Backup old themes
cp $KEYCLOAK_HOME/providers/keycloak-itlusions-*.jar \
   $KEYCLOAK_HOME/providers/backup/

# Download new JARs
wget https://github.com/ITlusions/ITL.Keycloak.Theme/releases/download/vX.Y.Z/keycloak-itlusions-theme.jar \
  -O $KEYCLOAK_HOME/providers/

# Start Keycloak
sudo systemctl start keycloak

# Clear cache
# Admin Console → Realm Settings → Clear Cache
```

---

## Verification Checklist

### After Deployment

- [OK] Theme JAR files present in `/opt/keycloak/providers/`
- [OK] Keycloak pod/container restarted
- [OK] No errors in Keycloak logs
- [OK] Admin Console → Themes shows "itlusions" option

### After Activation

- [OK] Login page displays ITLusions theme
- [OK] Account console displays ITLusions theme
- [OK] All pages render correctly
- [OK] No CSS/JS errors in browser console (F12)
- [OK] Responsive design works (mobile, tablet, desktop)
- [OK] Animations are smooth

### Multi-Device Testing

- [OK] Desktop (1920x1080)
- [OK] Tablet (768x1024)
- [OK] Mobile (375x667)
- [OK] Landscape orientation
- [OK] Different browsers (Chrome, Firefox, Safari)

---

## Troubleshooting

### Theme Not Appearing in Admin Console

**Problem:** Theme dropdown doesn't show "itlusions" option

**Solutions:**

1. **Check JAR files exist**
   ```bash
   ls -la /opt/keycloak/providers/ | grep itlusions
   ```

2. **Check file permissions**
   ```bash
   # Must be readable by keycloak user
   chmod 644 /opt/keycloak/providers/keycloak-*.jar
   ```

3. **Clear theme cache**
   - Admin Console → Realm Settings → Clear cache → Clear themes

4. **Restart Keycloak**
   ```bash
   kubectl rollout restart deployment keycloak
   # or
   sudo systemctl restart keycloak
   ```

5. **Check logs for errors**
   ```bash
   kubectl logs -f deployment/keycloak | grep -i theme
   ```

### CSS/JS Not Loading

**Problem:** Login page loads but no styling/animations

**Solutions:**

1. **Check browser console (F12)**
   - Look for 404 errors on CSS/JS files

2. **Verify theme structure in JAR**
   ```bash
   jar -tf keycloak-itlusions-theme.jar | grep -E "\.(css|js)$"
   ```

3. **Disable browser cache**
   - DevTools → Settings → Disable cache

4. **Clear Keycloak static cache**
   ```bash
   Admin Console → Realm Settings → Clear cache → Clear all
   ```

### Init Container Fails

**Problem:** Init container fails to download theme JAR

**Check:**

1. **Network connectivity**
   ```bash
   kubectl exec -it pod-name -c theme-downloader -- \
     curl -I https://github.com
   ```

2. **GitHub API rate limiting**
   ```bash
   # May be rate-limited without auth token
   # Use GitHub token:
   curl -H "Authorization: token YOUR_TOKEN" \
     https://api.github.com/repos/ITlusions/ITL.Keycloak.Theme/releases/latest
   ```

3. **Disk space**
   ```bash
   kubectl exec -it pod-name -- df -h /opt/keycloak/providers/
   ```

---

## Related Documentation

- [Development Guide](DEVELOPMENT.md) — Building/testing themes locally
- [Customization Guide](CUSTOMIZATION.md) — Modifying themes
- [Architecture Guide](ARCHITECTURE.md) — How themes work
- [Deployment Guide](DEPLOYMENT.md) — General deployment info

---

## Resources

- **GitHub Repository:** https://github.com/ITlusions/ITL.Keycloak.Theme
- **Keycloak Docs:** https://www.keycloak.org/docs/
- **Keycloak Provider Framework:** https://www.keycloak.org/docs/latest/server_development/

---

## Summary

| Step | Purpose | Command |
|---|---|---|
| **Build** | Compile theme from source | `npm run build` |
| **Package** | Create JAR files | `jar -cfm ...` |
| **Release** | Publish on GitHub | Create GitHub release |
| **Deploy** | Install in Keycloak | Init container / Docker / copy |
| **Activate** | Enable in realm | Admin Console → Themes |
| **Verify** | Confirm working | Test login page |

---

**Implementation Guide Version:** 1.0.0  
**Last Updated:** 2026-07-26  
**Keycloak Version:** 1.9+
