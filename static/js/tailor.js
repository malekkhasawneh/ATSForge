(() => {
  const form = document.querySelector('#tailor-form');
  const input = document.querySelector('#resume-file');
  const drop = document.querySelector('#file-drop');
  const label = document.querySelector('#file-label');
  const progress = document.querySelector('#tailor-progress');
  const result = document.querySelector('#tailor-result');
  const error = document.querySelector('#tailor-error');
  let downloadUrl = null;
  let isSubmitting = false;

  function track(eventName, params) { window.atsAnalytics?.track(eventName, params); }
  function requestParams() { return {input_type: 'docx', ai_mode: form.dataset.aiMode}; }

  function showFile(file) {
    if (!file) return;
    label.textContent = file.name;
    drop.classList.add('has-file');
  }
  input.addEventListener('change', () => showFile(input.files[0]));
  document.querySelector('#job-file').addEventListener('change', event => {
    document.querySelector('#job-file-label').textContent = event.target.files[0]?.name || 'Optional';
  });
  ['dragenter','dragover'].forEach(name => drop.addEventListener(name, e => { e.preventDefault(); drop.classList.add('dragging'); }));
  ['dragleave','drop'].forEach(name => drop.addEventListener(name, e => { e.preventDefault(); drop.classList.remove('dragging'); }));
  drop.addEventListener('drop', e => {
    const file = e.dataTransfer.files[0];
    if (file) { const transfer = new DataTransfer(); transfer.items.add(file); input.files = transfer.files; showFile(file); }
  });

  form.addEventListener('submit', async e => {
    e.preventDefault(); error.hidden = true;
    if (isSubmitting) return;
    if (!input.files[0] || !input.files[0].name.toLowerCase().endsWith('.docx')) {
      track('resume_tailor_failed', {error_type: 'unsupported_file'});
    }
    if (!input.files[0] || !input.files[0].name.toLowerCase().endsWith('.docx')) {
      error.textContent = 'Please choose a valid .docx Word résumé.'; error.hidden = false; return;
    }
    isSubmitting = true;
    track('resume_tailor_started', requestParams());
    form.hidden = true; result.hidden = true; progress.hidden = false;
    try {
      const response = await fetch('/api/tailor-resume', {method:'POST', body:new FormData(form)});
      if (!response.ok) {
        let message = 'The résumé could not be tailored.';
        try { message = (await response.json()).error || message; } catch (_) {}
        throw {response, message};
      }
      const blob = await response.blob();
      if (downloadUrl) URL.revokeObjectURL(downloadUrl);
      downloadUrl = URL.createObjectURL(blob);
      const mode = response.headers.get('X-Tailor-Mode');
      document.querySelector('#before-score').textContent = (response.headers.get('X-Job-Match-Before') || response.headers.get('X-ATS-Score-Before') || '0') + '%';
      document.querySelector('#after-score').textContent = (response.headers.get('X-Job-Match-After') || response.headers.get('X-ATS-Score-After') || '0') + '%';
      document.querySelector('#matched-words').textContent = response.headers.get('X-Matched-Keywords') || 'No strong matches found yet.';
      document.querySelector('#missing-words').textContent = response.headers.get('X-Missing-Keywords') || 'No major keyword gaps detected.';
      document.querySelector('#result-mode').textContent = mode === 'ai' ? 'AI tailored the wording and hierarchy using source-supported evidence only.' : 'Your original wording was preserved and reorganized into an ATS-readable format.';
      progress.hidden = true; result.hidden = false;
      track('resume_tailor_completed', requestParams());
    } catch (problem) {
      const errorType = window.atsAnalytics?.requestErrorType(problem.response) || 'network_error';
      track('resume_tailor_failed', {error_type: errorType});
      track('api_request_failed', {error_type: errorType, feature: 'resume_tailor'});
      progress.hidden = true; form.hidden = false; error.textContent = problem.message || 'The document could not be tailored.'; error.hidden = false;
    } finally {
      isSubmitting = false;
    }
  });
  document.querySelector('#result-download').addEventListener('click', () => {
    if (!downloadUrl) return; const a = document.createElement('a'); a.href = downloadUrl;
    const original = input.files[0]?.name.replace(/\.docx$/i,'') || 'Resume'; a.download = `${original}_Tailored_ATS.docx`; a.click();
    track('tailored_resume_downloaded', {format: 'docx'});
  });
  document.querySelector('#tailor-another').addEventListener('click', () => {
    result.hidden = true; form.hidden = false; form.reset(); label.textContent = 'Choose your Word résumé'; drop.classList.remove('has-file');
  });
})();
