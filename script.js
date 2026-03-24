/**
 * script.js - Główny Silnik Płynności Strony JakNieDojadę (v9.0 Extreme)
 */

document.addEventListener('DOMContentLoaded', () => {

    /* ====================================================
       1. ANIMACJE OBSERVER (ScrollReveal) ulepszone
       ==================================================== */
    const reveals = document.querySelectorAll('.reveal');
    const revealOptions = { threshold: 0.1, rootMargin: "0px 0px -40px 0px" };

    const revealOnScroll = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
            }
        });
    }, revealOptions);

    reveals.forEach(reveal => revealOnScroll.observe(reveal));

    /* ====================================================
       2. TRANSLACJA ORBÓW ZA KURSOR (MYSZKĄ) - Desktop Only
       ==================================================== */
    const orbs = document.querySelectorAll('.orb');
    if (orbs.length > 0 && window.matchMedia("(hover: hover)").matches) {
        document.addEventListener('mousemove', (e) => {
            const x = (e.clientX / window.innerWidth - 0.5) * 2; 
            const y = (e.clientY / window.innerHeight - 0.5) * 2;
            orbs[0].style.transform = `translate(${x * -80}px, ${y * -80}px) scale(1.15)`;
            if(orbs[1]) orbs[1].style.transform = `translate(${x * 50}px, ${y * 50}px) scale(1.2)`;
            if(orbs[2]) orbs[2].style.transform = `translate(${x * -30}px, ${y * -30}px) scale(1.05)`;
        });
    }

    /* ====================================================
       3. NAVBAR SCROLL EFFECT
       ==================================================== */
    const navbar = document.querySelector('.navbar');
    if (navbar && !navbar.classList.contains('solid')) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 30) navbar.classList.add('scrolled');
            else navbar.classList.remove('scrolled');
        });
    }

    /* ====================================================
       4. POTĘŻNE MOBILE MENU Z ANIMACJĄ
       ==================================================== */
    const menuToggle = document.querySelector('.menu-toggle');
    const mobileMenu = document.querySelector('.mobile-menu');
    
    if (menuToggle && mobileMenu) {
        menuToggle.addEventListener('click', () => {
            mobileMenu.classList.toggle('open');
            const icon = menuToggle.querySelector('i');
            if(mobileMenu.classList.contains('open')) {
                icon.classList.replace('ri-menu-3-line', 'ri-close-fill');
                document.body.style.overflow = 'hidden'; // block scroll
            } else {
                icon.classList.replace('ri-close-fill', 'ri-menu-3-line');
                document.body.style.overflow = '';
            }
        });

        // Zamknij menu po kliknięciu w link
        const mobileLinks = mobileMenu.querySelectorAll('a');
        mobileLinks.forEach(link => {
            link.addEventListener('click', () => {
                mobileMenu.classList.remove('open');
                menuToggle.querySelector('i').classList.replace('ri-close-fill', 'ri-menu-3-line');
                document.body.style.overflow = '';
            });
        });
    }

    /* ====================================================
       5. ROZWIJAK FAQ (Akordeon)
       ==================================================== */
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
        item.addEventListener('click', () => {
            item.classList.toggle('active');
        });
    });

    /* ====================================================
       6. DZIAŁAJĄCY NEWSLETTER (LOCALSTORAGE OCHRONA)
       ==================================================== */
    const newsletterForm = document.getElementById('real-newsletter');
    const emailInput = document.getElementById('emailInput');
    const statusBox = document.getElementById('newsletterStatus');
    const subBtn = document.getElementById('subBtn');

    if (newsletterForm) {
        let subsList = JSON.parse(localStorage.getItem('jnd_subscribers')) || [];
        if(subsList.length === 0) {
            subsList = ['tester@ai.com', 'startup@visionary.com'];
            localStorage.setItem('jnd_subscribers', JSON.stringify(subsList));
        }
    }

    function showStatus(msg, type) {
        statusBox.textContent = msg;
        statusBox.className = 'newsletter-status'; 
        if (type === 'error') statusBox.classList.add('status-error');
        else statusBox.classList.add('status-success');
        statusBox.style.opacity = '0';
        setTimeout(() => statusBox.style.opacity = '1', 10);
    }
});
