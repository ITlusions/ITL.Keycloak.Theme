const { test } = require('@playwright/test');
const path = require('path');
const { pathToFileURL } = require('url');

const BASE_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/base.html')).href;

const SIZES = [
  { name: 'user-report-703x1056', width: 703, height: 1056 },
  { name: 'user-report-323x1056', width: 323, height: 1056 },
];

for (const s of SIZES) {
  test(`base.html at ${s.name}`, async ({ page }) => {
    await page.emulateMedia({ reducedMotion: 'reduce' });
    await page.setViewportSize({ width: s.width, height: s.height });
    await page.goto(BASE_URL);
    await page.waitForTimeout(300);
    await page.screenshot({ path: path.join(__dirname, 'screenshots', `verify__${s.name}.png`) });
  });
}
