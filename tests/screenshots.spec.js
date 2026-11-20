// @ts-check
const { test } = require('@playwright/test');
const path = require('path');
const { pathToFileURL } = require('url');
const fs = require('fs');

const LOGIN_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/login.html')).href;
const BASE_URL = pathToFileURL(path.resolve(__dirname, '../preview/light/base.html')).href;

const OUT_DIR = path.resolve(__dirname, 'screenshots');
fs.mkdirSync(OUT_DIR, { recursive: true });

// Fine-grained sweep through the range where the Flexbox "safe alignment" corner-snap bug and
// the base.html comment-parsing bug both lived (sub-300px widths, including <245px specifically
// called out this session). Height is swept too, independently, to catch short-viewport issues.
const FINE_WIDTH_SWEEP = [];
for (let w = 180; w <= 300; w += 10) FINE_WIDTH_SWEEP.push({ name: `sweep-w${w}`, width: w, height: 400 });

const FINE_HEIGHT_SWEEP = [];
for (let h = 150; h <= 300; h += 10) FINE_HEIGHT_SWEEP.push({ name: `sweep-h${h}`, width: 320, height: h });

// Exact breakpoint boundaries (one px on each side) at a fixed, generous height so any
// off-by-one media query bug shows up as a visible jump between adjacent screenshots.
const BOUNDARIES = [359, 360, 425, 426, 640, 641, 768, 769, 1024, 1025].map((w) => ({
  name: `boundary-${w}`,
  width: w,
  height: 800,
}));

// Real device viewports used throughout this session's fixes.
const DEVICES = [
  { name: 'device-galaxy-s24', width: 360, height: 780 },
  { name: 'device-iphone16', width: 393, height: 852 },
  { name: 'device-galaxy-ultra', width: 412, height: 915 },
  { name: 'device-iphone16-pro-max', width: 430, height: 932 },
  { name: 'device-ipad-air-11', width: 820, height: 1180 },
  { name: 'device-desktop-1080p', width: 1920, height: 1080 },
  { name: 'device-laptop-1366x768', width: 1366, height: 768 },
];

// Specific historical regression cases named explicitly for traceability.
const NAMED_EDGE_CASES = [
  { name: 'edge-245x400-sub-legacy-phone', width: 245, height: 400 },
  { name: 'edge-200x250-devtools-extreme', width: 200, height: 250 },
  { name: 'edge-ipad-mini-landscape', width: 1133, height: 744 },
];

// Most popular real-world viewport sizes (approximate current StatCounter-class usage share),
// distinct from the specific-device DEVICES list above so we cover the broader install base
// rather than just the newest flagships.
const POPULAR_VIEWPORTS = [
  { name: 'popular-iphone-se-8', width: 375, height: 667 },
  { name: 'popular-iphone-12-13-14', width: 390, height: 844 },
  { name: 'popular-iphone-xr-11', width: 414, height: 896 },
  { name: 'popular-android-small', width: 360, height: 640 },
  { name: 'popular-ipad-classic', width: 768, height: 1024 },
  { name: 'popular-laptop-1280x720', width: 1280, height: 720 },
  { name: 'popular-laptop-1440x900', width: 1440, height: 900 },
  { name: 'popular-laptop-1536x864', width: 1536, height: 864 },
];

const ALL_CASES = [...FINE_WIDTH_SWEEP, ...FINE_HEIGHT_SWEEP, ...BOUNDARIES, ...DEVICES, ...NAMED_EDGE_CASES, ...POPULAR_VIEWPORTS];

for (const url of [LOGIN_URL, BASE_URL]) {
  const pageLabel = url === LOGIN_URL ? 'login' : 'base';

  test.describe(`screenshots - ${pageLabel}.html`, () => {
    for (const c of ALL_CASES) {
      test(`${c.name} (${c.width}x${c.height})`, async ({ page }) => {
        await page.emulateMedia({ reducedMotion: 'reduce' });
        await page.setViewportSize({ width: c.width, height: c.height });
        await page.goto(url, { waitUntil: 'networkidle' });
        // document.fonts.ready is now effectively instant since Segoe UI is a system font (no
        // network fetch), but kept as a harmless guard in case a future font does need loading.
        // Also wait for the background <img> probe to confirm the hero photo has decoded, then a
        // short settle time for CSS animations (already disabled via reducedMotion) and layout.
        await page.evaluate(() => document.fonts.ready);
        await page.evaluate(() => new Promise((resolve) => {
          const img = new Image();
          img.onload = resolve;
          img.onerror = resolve;
          img.src = getComputedStyle(document.querySelector('.itlusions-theme'), '::before')
            .backgroundImage.match(/url\(["']?(.*?)["']?\)/)?.[1] || '';
        }));
        await page.waitForTimeout(300);
        const fileName = `${pageLabel}__${c.name}__${c.width}x${c.height}.png`;
        await page.screenshot({ path: path.join(OUT_DIR, fileName) });
      });
    }
  });
}
