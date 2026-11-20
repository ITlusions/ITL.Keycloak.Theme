// @ts-check
// Measures the exact left/right gap between the social provider button and the card's edges
// at every tested viewport, against the live Keycloak-rendered login page. The button should be
// perfectly centered within the card's content box (padding-box) at every size - if left/right
// gaps differ, something (padding, margin, an unexpected width constraint) is asymmetric.
const { test, expect } = require('@playwright/test');

const KC = 'http://localhost:8080';
const LIVE_LOGIN_URL = `${KC}/admin/master/console/`;

const VIEWPORTS = [
  { name: 'Galaxy S24/S25 (base)', width: 360, height: 780 },
  { name: 'iPhone 16', width: 393, height: 852 },
  { name: 'Galaxy S24/S25 Ultra', width: 412, height: 915 },
  { name: 'iPhone 16 Pro Max', width: 430, height: 932 },
  { name: 'iPad Air 11" (M2)', width: 820, height: 1180 },
  { name: 'iPad mini landscape', width: 1133, height: 744 },
  { name: 'Laptop 1366x768', width: 1366, height: 768 },
  { name: 'Desktop 1080p', width: 1920, height: 1080 },
];

test.beforeEach(async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
});

for (const vp of VIEWPORTS) {
  test(`social button is horizontally symmetric within the card on ${vp.name} (${vp.width}x${vp.height})`, async ({ page }) => {
    await page.setViewportSize({ width: vp.width, height: vp.height });
    await page.goto(LIVE_LOGIN_URL, { waitUntil: 'networkidle' });
    await page.waitForSelector('.itlusions-card');

    const data = await page.evaluate(() => {
      const card = document.querySelector('.itlusions-card');
      const btn = document.querySelector('.itlusions-button--social');
      if (!card || !btn) return null;
      const cardRect = card.getBoundingClientRect();
      const btnRect = btn.getBoundingClientRect();
      return {
        cardLeft: cardRect.left,
        cardRight: cardRect.right,
        cardWidth: cardRect.width,
        btnLeft: btnRect.left,
        btnRight: btnRect.right,
        btnWidth: btnRect.width,
        leftGap: btnRect.left - cardRect.left,
        rightGap: cardRect.right - btnRect.right,
      };
    });

    expect(data).not.toBeNull();
    const { leftGap, rightGap, cardWidth, btnWidth } = data;
    const asymmetry = Math.abs(leftGap - rightGap);
    const asymmetryRatio = asymmetry / cardWidth;

    console.log(
      `${vp.name}: card=${cardWidth.toFixed(1)}px btn=${btnWidth.toFixed(1)}px ` +
      `leftGap=${leftGap.toFixed(2)}px rightGap=${rightGap.toFixed(2)}px ` +
      `asymmetry=${asymmetry.toFixed(2)}px (${(asymmetryRatio * 100).toFixed(3)}%)`
    );

    // Sub-pixel rounding only - left and right gaps must be equal (button centered, not skewed).
    expect(asymmetry).toBeLessThanOrEqual(0.5);
  });
}
