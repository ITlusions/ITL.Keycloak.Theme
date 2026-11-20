const { test } = require('@playwright/test');

const VIEWPORTS = [
  { name: 'Extra Small (359x700)', width: 359, height: 700 },
  { name: 'Galaxy S24/S25 base', width: 360, height: 780 },
  { name: 'iPhone 16', width: 393, height: 852 },
  { name: 'Galaxy S24/S25 Ultra', width: 412, height: 915 },
  { name: 'iPhone 16 Pro Max', width: 430, height: 932 },
  { name: 'Medium Mobile (500x800)', width: 500, height: 800 },
  { name: 'Tablet (700x900)', width: 700, height: 900 },
  { name: 'iPad Air 11" (M2)', width: 820, height: 1180 },
  { name: 'Medium Tablet (900x1000)', width: 900, height: 1000 },
  { name: 'iPad mini landscape', width: 1133, height: 744 },
  { name: 'Laptop 1366x768', width: 1366, height: 768 },
  { name: 'Desktop 1080p', width: 1920, height: 1080 },
];

for (const vp of VIEWPORTS) {
  test(`measure footer on ${vp.name} (${vp.width}x${vp.height})`, async ({ page }) => {
    await page.emulateMedia({ reducedMotion: 'reduce' });
    await page.setViewportSize({ width: vp.width, height: vp.height });
    await page.goto('http://localhost:8080/admin/master/console/', { waitUntil: 'networkidle' });
    await page.waitForSelector('.itlusions-card');

    const data = await page.evaluate(() => {
      const footer = document.querySelector('.itlusions-footer');
      const tagline = document.querySelector('.itlusions-footer-tagline');
      const p = footer.querySelector('p');
      const cs = getComputedStyle(footer);
      const rect = footer.getBoundingClientRect();
      return {
        footerHeight: rect.height,
        footerWidth: rect.width,
        padding: cs.padding,
        fontSize: cs.fontSize,
        paragraphLineCount: Math.round(p.getBoundingClientRect().height / parseFloat(cs.lineHeight)),
        lineHeight: cs.lineHeight,
        taglineVisible: tagline ? getComputedStyle(tagline).display !== 'none' : null,
        footerText: footer.innerText.replace(/\s+/g, ' ').trim(),
      };
    });

    console.log(
      `${vp.name.padEnd(28)} ${String(vp.width).padStart(5)}x${String(vp.height).padEnd(5)} | ` +
      `height=${data.footerHeight.toFixed(1).padStart(6)}px | lines=${data.paragraphLineCount} | ` +
      `tagline=${data.taglineVisible} | padding=${data.padding} | font=${data.fontSize}`
    );
  });
}
