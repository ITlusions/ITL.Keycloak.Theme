// @ts-check
// Live counterpart to login-responsive.spec.js: runs the exact same layout assertions
// (no horizontal overflow, card centered, no header/footer overlap) but against the real
// Keycloak-rendered login page instead of the static preview/light/login.html file.
//
// Prerequisites:
//   1. `docker compose up -d` from the repo root (theme is live-mounted, caching disabled).
//   2. tests/keycloak-admin-setup.spec.js has been run at least once, so the master realm's
//      Login theme is set to itlusions.
//
// Navigating to the admin console while logged out triggers Keycloak's own redirect into the
// themed login page for the master realm - this is the real FreeMarker-rendered page, not the
// static mirror, so any drift between login.ftl/template.ftl and the preview would show up here.
const { test, expect } = require('@playwright/test');
const path = require('path');
const fs = require('fs');

const KC = 'http://localhost:8080';
const LIVE_LOGIN_URL = `${KC}/admin/master/console/`;
const SCREENSHOT_DIR = path.resolve(__dirname, 'screenshots-live');
fs.mkdirSync(SCREENSHOT_DIR, { recursive: true });

const DEVICES = [
  { name: 'Galaxy S24/S25 (base)', width: 360, height: 780 },
  { name: 'iPhone 16', width: 393, height: 852 },
  { name: 'Galaxy S24/S25 Ultra', width: 412, height: 915 },
  { name: 'iPhone 16 Pro Max', width: 430, height: 932 },
  { name: 'iPad Air 11" (M2)', width: 820, height: 1180 },
  { name: 'Desktop 1080p', width: 1920, height: 1080 },
  { name: 'Laptop 1366x768', width: 1366, height: 768 },
];

const EDGE_CASES = [
  { name: 'sub-legacy-phone width', width: 245, height: 400 },
  { name: 'extreme narrow+short (DevTools test size)', width: 200, height: 250 },
  { name: 'iPad mini landscape (short height)', width: 1133, height: 744 },
];

test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
});

/** @param {import('@playwright/test').Page} page */
async function gotoLiveLogin(page) {
  await page.goto(LIVE_LOGIN_URL, { waitUntil: 'networkidle' });
  await page.waitForSelector('.itlusions-card', { timeout: 15000 });
}

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
    };
  });
}

// theme.properties' hideFooter flag removes .itlusions-footer from the DOM entirely (not just
// visually hidden) - non-blocking helper so these tests keep working in both states instead of
// throwing on a null footer. With no footer, the card's lower boundary is simply the viewport
// edge (the .itlusions-theme flex-column layout gives content-wrapper the freed space directly).
function footerBoundaryY(footer, viewportHeight) {
  return footer ? footer.top : viewportHeight;
}

test.describe('LIVE Keycloak login - real device matrix', () => {
  for (const device of DEVICES) {
    test(`no horizontal overflow on ${device.name} (${device.width}x${device.height})`, async ({ page }) => {
      await page.setViewportSize({ width: device.width, height: device.height });
      await gotoLiveLogin(page);
      const { scrollWidth, viewport } = await getLayoutBoxes(page);
      expect(scrollWidth).toBeLessThanOrEqual(viewport.width + 1);
    });

    test(`card stays clear of header/footer on ${device.name}`, async ({ page }) => {
      await page.setViewportSize({ width: device.width, height: device.height });
      await gotoLiveLogin(page);
      const { header, footer, card, viewport } = await getLayoutBoxes(page);
      expect(card).not.toBeNull();
      expect(card.top).toBeGreaterThanOrEqual(header.bottom - 0.5);
      expect(card.bottom).toBeLessThanOrEqual(footerBoundaryY(footer, viewport.height) + 0.5);
    });

    test(`card is horizontally centered on ${device.name}`, async ({ page }) => {
      await page.setViewportSize({ width: device.width, height: device.height });
      await gotoLiveLogin(page);
      const { viewport, card } = await getLayoutBoxes(page);
      const cardCenterX = card.left + card.width / 2;
      expect(Math.abs(cardCenterX - viewport.width / 2)).toBeLessThanOrEqual(2);
    });
  }
});

test.describe('LIVE Keycloak login - edge cases (regression guards)', () => {
  for (const device of EDGE_CASES) {
    test(`card never overlaps footer on ${device.name} (${device.width}x${device.height})`, async ({ page }) => {
      await page.setViewportSize({ width: device.width, height: device.height });
      await gotoLiveLogin(page);
      const { footer, card, viewport } = await getLayoutBoxes(page);
      expect(card.bottom).toBeLessThanOrEqual(footerBoundaryY(footer, viewport.height) + 0.5);
    });

    test(`card does not jump to a corner on ${device.name}`, async ({ page }) => {
      await page.setViewportSize({ width: device.width, height: device.height });
      await gotoLiveLogin(page);
      const { viewport, header, footer, card } = await getLayoutBoxes(page);
      const cardCenterX = card.left + card.width / 2;
      const cardCenterY = card.top + card.height / 2;
      const safeAreaCenterY = (header.bottom + footerBoundaryY(footer, viewport.height)) / 2;
      expect(Math.abs(cardCenterX - viewport.width / 2)).toBeLessThanOrEqual(viewport.width * 0.15);
      expect(Math.abs(cardCenterY - safeAreaCenterY)).toBeLessThanOrEqual(Math.max(40, viewport.height * 0.15));
    });
  }
});

test.describe('LIVE Keycloak login - screenshots', () => {
  for (const c of [...DEVICES, ...EDGE_CASES]) {
    test(`screenshot: ${c.name} (${c.width}x${c.height})`, async ({ page }) => {
      await page.setViewportSize({ width: c.width, height: c.height });
      await gotoLiveLogin(page);
      await page.evaluate(() => document.fonts.ready);
      await page.waitForTimeout(300);
      const fileName = `live__${c.name.replace(/[^a-z0-9]+/gi, '-')}__${c.width}x${c.height}.png`;
      await page.screenshot({ path: path.join(SCREENSHOT_DIR, fileName) });
    });
  }
});

test.describe('LIVE Keycloak login - real-server-specific behavior', () => {
  test('renders the actual FreeMarker template (not the static mirror)', async ({ page }) => {
    await page.setViewportSize({ width: 1280, height: 900 });
    await gotoLiveLogin(page);
    // The master realm's real displayName is "Keycloak", proving this came from login.ftl's
    // <#if realm.displayName??> branch and not the static preview's hardcoded fallback text.
    await expect(page.locator('.itlusions-form-header h1')).toHaveText('Keycloak');
  });

  test('master realm renders all optional login features once enabled', async ({ page }) => {
    await page.setViewportSize({ width: 1280, height: 900 });
    await gotoLiveLogin(page);
    // tests/keycloak-admin-setup.spec.js enables remember-me, forgot-password, registration, and
    // a dummy GitHub IDP on the master realm specifically so every login.ftl <#if> branch (not
    // just the default-off master realm state) can be exercised and visually audited.
    await expect(page.locator('#rememberMe')).toHaveCount(1);
    // Exactly 2 (Forgot Password + Create Account): login.ftl's "info" section used to render a
    // third, duplicate registration link here - removed deliberately to reclaim vertical space
    // (see the fixed-height/overflow investigation), not just left over by accident.
    await expect(page.locator('.itlusions-form-options a')).toHaveCount(2);
    await expect(page.locator('.itlusions-social-providers')).toBeVisible();
    // The GitHub button must render its icon (regression guard: Keycloak's built-in identity
    // providers don't populate the legacy iconClasses property, so login.ftl falls back to an
    // inline SVG keyed by provider alias - this was rendering blank before that fix) and span
    // the full card width (regression guard: the #kc-form / .itlusions-content-wrapper selector
    // collision that used to shrink this button to its own content width).
    const githubButton = page.locator('.itlusions-button--social').first();
    await expect(githubButton.locator('svg')).toBeVisible();
    const [btnBox, cardBox] = await Promise.all([
      githubButton.boundingBox(),
      page.locator('.itlusions-card').boundingBox(),
    ]);
    const cardContentWidth = cardBox.width - 2 * 48; // minus the card's --itl-spacing-2xl padding
    expect(btnBox.width).toBeGreaterThan(cardContentWidth * 0.9);
  });

  test('username and password fields are usable', async ({ page }) => {
    await page.setViewportSize({ width: 393, height: 852 });
    await gotoLiveLogin(page);
    await page.fill('#username', 'admin');
    await page.fill('#password', 'wrong-password-for-layout-test-only');
    await expect(page.locator('#username')).toHaveValue('admin');
    await expect(page.locator('#kc-login')).toBeVisible();
  });
});
