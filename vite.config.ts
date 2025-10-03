import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { keycloakify } from "keycloakify/vite-plugin";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    keycloakify({
      themeName: "itlusions",
      themeVersion: "2.0.0",
      keycloakVersions: {
        hasAccountTheme: true,
        hasAdminTheme: false,
        all: ["25.0.0", "24.0.0", "23.0.0", "22.0.0", "21.0.0"]
      },
      bundler: "vite",
      environmentVariables: [
        { name: "THEME_VARIANT", default: "corporate" },
        { name: "BRAND_COLOR", default: "#2563eb" },
        { name: "ENABLE_ANIMATIONS", default: "true" }
      ]
    })
  ],
  resolve: {
    alias: {
      "@": "/src"
    }
  },
  build: {
    target: "es2015",
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ["react", "react-dom"],
          theme: ["styled-components", "@emotion/react"]
        }
      }
    }
  }
});