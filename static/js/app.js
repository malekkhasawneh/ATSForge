const $ = (s, root = document) => root.querySelector(s);
const $$ = (s, root = document) => [...root.querySelectorAll(s)];
const steps = ['basics', 'experience', 'education', 'skills', 'target'];
let current = 0;
let timer;
let analysisRequest = 0;

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
    preview.innerHTML = '<div class="empty-preview"><span class="empty-preview-icon">✦</span><b>Your CV preview will appear here</b><span>Start with your name and professional summary. It updates as you type.</span><div class="empty-preview-lines" aria-hidden="true"><i></i><i></i><i></i></div></div>'; return;
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
  try {
    const response = await fetch('/api/analyze', {method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(data)});
    const {analysis} = await response.json();
    if (requestId !== analysisRequest) return;
    $('#score').textContent = analysis.score;
    $('#score-ring').style.borderTopColor = analysis.score >= 75 ? '#235f47' : analysis.score >= 50 ? '#c58b31' : '#a9584b';
    const passed = Object.values(analysis.checks).filter(Boolean).length;
    $('#score-message').textContent = `${passed} of ${Object.keys(analysis.checks).length} quality checks passed. Add clear, truthful evidence before exporting.`;
  } catch (_) { /* Preview remains useful if server analysis is unavailable. */ }
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
  $('.back').style.visibility = current ? 'visible' : 'hidden';
  $('.next').textContent = current === steps.length - 1 ? 'Review résumé →' : 'Continue →';
}

document.addEventListener('input', e => { if (e.target.matches('input,textarea')) changed(); });
$$('[data-add]').forEach(btn => btn.addEventListener('click', () => { addItem(btn.dataset.add); changed(); }));
$$('.step').forEach((btn,i) => btn.addEventListener('click', () => showStep(i)));
$('.next').addEventListener('click', () => current < steps.length - 1 ? showStep(current + 1) : $('#resume-preview').scrollIntoView({behavior:'smooth'}));
$('.back').addEventListener('click', () => showStep(current - 1));
$$('[data-scroll]').forEach(btn => btn.addEventListener('click', () => $(`#${btn.dataset.scroll}`).scrollIntoView({behavior:'smooth'})));
async function downloadResume(type) {
  const btn = $(`#download-${type}`); const original = btn.textContent;
  btn.textContent = 'Preparing…'; btn.disabled = true;
  try {
    const response = await fetch(`/api/download/${type}`, {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(collect())});
    if (!response.ok) throw new Error('Export failed');
    const blob = await response.blob(); const url=URL.createObjectURL(blob); const a=document.createElement('a');
    a.href=url; a.download=`ATS_Resume.${type}`; a.click(); URL.revokeObjectURL(url);
  } catch (_) { alert('The document could not be created. Please try again.'); }
  finally { btn.textContent = original; btn.disabled = false; }
}
$('#download-docx').addEventListener('click', () => downloadResume('docx'));
$('#download-pdf').addEventListener('click', () => downloadResume('pdf'));

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
