// @ts-check
const { test, expect } = require('@playwright/test');
const path = require('path');
const { pathToFileURL } = require('url');

const LOGIN_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/login.html')).href;

test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
});

// Widths spanning the whole fluid range, deliberately NOT aligned to breakpoint boundaries -
// the point of clamp()-based sizing is that font-size should change smoothly at every width,
// not just jump at 360/425/426/640/etc.
const WIDTHS = [320, 400, 500, 600, 700, 900, 1100, 1280, 1600];

async function getFontSizes(page) {
  return page.evaluate(() => {
    const px = (sel) => {
      const el = document.querySelector(sel);
      return el ? parseFloat(getComputedStyle(el).fontSize) : null;
    };
    return {
      logo: px('.itlusions-header h1'),
      title: px('.itlusions-form-header h1'),
      subtitle: px('.itlusions-form-header p'),
      label: px('.itlusions-label'),
    };
  });
}

test('fluid font sizes increase monotonically and smoothly with viewport width', async ({ page }) => {
  const results = [];
  for (const width of WIDTHS) {
    await page.setViewportSize({ width, height: 900 });
    await page.goto(LOGIN_URL);
    const sizes = await getFontSizes(page);
    results.push({ width, ...sizes });
  }

  console.log('Fluid typography sweep:', JSON.stringify(results, null, 2));

  for (const key of ['logo', 'title', 'subtitle', 'label']) {
    for (let i = 1; i < results.length; i++) {
      const prev = results[i - 1][key];
      const curr = results[i][key];
      // Monotonic non-decreasing: wider viewport should never produce smaller text.
      expect(curr).toBeGreaterThanOrEqual(prev - 0.01);
    }
  }
});

test('fluid font sizes respect their clamp() floor and ceiling', async ({ page }) => {
  await page.setViewportSize({ width: 320, height: 900 });
  await page.goto(LOGIN_URL);
  const small = await getFontSizes(page);
  expect(small.logo).toBeCloseTo(18, 0); // 1.125rem floor
  expect(small.title).toBeCloseTo(18, 0); // 1.125rem floor
  expect(small.subtitle).toBeCloseTo(11.2, 0); // 0.7rem floor
  expect(small.label).toBeCloseTo(11.2, 0); // 0.7rem floor

  await page.setViewportSize({ width: 2000, height: 900 });
  await page.goto(LOGIN_URL);
  const large = await getFontSizes(page);
  expect(large.logo).toBeCloseTo(28, 0); // 1.75rem ceiling
  expect(large.title).toBeCloseTo(26, 0); // 1.625rem ceiling
  expect(large.subtitle).toBeCloseTo(15, 0); // 0.9375rem ceiling
  expect(large.label).toBeCloseTo(13, 0); // 0.8125rem ceiling
});

test('fluid font sizes differ between two adjacent non-breakpoint widths (proves continuous scaling)', async ({ page }) => {
  await page.setViewportSize({ width: 500, height: 900 });
  await page.goto(LOGIN_URL);
  const a = await getFontSizes(page);

  await page.setViewportSize({ width: 900, height: 900 });
  await page.goto(LOGIN_URL);
  const b = await getFontSizes(page);

  // 500px and 900px both sit inside the old "Medium Mobile" -> "Desktop" no-man's-land where
  // font-size used to be frozen at a single breakpoint value; fluid sizing should show a
  // measurable difference between them.
  expect(b.logo).toBeGreaterThan(a.logo);
  expect(b.title).toBeGreaterThan(a.title);
});
