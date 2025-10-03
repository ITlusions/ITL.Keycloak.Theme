export interface ThemeConfig {
  name: string;
  displayName: string;
  colors: {
    primary: string;
    secondary: string;
    accent: string;
    background: string;
    surface: string;
    text: {
      primary: string;
      secondary: string;
      muted: string;
    };
    error: string;
    success: string;
    warning: string;
  };
  glass?: {
    background: string;
    blur: string;
    border: string;
    radius: string;
    opacity: number;
  };
  neon?: {
    glow: string;
    gradient: string;
    hue1: number;
    hue2: number;
    hue3: number;
  };
  typography: {
    fontFamily: string;
    fontSize: {
      xs: string;
      sm: string;
      base: string;
      lg: string;
      xl: string;
      '2xl': string;
    };
    fontWeight: {
      normal: number;
      medium: number;
      semibold: number;
      bold: number;
    };
  };
  spacing: {
    xs: string;
    sm: string;
    md: string;
    lg: string;
    xl: string;
    '2xl': string;
  };
  animation: {
    enabled: boolean;
    duration: {
      fast: string;
      normal: string;
      slow: string;
    };
    easing: {
      default: string;
      bounce: string;
    };
  };
}

export type ThemeVariant = 'corporate' | 'dark' | 'neon';