// @ts-check
// Component-by-component computed-style audit: preview/light/login.html vs the live
// Keycloak-rendered login page. For every selector, records whether the element exists and its
// font-family/font-size/font-weight/color/padding, then prints a diff table. This is the
// ground-truth check behind any "it looks off" impression - screenshots can mislead, computed
// styles cannot.
const { test } = require('@playwright/test');
const path = require('path');
const { pathToFileURL } = require('url');

const PREVIEW_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/login.html')).href;
const LIVE_URL = 'http://localhost:8080/admin/master/console/';

const COMPONENTS = [
  { label: 'Header logo (h1)', selector: '.itlusions-header h1' },
  { label: 'Language dropdown button', selector: '.language-dropdown button' },
  { label: 'Card container', selector: '.itlusions-card' },
  { label: 'Welcome title (h1)', selector: '.itlusions-form-header h1' },
  { label: 'Subtitle (p)', selector: '.itlusions-form-header p' },
  { label: 'Username label', selector: 'label[for="username"]' },
  { label: 'Username input', selector: '#username' },
  { label: 'Password label', selector: 'label[for="password"]' },
  { label: 'Password input', selector: '#password' },
  { label: 'Remember-me checkbox wrapper', selector: '.itlusions-checkbox' },
  { label: 'Remember-me label', selector: 'label[for="rememberMe"]' },
  { label: 'Sign In button', selector: 'button[type="submit"], input[type="submit"]' },
  { label: 'Forgot Password link', selector: '#forgot-password, a[href*="reset-credentials"], .itlusions-form-options a >> nth=0' },
  { label: 'Create Account link', selector: '#create-account, a[href*="registration"]' },
  { label: 'Social providers wrapper', selector: '.itlusions-social-providers' },
  { label: 'Social provider button (GitHub or similar)', selector: '.itlusions-button--social' },
  { label: 'Footer text', selector: '.itlusions-footer p' },
  { label: 'Footer link', selector: '.itlusions-footer a' },
];

/** @param {import('@playwright/test').Page} page */
async function auditPage(page) {
  const results = {};
  for (const c of COMPONENTS) {
    const el = page.locator(c.selector).first();
    const count = await el.count();
    if (count === 0) {
      results[c.label] = { exists: false };
      continue;
    }
    const style = await el.evaluate((node) => {
      const cs = getComputedStyle(node);
      return {
        fontFamily: cs.fontFamily,
        fontSize: cs.fontSize,
        fontWeight: cs.fontWeight,
        color: cs.color,
        lineHeight: cs.lineHeight,
        padding: cs.padding,
        visible: node.getBoundingClientRect().width > 0 && node.getBoundingClientRect().height > 0,
      };
    }).catch(() => null);
    results[c.label] = { exists: true, ...style };
  }
  return results;
}

test('component-by-component audit: preview vs live', async ({ page }) => {
  await page.setViewportSize({ width: 1280, height: 900 });

  await page.goto(PREVIEW_URL);
  await page.waitForTimeout(300);
  const previewResults = await auditPage(page);

  await page.goto(LIVE_URL, { waitUntil: 'networkidle' });
  await page.waitForSelector('.itlusions-card');
  await page.waitForTimeout(300);
  const liveResults = await auditPage(page);

  console.log('\n' + '='.repeat(120));
  console.log('COMPONENT AUDIT: preview/light/login.html  vs  LIVE Keycloak (master realm)');
  console.log('='.repeat(120));

  for (const c of COMPONENTS) {
    const p = previewResults[c.label];
    const l = liveResults[c.label];
    console.log(`\n--- ${c.label} ---`);
    console.log(`  selector: ${c.selector}`);
    if (!p.exists && !l.exists) {
      console.log('  PREVIEW: absent | LIVE: absent');
      continue;
    }
    if (p.exists && !l.exists) {
      console.log('  PREVIEW: present | LIVE: *** MISSING ***');
      continue;
    }
    if (!p.exists && l.exists) {
      console.log('  PREVIEW: absent | LIVE: present (unexpected extra element)');
      continue;
    }
    const mismatch = [];
    for (const key of ['fontFamily', 'fontSize', 'fontWeight', 'color', 'lineHeight']) {
      if (p[key] !== l[key]) mismatch.push(key);
    }
    console.log(`  PREVIEW: font="${p.fontFamily}" size=${p.fontSize} weight=${p.fontWeight} color=${p.color} line-height=${p.lineHeight}`);
    console.log(`  LIVE:    font="${l.fontFamily}" size=${l.fontSize} weight=${l.fontWeight} color=${l.color} line-height=${l.lineHeight}`);
    console.log(mismatch.length ? `  ⚠ MISMATCH in: ${mismatch.join(', ')}` : '  ✓ identical');
  }
  console.log('\n' + '='.repeat(120));
});
