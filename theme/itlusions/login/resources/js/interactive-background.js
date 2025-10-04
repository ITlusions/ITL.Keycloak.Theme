/**
 * ITlusions Theme - Interactive Background Effect
 * Mouse-following background animation inspired by https://codepen.io/timjackleus/pen/BKWKEX
 */

(function() {
    'use strict';
    
    // Wait for DOM to be ready
    function ready(fn) {
        if (document.readyState !== 'loading') {
            fn();
        } else {
            document.addEventListener('DOMContentLoaded', fn);
        }
    }
    
    // Initialize the interactive background effect
    function initInteractiveBackground() {
        const themeElement = document.querySelector('.itlusions-theme');
        
        if (!themeElement) {
            console.log('ITlusions theme element not found');
            return;
        }
        
        // Mouse movement sensitivity (higher = less movement, more subtle)
        const mouseSensitivity = 20; // Increased from 8 to 20 for more subtle effect
        
        // Track mouse movement
        function handleMouseMove(e) {
            const windowWidth = window.innerWidth;
            const windowHeight = window.innerHeight;
            
            // Calculate mouse position as percentage
            const mouseX = (e.clientX / windowWidth) * 100;
            const mouseY = (e.clientY / windowHeight) * 100;
            
            // Calculate movement offset (reduced for subtle effect)
            const moveX = (mouseX - 50) / mouseSensitivity;
            const moveY = (mouseY - 50) / mouseSensitivity;
            
            // Apply transform to the background pseudo-element via CSS custom properties
            themeElement.style.setProperty('--mouse-x', `${moveX}%`);
            themeElement.style.setProperty('--mouse-y', `${moveY}%`);
            
            // Debug logging (remove in production)
            if (Math.random() < 0.001) { // Log occasionally to avoid spam
                console.log(`ITlusions background move: ${moveX.toFixed(2)}%, ${moveY.toFixed(2)}%`);
            }
        }
        
        // Add mouse move listener
        document.addEventListener('mousemove', handleMouseMove);
        
        // Reset background position when mouse leaves window
        document.addEventListener('mouseleave', function() {
            themeElement.style.setProperty('--mouse-x', '0%');
            themeElement.style.setProperty('--mouse-y', '0%');
        });
        
        // Initialize CSS custom properties
        themeElement.style.setProperty('--mouse-x', '0%');
        themeElement.style.setProperty('--mouse-y', '0%');
        
        console.log('ITlusions interactive background initialized');
    }
    
    // Touch support for mobile devices
    function initTouchSupport() {
        const themeElement = document.querySelector('.itlusions-theme');
        
        if (!themeElement) return;
        
        let touchStartX = 0;
        let touchStartY = 0;
        
        function handleTouchMove(e) {
            if (e.touches.length === 1) {
                const touch = e.touches[0];
                const windowWidth = window.innerWidth;
                const windowHeight = window.innerHeight;
                
                const mouseX = (touch.clientX / windowWidth) * 100;
                const mouseY = (touch.clientY / windowHeight) * 100;
                
                const moveX = (mouseX - 50) / 25; // Much less sensitive on touch
                const moveY = (mouseY - 50) / 25;
                
                themeElement.style.setProperty('--mouse-x', `${moveX}%`);
                themeElement.style.setProperty('--mouse-y', `${moveY}%`);
            }
        }
        
        function handleTouchEnd() {
            themeElement.style.setProperty('--mouse-x', '0%');
            themeElement.style.setProperty('--mouse-y', '0%');
        }
        
        document.addEventListener('touchmove', handleTouchMove, { passive: true });
        document.addEventListener('touchend', handleTouchEnd);
    }
    
    // Performance optimization: reduce effect on low-end devices
    function shouldEnableEffect() {
        // Disable on very small screens or if user prefers reduced motion
        if (window.innerWidth < 768) return false;
        
        // Check for reduced motion preference
        if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            return false;
        }
        
        return true;
    }
    
    // Initialize when ready
    ready(function() {
        if (shouldEnableEffect()) {
            initInteractiveBackground();
            initTouchSupport();
        } else {
            console.log('ITlusions interactive background disabled (mobile or reduced motion)');
        }
    });
    
})();