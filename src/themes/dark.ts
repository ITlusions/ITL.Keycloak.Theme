import { ThemeConfig } from './types';

export const darkTheme: ThemeConfig = {
  name: 'dark',
  displayName: 'ITlusions Dark',
  colors: {
    primary: '#3b82f6',
    secondary: '#1d4ed8',
    accent: '#60a5fa',
    background: '#0f172a',
    surface: '#1e293b',
    text: {
      primary: '#f1f5f9',
      secondary: '#cbd5e1',
      muted: '#64748b'
    },
    error: '#f87171',
    success: '#34d399',
    warning: '#fbbf24'
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