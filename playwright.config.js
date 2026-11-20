// @ts-check
const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  fullyParallel: true,
  reporter: [['list']],
  use: {
    // preview/light/login.html is a fully static page (no server-rendered dynamic parts),
    // so it's tested directly from disk rather than through a dev server.
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
});
