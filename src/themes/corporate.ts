import { ThemeConfig } from './types';

export const corporateTheme: ThemeConfig = {
  name: 'corporate',
  displayName: 'ITlusions Corporate',
  colors: {
    primary: '#2563eb',
    secondary: '#1e40af',
    accent: '#3b82f6',
    background: '#ffffff',
    surface: '#f8fafc',
    text: {
      primary: '#1e293b',
      secondary: '#475569',
      muted: '#94a3b8'
    },
    error: '#ef4444',
    success: '#10b981',
    warning: '#f59e0b'
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
      default: 'cubic-bezier(0.4, 0, 0.2, 1)',
      bounce: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)'
    }
  }
};