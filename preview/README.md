# ITlusions Keycloak Theme - Preview Files

This folder contains HTML preview files for the ITlusions Keycloak authentication theme. The previews show exactly how each authentication page will look in the live Keycloak instance.

## Directory Structure

```
preview/
├── light/          # Light theme previews (default)
│   ├── login.html
│   ├── authenticated.html
│   ├── register.html
│   ├── error.html
│   ├── otp.html
│   └── reset-password.html
└── dark/           # Dark theme previews
    ├── login.html
    ├── authenticated.html
    ├── register.html
    ├── error.html
    ├── otp.html
    └── reset-password.html
```

## Preview Pages

### Light Theme (`/light`)

The primary light theme with modern glasmorphic design:

- **`login.html`** - Main login form with username/password authentication
  - Email or username input (bilingual support)
  - Password input
  - Remember me checkbox
  - GitHub social provider button
  - Forgot Password & Create Account links
  - Mouse-tracking background effect

- **`authenticated.html`** - Success page after authentication
  - Checkmark animation
  - Success message (bilingual)
  - 5-second countdown timer
  - Auto-close for popup windows
  - Redirect to application button

- **`register.html`** - User registration form
  - Name input
  - Email input
  - Password input
  - Password confirmation
  - Terms agreement checkbox
  - Social provider options

- **`error.html`** - Error notification page
  - Error message display
  - Try Again button
  - Back to Login link

- **`otp.html`** - One-Time Password (OTP) verification
  - OTP input field (6 digits)
  - Resend OTP link
  - Time remaining counter

- **`reset-password.html`** - Password reset request
  - Email address input
  - Send Reset Link button
  - Back to Login link

### Dark Theme (`/dark`)

Enhanced dark theme with glasmorphic effects:

- Same page structure as light theme
- Dark background with enhanced gradient
- Drift animation for background
- Button shine effects on hover
- Optimized contrast for dark mode

## Features

### Design System
- **Typography**: Inter font family (weights: 400, 500, 600, 700)
- **Colors**: 
  - Primary: #2563eb (Blue)
  - Accent: #10b981 (Green)
  - Error: #dc2626 (Red)
  - 45+ CSS variables for complete customization
- **Spacing**: 6-tier scale (xs to 2xl)
- **Shadows**: Layered shadows with glasmorphic glow effects
- **Animations**: Smooth transitions with cubic-bezier easing

### Interactive Elements
- **Mouse Tracking**: Background shifts subtly with mouse movement
- **Hover Effects**: Buttons animate upward with shadow expansion
- **Form Validation**: Real-time error display
- **Countdown**: Auto-updating timer on authenticated page
- **Language Support**: Bilingual UI (English/Dutch)

### Responsive Design
- Mobile-first approach
- Breakpoint: 640px
- Optimized touch interactions
- Readable on all screen sizes

## How to Use

### View Previews
1. Open any HTML file in your browser:
   ```
   file:///d:/repos/ITL.Keycloak.Theme/preview/light/login.html
   file:///d:/repos/ITL.Keycloak.Theme/preview/dark/login.html
   ```

2. Test interactive features:
   - Move mouse over the background to see the tracking effect
   - Click the language button to switch between EN/NL
   - Watch the countdown timer on authenticated page
   - Test form interactions (buttons, links, checkboxes)

### Development
These HTML files replicate the exact output from the FreeMarker templates:
- `theme/itlusions/login/template.ftl` - Base layout macro
- `theme/itlusions/login/login.ftl` - Login form template
- `theme/itlusions/login/authenticated.ftl` - Success page template
- `theme/itlusions/login/resources/css/login.css` - Main styles
- `theme/itlusions/login/resources/css/authenticated.css` - Success page styles
- `theme/itlusions/login/resources/js/interactive-background.js` - Mouse tracking
- `theme/itlusions/login/resources/js/authenticated.js` - Countdown logic

### Deployment
To deploy these theme files to a live Keycloak instance:

1. Copy theme files to Keycloak:
   ```bash
   cp -r theme/itlusions/login/* <keycloak-home>/themes/itlusions/login/
   ```

2. Set theme in Keycloak Admin Console:
   - Go to Realm Settings → Themes
   - Set Login Theme to `itlusions`
   - Save changes

3. Visit the login page to see the live theme:
   ```
   https://sts.itlusions.com/realms/master/account/
   ```

## Browser Support
- ✅ Chrome/Edge 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Mobile browsers (iOS Safari, Chrome Mobile)

## Accessibility
- Semantic HTML structure
- ARIA labels on form inputs
- Keyboard navigation support
- Focus indicators on interactive elements
- High contrast colors (WCAG AA compliant)
- Respects `prefers-reduced-motion` setting

## Customization

### Colors
Edit CSS variables in the theme files:
```css
:root {
  --itl-primary: #2563eb;      /* Change primary color */
  --itl-accent: #10b981;       /* Change accent color */
  --itl-error: #dc2626;        /* Change error color */
}
```

### Fonts
Google Fonts are loaded by default. To change:
1. Update the font link in `template.ftl`
2. Change `--itl-font-family` CSS variable
3. Update font weights as needed

### Background Image
The background image is located at:
```
theme/itlusions/login/resources/img/hero-bg.jpg
```

Replace with a different image to customize the background.

## License
This theme is part of the ITL.Keycloak.Theme project. See LICENSE file in the root directory.

## Support
For issues or questions about the theme:
1. Check the theme configuration in `theme.properties`
2. Review FreeMarker template files for logic
3. Test CSS in the preview files
4. Verify Keycloak version compatibility

---

Last Updated: 2026-07-26
Version: 1.0
