(() => {
  'use strict';

  const EVENT_PARAMS = {
    cv_builder_started: ['source'],
    cv_preview_viewed: ['template_type'],
    cv_generated: ['format', 'template_type'],
    cv_downloaded: ['format', 'template_type'],
    cv_builder_completed: [],
    resume_tailor_started: ['input_type', 'ai_mode'],
    resume_tailor_completed: ['input_type', 'ai_mode'],
    resume_tailor_failed: ['error_type'],
    tailored_resume_downloaded: ['format'],
    cover_letter_generated: ['tone'],
    cover_letter_failed: ['error_type'],
    cover_letter_downloaded: ['format'],
    ats_analysis_started: ['analysis_type'],
    ats_analysis_completed: ['analysis_type', 'score_bucket'],
    ats_analysis_failed: ['analysis_type'],
    guide_viewed: ['guide_slug', 'category'],
    template_viewed: ['template_name'],
    internal_cta_clicked: ['cta_name', 'destination'],
    export_failed: ['error_type', 'feature'],
    builder_validation_failed: ['error_type', 'feature'],
    api_request_failed: ['error_type', 'feature']
  };
  const ALLOWED_VALUES = {
    source: ['homepage', 'builder', 'template', 'unknown'],
    format: ['pdf', 'docx'],
    template_type: ['professional', 'modern', 'minimal', 'executive'],
    input_type: ['docx'],
    ai_mode: ['enabled', 'disabled'],
    error_type: ['validation_error', 'network_error', 'server_error', 'timeout', 'unsupported_file', 'unknown'],
    feature: ['builder_analysis', 'builder_export', 'resume_tailor', 'cover_letter'],
    tone: ['professional', 'warm', 'direct'],
    destination: ['resume_builder', 'resume_templates', 'resume_tailor'],
    analysis_type: ['keyword_match', 'completeness', 'readiness'],
    score_bucket: ['0_25', '26_50', '51_75', '76_100']
  };
  const onceKeys = new Set();
  const SAFE_IDENTIFIER = /^[a-z0-9_-]{1,100}$/;

  function sanitise(eventName, params) {
    const allowed = EVENT_PARAMS[eventName];
    if (!allowed) return null;
    return allowed.reduce((safe, key) => {
      const value = params && params[key];
      if (typeof value !== 'string') return safe;
      if (ALLOWED_VALUES[key] ? ALLOWED_VALUES[key].includes(value) : SAFE_IDENTIFIER.test(value)) safe[key] = value;
      return safe;
    }, {});
  }

  function track(eventName, params = {}) {
    const safeParams = sanitise(eventName, params);
    if (!safeParams || typeof window.gtag !== 'function') return;
    try { window.gtag('event', eventName, safeParams); } catch (_) { /* Analytics must never affect the product. */ }
  }

  function trackOnce(key, eventName, params = {}) {
    if (onceKeys.has(key)) return;
    onceKeys.add(key);
    track(eventName, params);
  }

  function requestErrorType(response, fallback = 'network_error') {
    if (!response) return fallback;
    if (response.status === 408 || response.status === 504) return 'timeout';
    if (response.status >= 500) return 'server_error';
    if (response.status >= 400) return 'validation_error';
    return 'unknown';
  }

  window.atsAnalytics = { track, trackOnce, requestErrorType };

  document.addEventListener('DOMContentLoaded', () => {
    const body = document.body;
    if (body.dataset.analyticsGuideSlug && body.dataset.analyticsCategory) {
      trackOnce('guide_viewed', 'guide_viewed', {
        guide_slug: body.dataset.analyticsGuideSlug,
        category: body.dataset.analyticsCategory
      });
    }
    document.querySelectorAll('[data-analytics-cta]').forEach(link => {
      link.addEventListener('click', () => {
        track('internal_cta_clicked', {
          cta_name: link.dataset.analyticsCta,
          destination: link.dataset.analyticsDestination
        });
      }, { once: true });
    });
  });
})();
