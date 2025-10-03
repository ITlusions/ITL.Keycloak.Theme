# ITlusions Keycloak Themes - Keycloakify Setup

## Step 1: Initialize Keycloakify Project

To migrate to Keycloakify, run these commands in a new directory:

```bash
# Create new directory for Keycloakify project
mkdir itlusions-keycloak-themes-v2
cd itlusions-keycloak-themes-v2

# Initialize with Keycloakify starter
npx create-keycloakify-app@latest .

# Install additional dependencies for our themes
npm install styled-components @emotion/react @emotion/styled
npm install -D @types/styled-components

# Install development tools
npm install -D prettier eslint @typescript-eslint/eslint-plugin
```

## Step 2: Project Structure

```
src/
├── login/
│   ├── KcPage.tsx           # Main page router
│   ├── pages/
│   │   ├── Login.tsx        # Login page
│   │   ├── Register.tsx     # Registration page
│   │   ├── LoginOtp.tsx     # OTP verification
│   │   └── LoginResetPassword.tsx
│   └── i18n.ts              # Internationalization
├── account/                 # Account management pages
├── themes/
│   ├── index.ts            # Theme configuration
│   ├── corporate.ts        # Corporate theme
│   ├── dark.ts             # Dark theme
│   └── neon.ts             # Neon theme
├── components/
│   ├── ThemeProvider.tsx   # Theme context provider
│   ├── GlassCard.tsx       # Reusable glass card
│   ├── NeonButton.tsx      # Animated buttons
│   └── GlobalStyles.tsx    # Global styles
└── utils/
    └── theme.ts            # Theme utilities
```

## Step 3: Key Benefits

### ✅ Modern Development Experience
- **Hot Reloading**: Instant preview with Storybook
- **TypeScript**: Full type safety across all components
- **Component-Based**: Reusable components across theme variants
- **Testing**: Built-in test scenarios for all login flows

### ✅ Automated Build Process
```bash
# Development with hot reloading
npm run storybook

# Build theme JAR for production
npm run build-keycloak-theme

# Output: dist/keycloak-theme.jar (ready for deployment)
```

### ✅ Advanced Features
- **Dynamic Theme Switching**: URL parameters or environment variables
- **Glass Morphism Effects**: CSS-in-JS with full animation support
- **Accessibility**: Built-in ARIA support and keyboard navigation
- **Performance**: Optimized bundles with code splitting

## Step 4: Theme Configuration

Each theme variant is configured as a TypeScript object:

```typescript
// src/themes/neon.ts
export const neonTheme = {
  colors: {
    primary: 'hsl(255, 100%, 65%)',
    // ... other colors
  },
  glass: {
    background: 'hsla(222, 30%, 25%, 0.1)',
    blur: '20px',
    // ... glass effects
  },
  neon: {
    glow: 'hsl(255, 100%, 65%)',
    // ... neon effects
  }
};
```

## Step 5: Component Example

```tsx
// src/components/GlassCard.tsx
import styled from 'styled-components';

export const GlassCard = styled.div`
  background: ${props => props.theme.glass?.background || props.theme.colors.surface};
  backdrop-filter: blur(${props => props.theme.glass?.blur || '0px'});
  border: 1px solid ${props => props.theme.glass?.border || props.theme.colors.primary};
  border-radius: ${props => props.theme.glass?.radius || '12px'};
  
  ${props => props.theme.name === 'neon' && `
    position: relative;
    
    &::after {
      content: '';
      position: absolute;
      inset: -2px;
      background: ${props.theme.neon?.gradient};
      border-radius: inherit;
      z-index: -1;
      opacity: 0;
      animation: neonGlow 4s ease-in-out infinite;
    }
    
    @keyframes neonGlow {
      0%, 100% { opacity: 0; }
      50% { opacity: 0.3; }
    }
  `}
`;
```

## Step 6: Deployment

```bash
# Build production JAR
npm run build-keycloak-theme

# Deploy to Keycloak
cp dist/keycloak-theme.jar $KEYCLOAK_HOME/providers/

# Restart Keycloak
$KEYCLOAK_HOME/bin/kc.sh start --dev
```

## Step 7: Theme Selection

Users can select themes via:
- **URL Parameter**: `?theme=neon`
- **Environment Variable**: `THEME_VARIANT=dark`
- **Keycloak Admin**: Theme selection in realm settings

## Next Steps

1. **Run the setup commands** above to initialize the Keycloakify project
2. **Copy our existing designs** to the new component structure
3. **Test with Storybook** to verify all login scenarios
4. **Deploy and validate** in your Keycloak environment

Would you like me to guide you through setting up the Keycloakify project?