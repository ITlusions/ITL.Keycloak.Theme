// @ts-check
const { test, expect } = require('@playwright/test');
const path = require('path');
const { pathToFileURL } = require('url');

// The card has a 0.6s fadeIn animation on load; measuring layout mid-animation produces
// misleading bounding boxes (this cost significant debugging time before it was found).
// Our CSS already disables all animations under prefers-reduced-motion, so emulating that
// gives deterministic, at-rest measurements for every test in this file.
test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
});

const LOGIN_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/login.html')).href;
const BASE_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/base.html')).href;

// Real device viewports (portrait, CSS px) chosen to cover every breakpoint boundary we've tuned
// this session: 359/360 (Extra Small -> Small), 425/426 (Small -> Medium Mobile),
// 640/641 (Medium Mobile -> Tablets), 768/769 (Tablets -> Medium Tablets), 1024/1025 (-> Desktop).
const DEVICES = [
  { name: 'Galaxy S24/S25 (base)', width: 360, height: 780 },
  { name: 'iPhone 16', width: 393, height: 852 },
  { name: 'Galaxy S24/S25 Ultra', width: 412, height: 915 },
  { name: 'iPhone 16 Pro Max', width: 430, height: 932 },
  { name: 'iPad Air 11" (M2)', width: 820, height: 1180 },
  { name: 'Desktop 1080p', width: 1920, height: 1080 },
  { name: 'Laptop 1366x768', width: 1366, height: 768 },
];

// Edge cases that previously triggered real bugs this session.
const EDGE_CASES = [
  { name: 'sub-legacy-phone width', width: 245, height: 400 },
  { name: 'extreme narrow+short (DevTools test size)', width: 200, height: 250 },
  { name: 'iPad mini landscape (short height)', width: 1133, height: 744 },
];

/** @param {import('@playwright/test').Page} page */
async function getLayoutBoxes(page) {
  return page.evaluate(() => {
    const rect = (el) => (el ? el.getBoundingClientRect() : null);
    return {
      viewport: { width: window.innerWidth, height: window.innerHeight },
      header: rect(document.querySelector('.itlusions-header')),
      footer: rect(document.querySelector('.itlusions-footer')),
      card: rect(document.querySelector('.itlusions-card')),
      scrollWidth: document.documentElement.scrollWidth,
      scrollHeight: document.documentElement.scrollHeight,
    };
  });
}

for (const url of [LOGIN_URL, BASE_URL]) {
  const pageName = url === LOGIN_URL ? 'login.html' : 'base.html';

  test.describe(`${pageName} - real device matrix`, () => {
    for (const device of DEVICES) {
      test(`no horizontal overflow on ${device.name} (${device.width}x${device.height})`, async ({ page }) => {
        await page.setViewportSize({ width: device.width, height: device.height });
        await page.goto(url);
        const { scrollWidth, viewport } = await getLayoutBoxes(page);
        expect(scrollWidth).toBeLessThanOrEqual(viewport.width + 1);
      });

      test(`card stays clear of header/footer on ${device.name}`, async ({ page }) => {
        await page.setViewportSize({ width: device.width, height: device.height });
        await page.goto(url);
        const { header, footer, card } = await getLayoutBoxes(page);
        expect(card).not.toBeNull();
        // Sub-pixel rounding only; with animations disabled, positions are computed exactly.
        expect(card.top).toBeGreaterThanOrEqual(header.bottom - 0.5);
        expect(card.bottom).toBeLessThanOrEqual(footer.top + 0.5);
      });

      test(`card is horizontally centered on ${device.name}`, async ({ page }) => {
        await page.setViewportSize({ width: device.width, height: device.height });
        await page.goto(url);
        const { viewport, card } = await getLayoutBoxes(page);
        const cardCenterX = card.left + card.width / 2;
        const viewportCenterX = viewport.width / 2;
        expect(Math.abs(cardCenterX - viewportCenterX)).toBeLessThanOrEqual(2);
      });

      test(`card is vertically centered in the safe area on ${device.name}`, async ({ page }) => {
        await page.setViewportSize({ width: device.width, height: device.height });
        await page.goto(url);
        const { header, footer, card } = await getLayoutBoxes(page);
        const safeAreaCenterY = (header.bottom + footer.top) / 2;
        const cardCenterY = card.top + card.height / 2;
        expect(Math.abs(cardCenterY - safeAreaCenterY)).toBeLessThanOrEqual(1);
      });
    }
  });

  test.describe(`${pageName} - edge cases (regression guards)`, () => {
    for (const device of EDGE_CASES) {
      test(`card does not jump to a corner on ${device.name} (${device.width}x${device.height})`, async ({ page }) => {
        await page.setViewportSize({ width: device.width, height: device.height });
        await page.goto(url);
        const { viewport, header, footer, card } = await getLayoutBoxes(page);

        // Regression guard for the Flexbox "safe alignment" corner-snap bug: the card's center
        // should stay near the safe-area center, not collapse toward the top-left or bottom-right.
        const cardCenterX = card.left + card.width / 2;
        const cardCenterY = card.top + card.height / 2;
        const viewportCenterX = viewport.width / 2;
        const safeAreaCenterY = (header.bottom + footer.top) / 2;

        expect(Math.abs(cardCenterX - viewportCenterX)).toBeLessThanOrEqual(viewport.width * 0.15);
        expect(Math.abs(cardCenterY - safeAreaCenterY)).toBeLessThanOrEqual(Math.max(40, viewport.height * 0.15));
      });

      test(`card never overlaps footer on ${device.name}`, async ({ page }) => {
        await page.setViewportSize({ width: device.width, height: device.height });
        await page.goto(url);
        const { footer, card } = await getLayoutBoxes(page);
        expect(card.bottom).toBeLessThanOrEqual(footer.top + 0.5);
      });
    }
  });
}

test.describe('login.html - breakpoint-specific behavior', () => {
  test('card sizes to content (not fixed 652px) below the tablet breakpoint', async ({ page }) => {
    await page.setViewportSize({ width: 393, height: 852 }); // iPhone 16
    await page.goto(LOGIN_URL);
    const { card } = await getLayoutBoxes(page);
    // Regression guard for the missing `height: auto` bug found this session: on phone widths
    // the card must size to its actual content, strictly less than the fixed desktop target.
    expect(card.height).toBeLessThan(652);
  });

  test('card reaches at least the 652px desktop target on a tall desktop viewport, and grows beyond it if content needs more', async ({ page }) => {
    await page.setViewportSize({ width: 1920, height: 1080 });
    await page.goto(LOGIN_URL);
    const { card, footer } = await getLayoutBoxes(page);
    // 652px is a floor (min-height), not a ceiling: the static preview's real content (title,
    // subtitle, 2 fields, remember-me, button, 2 links, divider, social button) is ~670px tall,
    // so the card must grow to fit it instead of clipping - this was a real, silent bug before
    // (content was clipped to exactly 652px) surfaced by testing the actual live Keycloak page
    // with every optional login feature enabled.
    expect(card.height).toBeGreaterThanOrEqual(652);
    expect(card.bottom).toBeLessThanOrEqual(footer.top + 0.5);
  });

  test('card shrinks via max-height instead of overlapping the footer on a short viewport', async ({ page }) => {
    await page.setViewportSize({ width: 1366, height: 768 }); // common laptop resolution
    await page.goto(LOGIN_URL);
    const { footer, card } = await getLayoutBoxes(page);
    expect(card.height).toBeLessThan(652);
    expect(card.bottom).toBeLessThanOrEqual(footer.top + 1);
  });

  test('footer tagline is hidden below 360px and visible at/above it', async ({ page }) => {
    await page.setViewportSize({ width: 359, height: 780 });
    await page.goto(LOGIN_URL);
    await expect(page.locator('.itlusions-footer-tagline')).toBeHidden();

    await page.setViewportSize({ width: 360, height: 780 });
    await page.goto(LOGIN_URL);
    await expect(page.locator('.itlusions-footer-tagline')).toBeVisible();
  });

  test('all form fields are present and usable on a real phone viewport', async ({ page }) => {
    await page.setViewportSize({ width: 393, height: 852 }); // iPhone 16
    await page.goto(LOGIN_URL);

    await page.fill('#username', 'test.user@itlusions.nl');
    await page.fill('#password', 'correct horse battery staple');
    await page.check('#rememberMe');

    await expect(page.locator('#username')).toHaveValue('test.user@itlusions.nl');
    await expect(page.locator('#rememberMe')).toBeChecked();
    await expect(page.locator('#btn-signin')).toBeVisible();
    await expect(page.locator('#forgot-password')).toBeVisible();
    await expect(page.locator('#create-account')).toBeVisible();
  });

  test('language switch updates visible text', async ({ page }) => {
    await page.setViewportSize({ width: 1280, height: 800 });
    await page.goto(LOGIN_URL);
    await expect(page.locator('#form-title')).toHaveText('Welcome to ITlusions');

    await page.click('#lang-btn');
    await page.click('text=Nederlands');

    await expect(page.locator('#form-title')).toHaveText('Welkom bij ITlusions');
    await expect(page.locator('#btn-signin')).toHaveText('Inloggen');
  });
});

test.describe('login.html vs preview/light/login.css parity', () => {
  test('card, header, and footer resolve the expected computed styles at desktop size', async ({ page }) => {
    await page.setViewportSize({ width: 1280, height: 900 });
    await page.goto(LOGIN_URL);

    const cardDisplay = await page.locator('.itlusions-card').evaluate((el) => getComputedStyle(el).maxWidth);
    expect(cardDisplay).toBe('500px');

    const wrapperDisplay = await page.locator('.itlusions-content-wrapper').evaluate((el) => getComputedStyle(el).display);
    expect(wrapperDisplay).toBe('grid');
  });
});
