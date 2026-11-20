const { test } = require('@playwright/test');

test('measure laptop overflow precisely', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.setViewportSize({ width: 1366, height: 768 });
  await page.goto('http://localhost:8080/admin/master/console/', { waitUntil: 'networkidle' });
  await page.waitForSelector('.itlusions-card');

  const data = await page.evaluate(() => {
    const rect = (el) => (el ? el.getBoundingClientRect() : null);
    const card = document.querySelector('.itlusions-card');
    const wrapper = document.querySelector('.itlusions-content-wrapper');
    const cs = getComputedStyle(card);
    return {
      cardRect: rect(card),
      wrapperRect: rect(wrapper),
      cardScrollHeight: card.scrollHeight,
      cardClientHeight: card.clientHeight,
      overflowAmount: card.scrollHeight - card.clientHeight,
      cardComputed: { height: cs.height, maxHeight: cs.maxHeight, padding: cs.padding },
    };
  });
  console.log(JSON.stringify(data, null, 2));
});
