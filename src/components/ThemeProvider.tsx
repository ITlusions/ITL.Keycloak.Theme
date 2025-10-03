import React from 'react';
import { ThemeProvider as StyledThemeProvider } from 'styled-components';
import { themes, ThemeVariant } from '../themes';
import { GlobalStyles } from './GlobalStyles';

interface ThemeProviderProps {
  variant: ThemeVariant;
  children: React.ReactNode;
}

export const ThemeProvider: React.FC<ThemeProviderProps> = ({ 
  variant, 
  children 
}) => {
  const theme = themes[variant];

  return (
    <StyledThemeProvider theme={theme}>
      <GlobalStyles />
      {children}
    </StyledThemeProvider>
  );
};