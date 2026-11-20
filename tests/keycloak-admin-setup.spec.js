// @ts-check
// Records the manual steps for standing up a local Keycloak (via `docker compose up -d` from
// the repo root, using compose.yaml which live-mounts theme/itlusions with all caching
// disabled), then automates: admin login -> set the itlusions theme as the master realm's
// Login theme -> save -> log out. After this runs, http://localhost:8080/admin/master/console/
// (unauthenticated) will redirect to the real, live-rendered itlusions login theme.
//
// Prerequisites: `docker compose up -d` has been run from the repo root and Keycloak is
// reachable at http://localhost:8080 (poll /admin/master/console/ until it responds).
const { test, expect } = require('@playwright/test');

const KC = 'http://localhost:8080';

test.describe.serial('Keycloak admin: configure itlusions as the master realm login theme', () => {
  test('log in as admin, set Login theme to itlusions, save, and log out', async ({ page }) => {
    // 1. Admin console login (still the stock Keycloak theme at this point).
    await page.goto(`${KC}/admin/master/console/`);
    await page.waitForLoadState('networkidle');
    await expect(page.locator('#username')).toBeVisible();

    await page.fill('#username', 'admin');
    await page.fill('#password', 'admin');
    await page.click('#kc-login');
    await page.waitForLoadState('networkidle');

    // 2. Realm settings > Themes tab for the master realm.
    await page.goto(`${KC}/admin/master/console/#/master/realm-settings/themes`);
    await page.waitForLoadState('networkidle');

    // The dropdown's accessible name stays constant even after a theme is already selected
    // (its visible text changes from "Select login theme" to the chosen theme's name).
    const loginThemeDropdown = page.locator('[aria-label="Select login theme"]');
    await expect(loginThemeDropdown).toBeVisible();
    await loginThemeDropdown.click();

    const option = page.getByRole('option', { name: 'itlusions' });
    await expect(option).toBeVisible();
    await option.click();

    await page.getByRole('button', { name: 'Save' }).click();
    await expect(page.getByText('Realm successfully updated')).toBeVisible();

    // 3. Log out of the admin console.
    await page.locator('#user-dropdown').click();
    await page.getByRole('menuitem', { name: 'Sign out' }).click();
    await page.waitForLoadState('networkidle');

    // Logging out redirects straight into the master realm's (now itlusions-themed) login page.
    await expect(page).toHaveURL(/\/realms\/master\/protocol\/openid-connect\/auth/);
    await expect(page.locator('.itlusions-card')).toBeVisible();
  });

  // Master realm ships with User registration / Forgot password / Remember me all OFF and no
  // identity providers configured, so login.ftl's <#if> conditionals correctly hide those parts
  // of the card. That made an early live-vs-preview comparison look like several components were
  // "missing" - they weren't broken, just correctly hidden per this realm's config. This test
  // enables all of them (with a dummy, non-functional GitHub IDP - client id/secret don't need
  // to be valid since we only need Keycloak to render the "Sign in with GitHub" button, not
  // actually complete an OAuth round-trip) so every themed component can be seen and audited.
  test('enable registration, forgot password, remember me, and a dummy GitHub identity provider', async ({ page }) => {
    await page.goto(`${KC}/admin/master/console/`);
    await page.fill('#username', 'admin');
    await page.fill('#password', 'admin');
    await page.click('#kc-login');
    await page.waitForLoadState('networkidle');

    await page.goto(`${KC}/admin/master/console/#/master/realm-settings/login`);
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(500);

    // These render as PatternFly <label class="pf-v5-c-switch"> elements (not <input type=
    // checkbox>), in DOM order: [0] realm Enabled, [1] User registration, [2] Forgot password,
    // [3] Remember me. Toggle each on only if it's currently "Off" (idempotent re-runs).
    const switches = page.locator('label.pf-v5-c-switch');
    let changed = false;
    for (const index of [1, 2, 3]) {
      const sw = switches.nth(index);
      const state = await sw.innerText();
      if (state.trim() === 'Off') {
        await sw.click();
        changed = true;
      }
    }
    if (changed) {
      const saveButton = page.getByRole('button', { name: 'Save' }).first();
      await saveButton.scrollIntoViewIfNeeded();
      await saveButton.click({ force: true });
      await expect(page.getByText('Realm successfully updated')).toBeVisible();
    }

    // Add a dummy GitHub identity provider so the social-login button renders. Best-effort: the
    // admin console's exact field selectors for this form aren't pinned down yet, so this step
    // is non-blocking - if it fails, the rest of the suite (which doesn't depend on it) still runs.
    try {
      await page.goto(`${KC}/admin/master/console/#/master/identity-providers`);
      await page.waitForLoadState('networkidle');
      const alreadyAdded = await page.getByText('github', { exact: true }).count();
      if (alreadyAdded === 0) {
        await page.getByText('GitHub', { exact: true }).click({ force: true, timeout: 5000 });
        await page.waitForLoadState('networkidle');
        await page.locator('input#clientId, input[name="config.clientId"]').first()
          .fill('dummy-client-id-for-visual-testing-only', { timeout: 5000 });
        await page.locator('input#clientSecret, input[name="config.clientSecret"]').first()
          .fill('dummy-client-secret-for-visual-testing-only', { timeout: 5000 });
        await page.getByRole('button', { name: 'Add', exact: true }).click({ timeout: 5000 });
      }
    } catch (err) {
      console.log('GitHub IDP setup skipped (non-blocking):', err.message.split('\n')[0]);
    }

    // Log out and land back on the now fully-featured login page.
    await page.locator('#user-dropdown').click();
    await page.getByRole('menuitem', { name: 'Sign out' }).click();
    await page.waitForLoadState('networkidle');
    await expect(page.locator('.itlusions-card')).toBeVisible();
  });
});
