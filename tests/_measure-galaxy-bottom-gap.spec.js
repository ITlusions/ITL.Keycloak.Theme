const { test } = require('@playwright/test');

const VIEWPORTS = [
  { name: 'Galaxy S24/S25 base', width: 360, height: 780 },
  { name: 'Galaxy S24/S25 Ultra', width: 412, height: 915 },
];

for (const vp of VIEWPORTS) {
  test(`measure bottom gap on ${vp.name}`, async ({ page }) => {
    await page.emulateMedia({ reducedMotion: 'reduce' });
    await page.setViewportSize({ width: vp.width, height: vp.height });
    await page.goto('http://localhost:8080/admin/master/console/', { waitUntil: 'networkidle' });
    await page.waitForSelector('.itlusions-card');

    const data = await page.evaluate(() => {
      const rect = (el) => (el ? el.getBoundingClientRect() : null);
      const card = document.querySelector('.itlusions-card');
      const buttons = Array.from(document.querySelectorAll('.itlusions-button--social'));
      const lastButton = buttons[buttons.length - 1];
      const cardRect = rect(card);
      const lastButtonRect = rect(lastButton);
      const cs = getComputedStyle(card);
      return {
        cardTop: cardRect.top,
        cardBottom: cardRect.bottom,
        cardHeight: cardRect.height,
        lastButtonBottom: lastButtonRect.bottom,
        gapBelowLastButton: cardRect.bottom - lastButtonRect.bottom,
        cardPaddingBottom: cs.paddingBottom,
        cardComputedHeight: cs.height,
        cardMinHeight: cs.minHeight,
        cardMaxHeight: cs.maxHeight,
        cardScrollHeight: card.scrollHeight,
        cardClientHeight: card.clientHeight,
        numSocialButtons: buttons.length,
      };
    });
    console.log(`\n=== ${vp.name} (${vp.width}x${vp.height}) ===`);
    console.log(JSON.stringify(data, null, 2));
  });
}
