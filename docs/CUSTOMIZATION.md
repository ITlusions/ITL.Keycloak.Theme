# Customization Guide

This guide shows how to customize colors, fonts, spacing, and other design elements in the ITLusions theme.

---

## Color Customization

### CSS Variables

All colors are defined as CSS variables in `:root`:

```css
:root {
  /* Primary colors */
  --itl-primary: #2563eb;        /* Main blue */
  --itl-primary-dark: #1d4ed8;   /* Darker blue for hover */
  --itl-primary-light: #3b82f6;  /* Lighter blue for disabled */
  
  /* Status colors */
  --itl-success: #059669;        /* Green - success state */
  --itl-error: #dc2626;          /* Red - error state */
  --itl-warning: #d97706;        /* Orange - warning state */
  --itl-info: #0891b2;           /* Cyan - info messages */
  
  /* Neutral colors */
  --itl-gray-50: #f8fafc;        /* Almost white */
  --itl-gray-100: #f1f5f9;       /* Lightest gray */
  --itl-gray-200: #e2e8f0;       /* Light gray */
  --itl-gray-300: #cbd5e1;
  --itl-gray-400: #94a3b8;
  --itl-gray-500: #64748b;       /* Mid gray */
  --itl-gray-600: #475569;
  --itl-gray-700: #334155;       /* Dark gray */
  --itl-gray-800: #1e293b;       /* Very dark */
  --itl-gray-900: #0f172a;       /* Almost black */
}
```

### Changing Colors

Edit `theme/itlusions/login/resources/css/login.css`:

```css
:root {
  /* Change primary blue to green */
  --itl-primary: #10b981;        /* Changed from #2563eb */
  --itl-primary-dark: #059669;
  --itl-primary-light: #34d399;
  
  /* Change error red to orange */
  --itl-error: #ea580c;          /* Changed from #dc2626 */
}
```

### Color Usage in Elements

```css
/* Buttons use primary color */
.itlusions-button {
  background-color: var(--itl-primary);  /* Uses --itl-primary */
  border: 1px solid var(--itl-primary-dark);
}

.itlusions-button:hover {
  background-color: var(--itl-primary-dark);
}

/* Error messages use error color */
.itlusions-input-error {
  color: var(--itl-error);
  border-color: var(--itl-error);
}

/* Success messages use success color */
.success-message {
  color: var(--itl-success);
}
```

### Common Color Changes

```css
/* Brand color change: Blue → Purple */
--itl-primary: #a855f7;
--itl-primary-dark: #9333ea;
--itl-primary-light: #c084fc;

/* Dark background: Almost black → Navy */
--itl-gray-900: #000f3d;

/* Focus color: Cyan → Pink */
--itl-info: #ec4899;
```

---

## Font Customization

### Typography Variables

```css
:root {
  --itl-font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
  --itl-font-mono: 'JetBrains Mono', 'Fira Code', monospace;
}
```

### Change Font Family

```css
/* Import custom font */
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');

/* Update CSS variable */
:root {
  --itl-font-family: 'Poppins', sans-serif;  /* Changed from Inter */
}
```

### Font Weights

```css
/* Light weight - 400 */
body { font-weight: 400; }

/* Medium weight - 500 */
label { font-weight: 500; }

/* Semibold weight - 600 */
.itlusions-button { font-weight: 600; }

/* Bold weight - 700 */
h1, h2, h3 { font-weight: 700; }
```

### Font Sizing

```css
/* Headings - Mobile first */
h1 { font-size: 1.25rem; }
h2 { font-size: 1.125rem; }
h3 { font-size: 1rem; }

/* Body text */
body { font-size: 0.9375rem; }
small { font-size: 0.875rem; }

/* Tablet+ */
@media (min-width: 641px) {
  h1 { font-size: 1.625rem; }
  h2 { font-size: 1.375rem; }
}

/* Desktop */
@media (min-width: 1025px) {
  h1 { font-size: 1.875rem; }
  h2 { font-size: 1.5rem; }
}
```

---

## Spacing Customization

### Spacing Variables

```css
:root {
  --itl-spacing-xs: 0.25rem;    /* 4px */
  --itl-spacing-sm: 0.5rem;     /* 8px */
  --itl-spacing-md: 1rem;       /* 16px */
  --itl-spacing-lg: 1.5rem;     /* 24px */
  --itl-spacing-xl: 2rem;       /* 32px */
  --itl-spacing-2xl: 3rem;      /* 48px */
}
```

### Changing Spacing

```css
:root {
  /* Increase all spacing by 25% */
  --itl-spacing-xs: 0.3125rem;
  --itl-spacing-sm: 0.625rem;
  --itl-spacing-md: 1.25rem;
  --itl-spacing-lg: 1.875rem;
  --itl-spacing-xl: 2.5rem;
  --itl-spacing-2xl: 3.75rem;
}
```

### Using in Elements

```css
/* Form padding */
.itlusions-card {
  padding: var(--itl-spacing-lg);  /* 24px */
}

/* Input padding */
.itlusions-input {
  padding: var(--itl-spacing-md);  /* 16px */
}

/* Button padding */
.itlusions-button {
  padding: var(--itl-spacing-md) var(--itl-spacing-lg);  /* 16px 24px */
}

/* Margin between elements */
.itlusions-form-group {
  margin-bottom: var(--itl-spacing-lg);  /* 24px */
}
```

---

## Button Customization

### Button Styles

```css
.itlusions-button {
  /* Base styles */
  background-color: var(--itl-primary);
  color: white;
  padding: 1rem 1.5rem;
  border: none;
  border-radius: 0.375rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.itlusions-button:hover {
  background-color: var(--itl-primary-dark);
}

.itlusions-button:active {
  transform: scale(0.98);  /* Slight press effect */
}

.itlusions-button:disabled {
  background-color: var(--itl-gray-300);
  cursor: not-allowed;
  opacity: 0.6;
}
```

### Different Button Variants

```css
/* Primary button (default) */
.itlusions-button {
  background-color: var(--itl-primary);
  color: white;
}

/* Secondary button */
.itlusions-button--secondary {
  background-color: var(--itl-gray-200);
  color: var(--itl-gray-900);
  border: 1px solid var(--itl-gray-300);
}

/* Danger button (for delete actions) */
.itlusions-button--danger {
  background-color: var(--itl-error);
  color: white;
}

/* Large button */
.itlusions-button--large {
  padding: 1.25rem 2rem;
  font-size: 1.0625rem;
}

/* Small button */
.itlusions-button--small {
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
}
```

---

## Dark Theme Customization

### Dark Theme Colors

File: `theme/itlusions-dark/login/resources/css/login.css`

```css
:root {
  /* Dark theme colors */
  --itl-dark-bg: #0f172a;           /* Near black background */
  --itl-dark-surface: #1e293b;      /* Slightly lighter surface */
  --itl-dark-border: #334155;       /* Dark borders */
  --itl-dark-text: #f1f5f9;         /* Light text */
  --itl-dark-text-subtle: #cbd5e1;  /* Subtle text (secondary) */
  
  /* Dark primary colors */
  --itl-primary: #3b82f6;           /* Lighter blue for contrast */
  --itl-primary-dark: #1e40af;
  --itl-primary-light: #60a5fa;
}
```

### Dark Theme Elements

```css
/* Dark background */
body {
  background-color: var(--itl-dark-bg);
  color: var(--itl-dark-text);
}

/* Dark card */
.itlusions-card {
  background-color: var(--itl-dark-surface);
  border: 1px solid var(--itl-dark-border);
  color: var(--itl-dark-text);
}

/* Dark input */
.itlusions-input {
  background-color: var(--itl-dark-surface);
  border: 1px solid var(--itl-dark-border);
  color: var(--itl-dark-text);
}

.itlusions-input::placeholder {
  color: var(--itl-dark-text-subtle);
}

.itlusions-input:focus {
  border-color: var(--itl-primary);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}
```

---

## ✨ Animation Customization

### Animation Speed

```css
/* Slow animations */
.fade-in {
  animation: fadeIn 1s ease-out;  /* Changed from 0.6s */
}

/* Fast animations */
.fade-in-fast {
  animation: fadeIn 0.3s ease-out;  /* Changed from 0.6s */
}

/* Instant (no animation) */
.fade-in-instant {
  animation: none;
}
```

### Animation Delays

```css
/* Stagger effects - vary delays */
.form-group:nth-child(1) { animation-delay: 0s; }
.form-group:nth-child(2) { animation-delay: 0.1s; }
.form-group:nth-child(3) { animation-delay: 0.2s; }
.form-group:nth-child(4) { animation-delay: 0.3s; }

/* Or add class and control via CSS */
.delay-1 { animation-delay: 0.1s; }
.delay-2 { animation-delay: 0.2s; }
.delay-3 { animation-delay: 0.3s; }
```

### Disable Animations

```css
/* For low-end devices or accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 🔍 Input Customization

### Input Styling

```css
.itlusions-input {
  /* Base styles */
  width: 100%;
  padding: 0.75rem;
  border: 1px solid var(--itl-gray-300);
  border-radius: 0.375rem;
  font-family: var(--itl-font-family);
  font-size: 0.9375rem;
  background-color: white;
  color: var(--itl-gray-900);
  transition: border-color 0.2s ease;
}

/* Focus state */
.itlusions-input:focus {
  outline: none;
  border-color: var(--itl-primary);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

/* Error state */
.itlusions-input:invalid,
.itlusions-input[aria-invalid="true"] {
  border-color: var(--itl-error);
  background-color: rgba(220, 38, 38, 0.05);
}

/* Error focus */
.itlusions-input:invalid:focus {
  box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
}

/* Disabled state */
.itlusions-input:disabled {
  background-color: var(--itl-gray-100);
  color: var(--itl-gray-500);
  cursor: not-allowed;
}
```

### Input Sizes

```css
/* Small input */
.itlusions-input--sm {
  padding: 0.5rem;
  font-size: 0.875rem;
}

/* Large input */
.itlusions-input--lg {
  padding: 1rem;
  font-size: 1rem;
}

/* Full width */
.itlusions-input--full {
  width: 100%;
}
```

---

## 🎯 Responsive Customization

### Mobile Adjustments

```css
/* Mobile - Base styles */
.itlusions-card {
  padding: 1rem;
  margin: 0.5rem;
}

.itlusions-header h1 {
  font-size: 1.25rem;
}

/* Tablet - 641px+ */
@media (min-width: 641px) {
  .itlusions-card {
    padding: 1.75rem;
    margin: 1rem;
  }
  
  .itlusions-header h1 {
    font-size: 1.625rem;
  }
}

/* Desktop - 1025px+ */
@media (min-width: 1025px) {
  .itlusions-card {
    padding: 2.5rem;
    max-width: 500px;
    margin: 0 auto;
  }
  
  .itlusions-header h1 {
    font-size: 1.875rem;
  }
}
```

---

## 🌐 Theme Variant Creation

### Create New Theme Variant

1. **Copy existing theme:**
   ```bash
   cp -r theme/itlusions theme/itlusions-custom
   ```

2. **Edit CSS variables:**
   ```css
   /* theme/itlusions-custom/login/resources/css/login.css */
   :root {
     --itl-primary: #your-custom-color;
     /* ... other customizations */
   }
   ```

3. **Update theme.properties:**
   ```properties
   # theme/itlusions-custom/login/theme.properties
   parent=base
   import=common/keycloak
   ```

4. **Register in META-INF:**
   ```json
   {
     "themes": [
       {
         "name": "itlusions-custom",
         "types": ["login", "account"]
       }
     ]
   }
   ```

---

## 📝 Common Customizations Examples

### Example 1: Corporate Blue Theme

```css
:root {
  --itl-primary: #003d82;        /* Dark corporate blue */
  --itl-primary-dark: #002147;
  --itl-primary-light: #0052a3;
  --itl-gray-900: #1a1a1a;       /* Darker grays */
  --itl-gray-50: #fafafa;
}
```

### Example 2: Accessible High Contrast

```css
:root {
  --itl-primary: #0000ff;        /* Pure blue */
  --itl-error: #ff0000;          /* Pure red */
  --itl-gray-900: #000000;       /* Pure black */
  --itl-gray-50: #ffffff;        /* Pure white */
}

.itlusions-input:focus {
  box-shadow: 0 0 0 4px #000000;  /* Thicker focus outline */
  border-width: 2px;
}
```

### Example 3: Minimalist Light Theme

```css
:root {
  --itl-primary: #666666;        /* Dark gray */
  --itl-gray-900: #222222;
  --itl-gray-50: #fafafa;
}

/* Remove shadows */
.itlusions-card {
  box-shadow: none;
  border: 1px solid var(--itl-gray-200);
}
```

---

## 🔗 Related Documentation

- [Architecture Guide](ARCHITECTURE.md)
- [Development Guide](DEVELOPMENT.md)
- [Responsive Design](RESPONSIVE_DESIGN.md)

---

**Customization Guide Version:** 1.0.0  
**Last Updated:** 2026-07-26
