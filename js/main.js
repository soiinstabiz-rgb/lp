/* =========================================================
   LP 用スクリプト（依存ライブラリなし）
   ========================================================= */
(function () {
  'use strict';

  /* --- フッターの年号を自動更新 ------------------------- */
  var year = document.getElementById('year');
  if (year) year.textContent = String(new Date().getFullYear());

  /* --- スクロールでヘッダーに影 / 固定CTAを出す --------- */
  var header    = document.getElementById('header');
  var stickyCta = document.querySelector('.sticky-cta');
  var ticking   = false;

  function onScroll() {
    var y = window.scrollY;
    if (header) header.classList.toggle('is-scrolled', y > 8);
    if (stickyCta) stickyCta.classList.toggle('is-visible', y > 600);
    ticking = false;
  }

  window.addEventListener('scroll', function () {
    if (!ticking) {
      window.requestAnimationFrame(onScroll);
      ticking = true;
    }
  }, { passive: true });
  onScroll();

  /* --- セクションのフェードイン ------------------------- */
  var targets = document.querySelectorAll(
    '.card, .voice, .plan, .flow__step, .problem, .stat, .section__title'
  );

  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-in');
        io.unobserve(entry.target);
      });
    }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });

    targets.forEach(function (el, i) {
      el.classList.add('reveal');
      // 同じ行の要素を少しずつ遅らせて出す
      el.style.transitionDelay = (i % 4) * 70 + 'ms';
      io.observe(el);
    });
  }

  /* --- FAQ: 開いたら他を閉じる（アコーディオン） -------- */
  var faqItems = document.querySelectorAll('.faq__item');
  faqItems.forEach(function (item) {
    item.addEventListener('toggle', function () {
      if (!item.open) return;
      faqItems.forEach(function (other) {
        if (other !== item) other.open = false;
      });
    });
  });

  /* --- お問い合わせフォーム ----------------------------
     現在は送信先が未設定のため、送信を止めて案内を出します。
     実際に送信するには README「フォームの接続」を参照し、
     ENDPOINT に送信先URLを設定してください。
     ---------------------------------------------------- */
  var ENDPOINT = ''; // 例: 'https://formspree.io/f/xxxxxxx'

  var form   = document.getElementById('contact-form');
  var status = document.getElementById('form-status');

  function setStatus(message, type) {
    if (!status) return;
    status.textContent = message;
    status.className = 'form__status' + (type ? ' is-' + type : '');
  }

  if (form) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();

      if (!form.checkValidity()) {
        form.reportValidity();
        return;
      }

      if (!ENDPOINT) {
        setStatus('送信先が未設定です。js/main.js の ENDPOINT を設定してください。', 'error');
        return;
      }

      var button = form.querySelector('button[type="submit"]');
      if (button) button.disabled = true;
      setStatus('送信中…');

      fetch(ENDPOINT, {
        method: 'POST',
        headers: { Accept: 'application/json' },
        body: new FormData(form)
      })
        .then(function (res) {
          if (!res.ok) throw new Error('HTTP ' + res.status);
          form.reset();
          setStatus('送信しました。翌営業日までにご連絡いたします。', 'ok');
        })
        .catch(function () {
          setStatus('送信に失敗しました。時間をおいて再度お試しください。', 'error');
        })
        .finally(function () {
          if (button) button.disabled = false;
        });
    });
  }
})();
