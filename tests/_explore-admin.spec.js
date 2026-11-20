const { test } = require('@playwright/test');
const path = require('path');

const KC = 'http://localhost:8080';
const SHOT = (name) => path.join(__dirname, 'screenshots', `explore__${name}.png`);

test('explore admin login', async ({ page }) => {
  await page.goto(`${KC}/admin/master/console/`);
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: SHOT('01-admin-login-page') });

  await page.fill('#username', 'admin');
  await page.fill('#password', 'admin');
  await page.click('#kc-login');
  await page.waitForLoadState('networkidle');
  await page.screenshot({ path: SHOT('02-admin-console-home') });

  // Try navigating directly to realm settings themes tab
  await page.goto(`${KC}/admin/master/console/#/master/realm-settings/themes`);
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(1000);
  await page.screenshot({ path: SHOT('03-realm-settings-themes') });

  console.log('PAGE URL:', page.url());

  // Click the Login theme dropdown to see the options list (state-independent selector,
  // since the displayed text changes from "Select login theme" to "itlusions" once set)
  await page.locator('[aria-label="Select login theme"]').click();
  await page.waitForTimeout(500);
  await page.screenshot({ path: SHOT('04-login-theme-dropdown-open') });

  const options = await page.locator('button[role="option"], li[role="option"], [role="option"]').allTextContents();
  console.log('DROPDOWN OPTIONS:', JSON.stringify(options));

  await page.getByRole('option', { name: 'itlusions' }).click();
  await page.screenshot({ path: SHOT('05-itlusions-selected') });

  await page.getByRole('button', { name: 'Save' }).click();
  await page.waitForTimeout(1000);
  await page.screenshot({ path: SHOT('06-after-save') });

  // Find and click the admin avatar/user dropdown, then sign out
  await page.locator('#user-dropdown').click();
  await page.waitForTimeout(300);
  await page.screenshot({ path: SHOT('07-admin-menu-open') });

  const menuItems = await page.locator('[role="menuitem"]').allTextContents();
  console.log('ADMIN MENU ITEMS:', JSON.stringify(menuItems));

  await page.getByRole('menuitem', { name: 'Sign out' }).click();
  await page.waitForTimeout(1000);
  await page.screenshot({ path: SHOT('08-after-logout') });
  console.log('URL AFTER LOGOUT:', page.url());
});

test('explore login tab and identity providers', async ({ page }) => {
  await page.goto(`${KC}/admin/master/console/`);
  await page.fill('#username', 'admin');
  await page.fill('#password', 'admin');
  await page.click('#kc-login');
  await page.waitForLoadState('networkidle');

  await page.goto(`${KC}/admin/master/console/#/master/realm-settings/login`);
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(500);
  await page.screenshot({ path: SHOT('09-login-tab') });

  const switches = await page.locator('input[type="checkbox"], [role="switch"]').count();
  console.log('SWITCH COUNT on Login tab:', switches);
  const labels = await page.locator('label').allTextContents();
  console.log('LABELS on Login tab:', JSON.stringify(labels));

  await page.click('text=Identity providers');
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(500);
  await page.screenshot({ path: SHOT('10-identity-providers') });
  console.log('IDP PAGE URL:', page.url());

  await page.getByText('GitHub', { exact: true }).click({ force: true });
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(500);
  await page.screenshot({ path: SHOT('11-add-github-idp') });
  console.log('ADD IDP URL:', page.url());
});
