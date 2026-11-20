const { test } = require('@playwright/test');

const KC = 'http://localhost:8080';

test('add a second (Google) identity provider for multi-provider testing', async ({ page }) => {
  await page.goto(`${KC}/admin/master/console/`);
  await page.fill('#username', 'admin');
  await page.fill('#password', 'admin');
  await page.click('#kc-login');
  await page.waitForLoadState('networkidle');

  await page.goto(`${KC}/admin/master/console/#/master/identity-providers`);
  await page.waitForLoadState('networkidle');

  const alreadyAdded = await page.getByText('google', { exact: true }).count();
  if (alreadyAdded === 0) {
    await page.waitForTimeout(500);
    // Once at least one IDP exists, this page shows a table + "Add provider" dropdown instead
    // of the empty-state gallery grid used the first time.
    await page.getByRole('button', { name: 'Add provider' }).click();
    await page.waitForTimeout(300);
    await page.getByRole('menuitem', { name: 'Google' }).click();
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(500);
    await page.locator('input#clientId, input[name="config.clientId"]').first()
      .fill('dummy-google-client-id-for-visual-testing-only');
    await page.locator('input#clientSecret, input[name="config.clientSecret"]').first()
      .fill('dummy-google-client-secret-for-visual-testing-only');
    await page.getByRole('button', { name: 'Add', exact: true }).click();
    console.log('Google IDP added');
  } else {
    console.log('Google IDP already present');
  }
});
