const $ = (s, root = document) => root.querySelector(s);
const $$ = (s, root = document) => [...root.querySelectorAll(s)];
const steps = ['basics', 'experience', 'education', 'skills', 'target'];
let current = 0;
let timer;
let analysisRequest = 0;
let builderStarted = false;
let analysisStarted = false;

function track(eventName, params) { window.atsAnalytics?.track(eventName, params); }
function trackOnce(key, eventName, params) { window.atsAnalytics?.trackOnce(key, eventName, params); }
function templateType() { return $('[name="template"]')?.value || 'professional'; }
function builderSource() { return new URLSearchParams(location.search).get('template') ? 'template' : 'homepage'; }
function hasMeaningfulContent(data) {
  const b = data.basics;
  return Boolean(b.name || b.title || b.summary || data.skills.length || data.languages.length ||
    ['experience', 'education', 'projects'].some(type => data[type].some(item => Object.values(item).some(Boolean))));
}
function scoreBucket(score) {
  if (score <= 25) return '0_25';
  if (score <= 50) return '26_50';
  if (score <= 75) return '51_75';
  return '76_100';
}

function esc(value = '') {
  const div = document.createElement('div'); div.textContent = value; return div.innerHTML;
}

function addItem(type, values = {}) {
  const fragment = $(`#${type}-template`).content.cloneNode(true);
  const card = $('.repeat-card', fragment);
  $$('[data-field]', card).forEach(input => input.value = values[input.dataset.field] || '');
  $('.remove', card).addEventListener('click', () => { card.remove(); changed(); });
  $(`#${type}-list`).append(fragment);
}

function collect() {
  const form = $('#resume-form');
  const val = name => form.elements[name]?.value.trim() || '';
  const repeated = type => $$(`#${type}-list .repeat-card`).map(card => Object.fromEntries(
    $$('[data-field]', card).map(input => [input.dataset.field, input.value.trim()])
  ));
  return {
    template: val('template') || 'professional',
    basics: {name: val('name'), title: val('title'), email: val('email'), phone: val('phone'), location: val('location'), linkedin: val('linkedin'), summary: val('summary')},
    experience: repeated('experience'), education: repeated('education'), projects: repeated('projects'),
    skills: val('skills').split(',').map(x => x.trim()).filter(Boolean),
    languages: val('languages').split(',').map(x => x.trim()).filter(Boolean)
  };
}

function section(title, content) { return content ? `<section><h2>${title}</h2>${content}</section>` : ''; }

function render(data) {
  const b = data.basics;
  const preview = $('#resume-preview');
  preview.className = `resume template-${data.template || 'professional'}`;
  const hasEntry = entries => entries.some(entry => Object.values(entry).some(value => String(value || '').trim()));
  const hasContent = Boolean(
    b.name || b.title || b.summary || data.skills.length || data.languages.length ||
    hasEntry(data.experience) || hasEntry(data.education) || hasEntry(data.projects)
  );
  if (!hasContent) {
    preview.innerHTML = '<div class="empty-preview"><span class="empty-preview-icon">✦</span><b>Your resume preview will appear here</b><span>Start with your name and professional summary. It updates as you type.</span><div class="empty-preview-lines" aria-hidden="true"><i></i><i></i><i></i></div></div>'; return;
  }
  const contact = [b.location, b.phone, b.email, b.linkedin].filter(Boolean).map(esc).join(' &nbsp;|&nbsp; ');
  const exp = data.experience.filter(x => Object.values(x).some(Boolean)).map(x => {
    const bullets = x.highlights.split(/\n|•/).filter(Boolean).map(v => `<li>${esc(v.trim())}</li>`).join('');
    return `<div class="entry"><div class="entry-head"><b>${esc(x.title)}${x.company ? ' | ' + esc(x.company) : ''}</b><span>${esc([x.start,x.end].filter(Boolean).join(' – '))}</span></div><p class="entry-meta">${esc(x.location)}</p>${bullets ? `<ul>${bullets}</ul>` : ''}</div>`;
  }).join('');
  const edu = data.education.map(x => `<div class="entry"><div class="entry-head"><b>${esc(x.degree)}${x.school ? ' | '+esc(x.school):''}</b><span>${esc([x.start,x.end].filter(Boolean).join(' – '))}</span></div><p>${esc([x.location,x.details].filter(Boolean).join(' | '))}</p></div>`).join('');
  const projects = data.projects.map(x => `<p><b>${esc(x.name)}</b>${x.link ? ' | '+esc(x.link):''}${x.description ? ' — '+esc(x.description):''}</p>`).join('');
  preview.innerHTML = `<header class="resume-header"><h1>${esc(b.name || 'YOUR NAME')}</h1><p><b>${esc(b.title)}</b></p><p>${contact}</p></header>${section('Professional Summary', `<p>${esc(b.summary)}</p>`)}${section('Core Skills', `<p>${data.skills.map(esc).join(' • ')}</p>`)}${section('Professional Experience', exp)}${section('Selected Projects', projects)}${section('Education', edu)}${section('Languages', `<p>${data.languages.map(esc).join(' • ')}</p>`)}`;
}

async function analyze(data) {
  const requestId = ++analysisRequest;
  if (builderStarted && !analysisStarted) {
    analysisStarted = true;
    trackOnce('ats_analysis_started', 'ats_analysis_started', {analysis_type: 'readiness'});
  }
  try {
    const response = await fetch('/api/analyze', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(data)});
    if (!response.ok) throw response;
    const {analysis} = await response.json();
    if (requestId !== analysisRequest) return;
    $('#score').textContent = analysis.score;
    $('#score-ring').style.borderTopColor = analysis.score >= 75 ? '#235f47' : analysis.score >= 50 ? '#c58b31' : '#a9584b';
    const passed = Object.values(analysis.checks).filter(Boolean).length;
    $('#score-message').textContent = `${passed} of ${Object.keys(analysis.checks).length} quality checks passed. Add clear, truthful evidence before exporting.`;
    if (builderStarted) trackOnce('ats_analysis_completed', 'ats_analysis_completed', {analysis_type: 'readiness', score_bucket: scoreBucket(analysis.score)});
  } catch (problem) {
    if (builderStarted) {
      const errorType = window.atsAnalytics?.requestErrorType(problem) || 'network_error';
      trackOnce('ats_analysis_failed', 'ats_analysis_failed', {analysis_type: 'readiness'});
      trackOnce('api_request_failed_builder_analysis', 'api_request_failed', {error_type: errorType, feature: 'builder_analysis'});
    }
    /* Preview remains useful if server analysis is unavailable. */
  }
}

function changed() {
  const data = collect(); render(data); localStorage.setItem('clearcv-draft', JSON.stringify(data));
  clearTimeout(timer); timer = setTimeout(() => analyze(data), 450);
}

function showStep(index) {
  current = Math.max(0, Math.min(steps.length - 1, index));
  $$('.step').forEach((el,i) => el.classList.toggle('active', i === current));
  $$('.panel').forEach(el => el.classList.toggle('active', el.dataset.panel === steps[current]));
  $('#step-count').textContent = `${current + 1} / ${steps.length}`;
  if (current === steps.length - 1 && builderStarted) {
    trackOnce('cv_builder_completed', 'cv_builder_completed');
    trackOnce('cv_preview_viewed', 'cv_preview_viewed', {template_type: templateType()});
  }
  $('.back').style.visibility = current ? 'visible' : 'hidden';
  $('.next').textContent = current === steps.length - 1 ? 'Review résumé →' : 'Continue →';
}

document.addEventListener('input', e => {
  if (!e.target.matches('input,textarea')) return;
  if (!builderStarted && e.target.value.trim()) {
    builderStarted = true;
    trackOnce('cv_builder_started', 'cv_builder_started', {source: builderSource()});
  }
  changed();
});
$$('[data-add]').forEach(btn => btn.addEventListener('click', () => { addItem(btn.dataset.add); changed(); }));
$$('.step').forEach((btn,i) => btn.addEventListener('click', () => showStep(i)));
$('.next').addEventListener('click', () => {
  if (current < steps.length - 1) {
    showStep(current + 1);
    return;
  }
  if (builderStarted && hasMeaningfulContent(collect())) {
    trackOnce('cv_preview_viewed', 'cv_preview_viewed', {template_type: templateType()});
  }
  $('#resume-preview').scrollIntoView({behavior:'smooth'});
});
$('.back').addEventListener('click', () => showStep(current - 1));
$$('[data-scroll]').forEach(btn => btn.addEventListener('click', () => $(`#${btn.dataset.scroll}`).scrollIntoView({behavior:'smooth'})));
async function downloadResume(type) {
  const btn = $(`#download-${type}`); const original = btn.textContent;
  btn.textContent = 'Preparing…'; btn.disabled = true;
  try {
    const response = await fetch(`/api/download/${type}`, {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(collect())});
    if (!response.ok) throw response;
    const blob = await response.blob(); const url=URL.createObjectURL(blob); const a=document.createElement('a');
    track('cv_generated', {format: type, template_type: templateType()});
    a.href=url; a.download=`ATS_Resume.${type}`; a.click();
    track('cv_downloaded', {format: type, template_type: templateType()});
    URL.revokeObjectURL(url);
  } catch (problem) {
    const errorType = window.atsAnalytics?.requestErrorType(problem) || 'network_error';
    track('export_failed', {error_type: errorType, feature: 'builder_export'});
    track('api_request_failed', {error_type: errorType, feature: 'builder_export'});
    if (errorType === 'validation_error') track('builder_validation_failed', {error_type: errorType, feature: 'builder_export'});
    alert('The document could not be created. Please try again.');
  }
  finally { btn.textContent = original; btn.disabled = false; }
}
$('#download-docx').addEventListener('click', () => downloadResume('docx'));
$('#download-pdf').addEventListener('click', () => downloadResume('pdf'));
$('#create-cover-letter').addEventListener('click', () => {
  localStorage.setItem('clearcv-cover-letter-resume', JSON.stringify(collect()));
});

function restore() {
  let draft; try { draft = JSON.parse(localStorage.getItem('clearcv-draft')); } catch (_) {}
  const requestedTemplate = new URLSearchParams(location.search).get('template');
  const validTemplates = ['professional','modern','minimal','executive'];
  if (!draft) { addItem('experience'); addItem('education'); $('[name="template"]').value = validTemplates.includes(requestedTemplate) ? requestedTemplate : 'professional'; updateTemplateLabel(); return changed(); }
  Object.entries(draft.basics || {}).forEach(([key,value]) => { const el=$(`[name="${key}"]`); if(el) el.value=value; });
  $('[name="skills"]').value=(draft.skills||[]).join(', '); $('[name="languages"]').value=(draft.languages||[]).join(', ');
  $('[name="template"]').value = validTemplates.includes(requestedTemplate) ? requestedTemplate : (validTemplates.includes(draft.template) ? draft.template : 'professional'); updateTemplateLabel();
  ['experience','education','projects'].forEach(type => (draft[type] || []).forEach(item => addItem(type,item)));
  if (!draft.experience?.length) addItem('experience'); if (!draft.education?.length) addItem('education'); changed();
}
function updateTemplateLabel() { const value = $('[name="template"]').value; $('#active-template-name').textContent = value.charAt(0).toUpperCase()+value.slice(1); }
restore(); showStep(0);
