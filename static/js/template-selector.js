(() => {
  const trackTemplate = element => window.atsAnalytics?.trackOnce(
    `template_viewed_${element.dataset.analyticsTemplateName}`,
    'template_viewed',
    {template_name: element.dataset.analyticsTemplateName}
  );
  const previews = document.querySelectorAll('[data-analytics-template-name]');
  if (!('IntersectionObserver' in window)) {
    previews.forEach(trackTemplate);
    return;
  }
  const observer = new IntersectionObserver(entries => entries.forEach(entry => {
    if (!entry.isIntersecting) return;
    trackTemplate(entry.target);
    observer.unobserve(entry.target);
  }), {threshold: 0.5});
  previews.forEach(preview => observer.observe(preview));
})();
