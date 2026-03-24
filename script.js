/**
 * script.js - Główny Silnik Płynności Strony JakNieDojadę (Aurora v11.0)
 */

document.addEventListener('DOMContentLoaded', () => {

    /* ====================================================
       1. ANIMACJE OBSERVER (ScrollReveal) 
       ==================================================== */
    const reveals = document.querySelectorAll('.reveal');
    const revealOptions = { 
        threshold: 0.15,
        rootMargin: "0px 0px -50px 0px" 
    };

    const revealOnScroll = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
            }
        });
    }, revealOptions);

    reveals.forEach(reveal => revealOnScroll.observe(reveal));

    // Wymuś widoczność na starcie dla elementów widocznych od razu
    setTimeout(() => {
        window.scrollTo(0, window.scrollY + 1);
        window.scrollTo(0, window.scrollY - 1);
    }, 100);

    /* ====================================================
       2. TRANSLACJA ORBÓW ZA KURSOR (MYSZKĄ)
       ==================================================== */
    const orbs = document.querySelectorAll('.orb');
    if (window.matchMedia("(hover: hover)").matches) {
        document.addEventListener('mousemove', (e) => {
            const x = (e.clientX / window.innerWidth - 0.5) * 2; 
            const y = (e.clientY / window.innerHeight - 0.5) * 2;
            if(orbs[0]) orbs[0].style.transform = `translate(${x * -40}px, ${y * -40}px)`;
            if(orbs[1]) orbs[1].style.transform = `translate(${x * 30}px, ${y * 30}px)`;
            if(orbs[2]) orbs[2].style.transform = `translate(${x * -20}px, ${y * -20}px)`;
        });
    }

    /* ====================================================
       3. NAVBAR SCROLL EFFECT
       ==================================================== */
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('solid');
        } else {
            // Jeśli nie jest na podstronie (która ma zawsze 'solid'), usuń klasę
            if (!document.title.includes('|')) {
                navbar.classList.remove('solid');
            }
        }
    });

    /* ====================================================
       4. MOBILE MENU (Zgodność z style.css .active)
       ==================================================== */
    const menuToggle = document.querySelector('.menu-toggle');
    const mobileMenu = document.querySelector('.mobile-menu');
    
    if (menuToggle && mobileMenu) {
        menuToggle.addEventListener('click', () => {
            mobileMenu.classList.toggle('active');
            const icon = menuToggle.querySelector('i');
            if(mobileMenu.classList.contains('active')) {
                icon.className = 'ri-close-fill';
                document.body.style.overflow = 'hidden';
            } else {
                icon.className = 'ri-menu-3-line';
                document.body.style.overflow = '';
            }
        });

        // Zamknij menu po kliknięciu w link
        const mobileLinks = mobileMenu.querySelectorAll('a');
        mobileLinks.forEach(link => {
            link.addEventListener('click', () => {
                mobileMenu.classList.remove('active');
                menuToggle.querySelector('i').className = 'ri-menu-3-line';
                document.body.style.overflow = '';
            });
        });
    }

    /* ====================================================
       5. ROZWIJAK FAQ
       ==================================================== */
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
        item.addEventListener('click', () => {
            item.classList.toggle('active');
        });
    });
});
