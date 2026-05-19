document.querySelectorAll('form').forEach((form) => {
  form.addEventListener('submit', () => {
    const button = form.querySelector('button[type="submit"]:not([disabled])');
    if (!button) return;
    button.dataset.originalText = button.textContent;
    button.textContent = 'Traitement...';
  });
});
