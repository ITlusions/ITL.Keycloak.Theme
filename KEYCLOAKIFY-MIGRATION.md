# ITlusions Keycloak Themes - Keycloakify Migration

## Overview

We're migrating from manual FreeMarker templates to **Keycloakify** for modern, maintainable theme development.

## Benefits of Keycloakify

- ✅ **Modern Stack**: React + TypeScript + CSS-in-JS
- ✅ **Hot Reloading**: Instant preview during development
- ✅ **Automated Building**: Built-in JAR generation
- ✅ **Component Reuse**: Share components across theme variants
- ✅ **Testing**: Storybook integration for all scenarios
- ✅ **Type Safety**: Full TypeScript support
- ✅ **Future-Proof**: Compatible with Keycloak 11+

## Current Themes to Migrate

### 1. ITlusions Corporate Theme
- Professional blue branding (#2563eb)
- Clean, modern design
- Multi-language support

### 2. ITlusions Dark Theme
- Dark mode optimized
- Enhanced shadows and glows
- Professional dark palette

### 3. ITlusions Neon Theme
- Glass morphism effects
- Neon glows and animations
- Futuristic design

## Migration Plan

### Phase 1: Setup Keycloakify
```bash
# Initialize new Keycloakify project
npx create-keycloakify-app@latest itlusions-themes
cd itlusions-themes
npm install
```

### Phase 2: Create Theme Variants
- Setup theme switching based on environment/configuration
- Implement shared component library
- Migrate existing CSS to styled-components or CSS modules

### Phase 3: Component Structure
```
src/
├── login/
│   ├── KcPage.tsx          # Main login page router
│   ├── pages/
│   │   ├── Login.tsx       # Login form
│   │   ├── Register.tsx    # Registration form
│   │   ├── LoginOtp.tsx    # OTP verification
│   │   └── ...
│   └── components/
│       ├── ThemeProvider.tsx   # Theme switching logic
│       ├── GlassCard.tsx       # Reusable glass card
│       ├── NeonButton.tsx      # Animated buttons
│       └── ...
├── themes/
│   ├── corporate.ts        # Corporate theme config
│   ├── dark.ts            # Dark theme config
│   └── neon.ts            # Neon theme config
└── shared/
    ├── components/        # Shared UI components
    ├── utils/            # Theme utilities
    └── types/            # TypeScript definitions
```

### Phase 4: Advanced Features
- Dynamic theme switching
- Custom animations and transitions
- Enhanced accessibility
- Performance optimization

## Implementation Example

### Theme Provider
```tsx
// src/themes/ThemeProvider.tsx
import React from 'react';
import { ThemeProvider as StyledThemeProvider } from 'styled-components';
import { corporateTheme, darkTheme, neonTheme } from './themes';

const themes = {
  corporate: corporateTheme,
  dark: darkTheme,
  neon: neonTheme
};

export const ThemeProvider: React.FC<{ 
  variant: keyof typeof themes;
  children: React.ReactNode;
}> = ({ variant, children }) => {
  return (
    <StyledThemeProvider theme={themes[variant]}>
      {children}
    </StyledThemeProvider>
  );
};
```

### Glass Card Component
```tsx
// src/components/GlassCard.tsx
import styled from 'styled-components';

export const GlassCard = styled.div`
  background: ${props => props.theme.glass.background};
  backdrop-filter: blur(${props => props.theme.glass.blur});
  border: 1px solid ${props => props.theme.glass.border};
  border-radius: ${props => props.theme.glass.radius};
  box-shadow: ${props => props.theme.glass.shadow};
  
  ${props => props.theme.name === 'neon' && `
    &::after {
      content: '';
      position: absolute;
      inset: -2px;
      background: ${props.theme.neon.gradient};
      border-radius: inherit;
      z-index: -1;
      opacity: 0;
      animation: neonGlow 4s ease-in-out infinite;
    }
  `}
`;
```

## Development Workflow

### 1. Development with Storybook
```bash
npm run storybook
# Preview all login scenarios with hot reloading
```

### 2. Build Theme JARs
```bash
npm run build
# Generates keycloak-theme.jar automatically
```

### 3. Deploy to Keycloak
```bash
# Copy JAR to Keycloak deployment
cp dist/keycloak-theme.jar /opt/keycloak/providers/
```

## Configuration

### Environment-based Theme Selection
```typescript
// src/config/theme.ts
export const getThemeVariant = (): ThemeVariant => {
  const variant = process.env.KEYCLOAK_THEME_VARIANT;
  return variant in themes ? variant as ThemeVariant : 'corporate';
};
```

### Keycloak Theme Properties
```properties
# theme.properties
name=itlusions-dynamic
displayName=ITlusions Dynamic Theme
locales=en,nl
styles=css/main.css
```

## Next Steps

1. **Setup Keycloakify Project**: Initialize new project structure
2. **Migrate Existing Styles**: Convert CSS to theme objects
3. **Create Components**: Build reusable component library
4. **Implement Theme Switching**: Dynamic theme selection
5. **Add Storybook Stories**: Test all login scenarios
6. **Deploy and Test**: Verify in Keycloak environment

## Benefits Over Current Approach

| Current (FreeMarker) | Keycloakify |
|---------------------|-------------|
| Manual JAR building | Automated build process |
| Static CSS | Dynamic, theme-aware styling |
| No hot reloading | Instant preview with Storybook |
| Manual testing | Automated testing scenarios |
| Duplicate code | Shared component library |
| Limited TypeScript | Full TypeScript support |

Would you like me to start the migration to Keycloakify?