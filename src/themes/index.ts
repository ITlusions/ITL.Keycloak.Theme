import { corporateTheme } from './corporate';
import { darkTheme } from './dark';
import { neonTheme } from './neon';
import { ThemeConfig, ThemeVariant } from './types';

export const themes: Record<ThemeVariant, ThemeConfig> = {
  corporate: corporateTheme,
  dark: darkTheme,
  neon: neonTheme
};

export const getTheme = (variant: ThemeVariant): ThemeConfig => {
  return themes[variant] || themes.corporate;
};

export const getThemeVariant = (): ThemeVariant => {
  // Check environment variable or URL parameter for theme selection
  const envVariant = process.env.THEME_VARIANT as ThemeVariant;
  const urlParams = new URLSearchParams(window.location.search);
  const urlVariant = urlParams.get('theme') as ThemeVariant;
  
  const variant = urlVariant || envVariant || 'corporate';
  return variant in themes ? variant : 'corporate';
};

export * from './types';
export * from './corporate';
export * from './dark';
export * from './neon';