import { ThemeConfig } from './types';

export const neonTheme: ThemeConfig = {
  name: 'neon',
  displayName: 'ITlusions Neon',
  colors: {
    primary: 'hsl(255, 100%, 65%)',
    secondary: 'hsl(222, 100%, 65%)',
    accent: 'hsl(180, 100%, 65%)',
    background: 'hsl(222, 20%, 8%)',
    surface: 'hsla(222, 20%, 15%, 0.3)',
    text: {
      primary: 'hsl(0, 0%, 95%)',
      secondary: 'hsl(0, 0%, 75%)',
      muted: 'hsl(0, 0%, 55%)'
    },
    error: 'hsl(0, 100%, 65%)',
    success: 'hsl(120, 100%, 65%)',
    warning: 'hsl(45, 100%, 65%)'
  },
  glass: {
    background: 'hsla(222, 30%, 25%, 0.1)',
    blur: '20px',
    border: 'hsl(222, 30%, 35%)',
    radius: '22px',
    opacity: 0.1
  },
  neon: {
    glow: 'hsl(255, 100%, 65%)',
    gradient: 'linear-gradient(45deg, hsl(255, 100%, 65%), hsl(222, 100%, 65%), hsl(180, 100%, 65%), hsl(255, 100%, 65%))',
    hue1: 255,
    hue2: 222,
    hue3: 180
  },
  typography: {
    fontFamily: 'Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
    fontSize: {
      xs: '0.75rem',
      sm: '0.875rem',
      base: '1rem',
      lg: '1.125rem',
      xl: '1.25rem',
      '2xl': '1.5rem'
    },
    fontWeight: {
      normal: 400,
      medium: 500,
      semibold: 600,
      bold: 700
    }
  },
  spacing: {
    xs: '0.25rem',
    sm: '0.5rem',
    md: '1rem',
    lg: '1.5rem',
    xl: '2rem',
    '2xl': '3rem'
  },
  animation: {
    enabled: true,
    duration: {
      fast: '150ms',
      normal: '300ms',
      slow: '500ms'
    },
    easing: {
      default: 'cubic-bezier(0.5, 1, 0.89, 1)',
      bounce: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)'
    }
  }
};