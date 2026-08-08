# ATSForge

A polished Python/Flask résumé builder focused on ATS-safe structure, honest job tailoring, and editable Word export.

## Run locally

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python app.py
```

Open <http://127.0.0.1:5000>.

Choose a design at <http://127.0.0.1:5000/resume-templates>, then add information in the builder.

## What it includes

- Five-step responsive résumé builder
- Live single-column preview
- Local browser draft saving (no database)
- Job-description keyword comparison
- Quality checks for contact details, summary, skills, experience, and measurable impact
- Matching ATS-friendly `.docx` and text-based `.pdf` exports using ordinary headings and plain bullets
- User-specific content only: the app never inserts invented employment claims or generic generated paragraphs
- DOCX resume tailoring against a pasted job description, with optional evidence-constrained Hugging Face rewriting
- Professional, Modern, Minimal, and Executive templates applied consistently to preview, DOCX, and PDF

## Enable AI resume tailoring

The upload workflow works without an API token in ATS formatting mode. To enable content tailoring with a hosted open model, create a Hugging Face user access token with inference permission and start the app with:

```bash
export HF_TOKEN="hf_your_token"
export HF_MODEL="Qwen/Qwen2.5-7B-Instruct-1M"  # optional override
python app.py
```

The token is read only on the server and must never be placed in browser JavaScript or committed to source control. Provider routing and billing depend on the Hugging Face account. The application sends extracted resume text and the job description to the configured provider only in AI mode.

## Production SEO configuration

Set these Railway environment variables after connecting the custom domain:

```bash
SITE_URL="https://atsforge.org"
GOOGLE_SITE_VERIFICATION="Google Search Console verification token"
SUPPORT_EMAIL="support@atsforge.org"
LEGAL_ENTITY_NAME="Your real person or registered business name"
LEGAL_ADDRESS="Your registered business address, if applicable"
```

`SITE_URL` is the single public origin used by canonical tags, Open Graph URLs, JSON-LD, `sitemap.xml`, and `robots.txt`. Do not include a trailing slash. `SUPPORT_EMAIL` must be a monitored mailbox. Set `LEGAL_ENTITY_NAME` to the real person or business operating the site; never leave a placeholder on the live legal pages. Leave `GOOGLE_SITE_VERIFICATION` empty until Search Console provides a token; no tag is rendered when it is absent. The application does not load advertising code.

## Design and research basis

The implementation follows guidance from the USC Career Center, CareerOneStop, UCLA Career Center, and patterns found in open-source Hugging Face résumé-tailoring Spaces. The product deliberately avoids columns, tables, graphics, photos, and keyword stuffing. Its score is a transparent readiness indicator—not a claim to reproduce any employer's private ATS.

## Structure

```text
app.py                 Flask API, ATS analysis, DOCX generator
templates/index.html   Builder interface
static/css/style.css   Responsive visual system
static/js/app.js       Live preview, local drafts, interactions
```
