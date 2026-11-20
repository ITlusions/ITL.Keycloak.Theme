const { test } = require('@playwright/test');
const path = require('path');
const { pathToFileURL } = require('url');

const BASE_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/base.html')).href;

test('debug 200x250 base.html', async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' });
  await page.setViewportSize({ width: 200, height: 250 });
  await page.goto(BASE_URL);
  const data = await page.evaluate(() => {
    const rect = (el) => {
      if (!el) return null;
      const r = el.getBoundingClientRect();
      return { top: r.top, bottom: r.bottom, height: r.height };
    };
    const header = document.querySelector('.itlusions-header');
    const footer = document.querySelector('.itlusions-footer');
    const card = document.querySelector('.itlusions-card');
    const wrapper = document.querySelector('.itlusions-content-wrapper');
    const cs = getComputedStyle(wrapper);
    const cardCs = getComputedStyle(card);
    const theme = document.querySelector('.itlusions-theme');
    const themeCs = getComputedStyle(theme);
    return {
      scrollTop: document.scrollingElement.scrollTop,
      docScrollHeight: document.documentElement.scrollHeight,
      bodyScrollHeight: document.body.scrollHeight,
      theme: rect(theme),
      themeComputedHeight: themeCs.height,
      themeJustifyContent: themeCs.justifyContent,
      themeAlignItems: themeCs.alignItems,
      themeChildrenCount: theme.children.length,
      themeChildrenInfo: Array.from(theme.children).map(c => ({
        tag: c.tagName, cls: c.className, rect: rect(c),
      })),
      header: rect(header),
      footer: rect(footer),
      wrapper: rect(wrapper),
      card: rect(card),
      wrapperPadding: { top: cs.paddingTop, bottom: cs.paddingBottom },
      cardComputed: { height: cardCs.height, maxHeight: cardCs.maxHeight, minHeight: cardCs.minHeight, padding: cardCs.padding },
      gridTemplateRows: cs.gridTemplateRows,
    };
  });
  console.log(JSON.stringify(data, null, 2));
});
