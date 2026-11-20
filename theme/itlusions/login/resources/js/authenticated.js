/**
 * ITlusions Keycloak Theme - Authenticated Page Script
 * Handles countdown timer and auto-close functionality
 */

(function() {
  'use strict';

  const COUNTDOWN_DURATION = 5; // seconds

  /**
   * Initialize the countdown timer
   */
  function initCountdown() {
    const countdownElement = document.getElementById('countdown');
    if (!countdownElement) return;

    let remainingTime = COUNTDOWN_DURATION;
    
    // Update countdown every second
    const countdownInterval = setInterval(() => {
      remainingTime--;
      countdownElement.textContent = remainingTime;

      if (remainingTime <= 0) {
        clearInterval(countdownInterval);
        handleAuthenticationComplete();
      }
    }, 1000);
  }

  /**
   * Handle post-authentication redirect
   */
  function handleAuthenticationComplete() {
    // Check if this is a popup window
    if (window.opener && window.opener !== window) {
      // Close the popup window
      window.close();
    } else {
      // Redirect to the client's base URL
      const clientBaseUrl = getClientBaseUrl();
      if (clientBaseUrl) {
        window.location.href = clientBaseUrl;
      } else {
        // Fallback: close the tab
        window.close();
      }
    }
  }

  /**
   * Extract client base URL from the DOM
   * The template.ftl should include this as a data attribute or href
   */
  function getClientBaseUrl() {
    // Try to get from a button or link with href
    const redirectLink = document.querySelector('.authenticated-button[href]');
    if (redirectLink && redirectLink.href) {
      return redirectLink.href;
    }

    // Try to get from a data attribute if set
    const dataUrl = document.body.getAttribute('data-client-base-url');
    if (dataUrl) {
      return dataUrl;
    }

    return null;
  }

  /**
   * Add click handler to the redirect button
   */
  function initRedirectButton() {
    const redirectButton = document.querySelector('.authenticated-button');
    if (redirectButton) {
      redirectButton.addEventListener('click', (e) => {
        e.preventDefault();
        handleAuthenticationComplete();
      });
    }
  }

  /**
   * Initialize on DOM ready
   */
  function init() {
    // Use MutationObserver to wait for DOM to be ready if needed
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => {
        initCountdown();
        initRedirectButton();
      });
    } else {
      initCountdown();
      initRedirectButton();
    }
  }

  // Start initialization
  init();
})();
