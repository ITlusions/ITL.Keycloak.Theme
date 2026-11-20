const { test } = require('@playwright/test');
const path = require('path');
const { pathToFileURL } = require('url');

const LOGIN_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/login.html')).href;

const SIZES = [
  { name: 'iPhone16 (393x852)', width: 393, height: 852 },
  { name: 'Desktop (1920x1080)', width: 1920, height: 1080 },
  { name: 'Laptop (1366x768)', width: 1366, height: 768 },
  { name: 'iPad mini landscape (1133x744)', width: 1133, height: 744 },
];

for (const s of SIZES) {
  test(`debug boxes: ${s.name}`, async ({ page }) => {
    await page.emulateMedia({ reducedMotion: 'reduce' });
    await page.setViewportSize({ width: s.width, height: s.height });
    await page.goto(LOGIN_URL);
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
      const theme = document.querySelector('.itlusions-theme');
      const cs = getComputedStyle(wrapper);
      return {
        theme: rect(theme),
        header: rect(header),
        footer: rect(footer),
        wrapper: rect(wrapper),
        card: rect(card),
        wrapperPadding: { top: cs.paddingTop, bottom: cs.paddingBottom },
        wrapperComputed: { height: cs.height, flexBasis: cs.flexBasis, flexGrow: cs.flexGrow, flexShrink: cs.flexShrink, minHeight: cs.minHeight, gridTemplateRows: cs.gridTemplateRows, gridTemplateColumns: cs.gridTemplateColumns, alignItems: cs.alignItems, justifyItems: cs.justifyItems },
        cardMargins: { top: getComputedStyle(card).marginTop, bottom: getComputedStyle(card).marginBottom, alignSelf: getComputedStyle(card).alignSelf, justifySelf: getComputedStyle(card).justifySelf },
        structure: {
          wrapperChildrenCount: wrapper.children.length,
          wrapperChildrenTags: Array.from(wrapper.children).map(c => c.tagName + '.' + c.className),
          cardParentTag: card.parentElement.tagName + '.' + card.parentElement.className,
          cardOffsetTop: card.offsetTop,
          cardOffsetParent: card.offsetParent ? card.offsetParent.tagName + '.' + card.offsetParent.className : null,
          wrapperOffsetTop: wrapper.offsetTop,
          headerOffsetHeight: header.offsetHeight,
        },
        themeComputed: { display: getComputedStyle(theme).display, flexDirection: getComputedStyle(theme).flexDirection, minHeight: getComputedStyle(theme).minHeight, height: getComputedStyle(theme).height },
        cardComputed: {
          height: getComputedStyle(card).height,
          maxHeight: getComputedStyle(card).maxHeight,
          minHeight: getComputedStyle(card).minHeight,
        },
      };
    });
    console.log('===', s.name, '===');
    console.log(JSON.stringify(data, null, 2));
  });
}
