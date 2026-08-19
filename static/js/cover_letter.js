(() => {
  'use strict';
  const form = document.querySelector('#cover-letter-form');
  const preview = document.querySelector('#cover-letter-preview');
  const error = document.querySelector('#cover-error');
  const status = document.querySelector('#resume-status');
  const downloads = document.querySelector('.cover-downloads');
  let resume;
  let letter;

  function escapeHtml(value = '') {
    const element = document.createElement('div');
    element.textContent = value;
    return element.innerHTML;
  }
  function readResume() {
    try { return JSON.parse(localStorage.getItem('clearcv-cover-letter-resume') || localStorage.getItem('clearcv-draft') || 'null'); } catch (_) { return null; }
  }
  function hasResume(data) {
    const basics = data?.basics || {};
    return Boolean(basics.name && (basics.summary || data.skills?.length || data.experience?.length));
  }
  function renderLetter(value) {
    const basics = resume.basics || {};
    preview.innerHTML = `<header><h2>${escapeHtml(basics.name || 'YOUR NAME')}</h2><p>${escapeHtml([basics.location, basics.phone, basics.email, basics.linkedin].filter(Boolean).join(' | '))}</p></header><div class="cover-letter-body"><p>${escapeHtml(form.elements.company.value.trim())}</p><p contenteditable="true" data-field="greeting">${escapeHtml(value.greeting)}</p>${value.paragraphs.map((paragraph, index) => `<p contenteditable="true" data-paragraph="${index}">${escapeHtml(paragraph)}</p>`).join('')}<p contenteditable="true" data-field="closing">${escapeHtml(value.closing)}</p><p>${escapeHtml(basics.name || '')}</p></div>`;
    downloads.hidden = false;
  }
  function syncEdits() {
    if (!letter) return;
    preview.querySelectorAll('[data-paragraph]').forEach(item => { letter.paragraphs[Number(item.dataset.paragraph)] = item.textContent.trim(); });
    ['greeting', 'closing'].forEach(key => { const item = preview.querySelector(`[data-field="${key}"]`); if (item) letter[key] = item.textContent.trim(); });
  }
  resume = readResume();
  if (hasResume(resume)) {
    status.textContent = `Using saved resume for ${resume.basics.name}.`;
    status.classList.add('ready');
  } else {
    status.textContent = 'No usable saved resume found. Build your resume first, then return here.';
    form.querySelector('button[type="submit"]').disabled = true;
  }
  form.addEventListener('submit', async event => {
    event.preventDefault();
    error.hidden = true;
    const button = document.querySelector('#generate-cover-letter');
    button.disabled = true;
    button.textContent = 'Generating…';
    try {
      const response = await fetch('/api/generate-cover-letter', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({
        resume, company: form.elements.company.value, recipient: form.elements.recipient.value,
        job_description: form.elements.job_description.value, motivation: form.elements.motivation.value,
        tone: form.elements.tone.value
      })});
      const result = await response.json();
      if (!response.ok) throw new Error(result.error || 'The cover letter could not be generated.');
      letter = result.letter;
      renderLetter(letter);
      window.atsAnalytics?.track('cover_letter_generated', {tone: form.elements.tone.value});
    } catch (problem) {
      error.textContent = problem.message || 'The cover letter could not be generated. Please try again.';
      error.hidden = false;
      window.atsAnalytics?.track('cover_letter_failed', {error_type: 'server_error'});
    } finally {
      button.disabled = false;
      button.textContent = 'Generate cover letter →';
    }
  });
  downloads.querySelectorAll('button').forEach(button => button.addEventListener('click', async () => {
    syncEdits();
    const format = button.dataset.download;
    const original = button.textContent;
    button.disabled = true; button.textContent = 'Preparing…';
    try {
      const response = await fetch(`/api/download/cover-letter/${format}`, { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({resume, company: form.elements.company.value, recipient: form.elements.recipient.value, letter}) });
      if (!response.ok) throw new Error('The document could not be created.');
      const blob = await response.blob(); const url = URL.createObjectURL(blob); const link = document.createElement('a');
      link.href = url; link.download = `Cover_Letter.${format}`; link.click(); URL.revokeObjectURL(url);
      window.atsAnalytics?.track('cover_letter_downloaded', {format});
    } catch (problem) { error.textContent = problem.message; error.hidden = false; } finally { button.disabled = false; button.textContent = original; }
  }));
})();
