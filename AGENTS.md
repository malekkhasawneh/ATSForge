# Repository Guidelines

## Project Structure & Module Organization

ClearCV is a Flask application for creating and tailoring ATS-friendly resumes.

- `app.py` contains Flask routes, input validation, ATS analysis, and DOCX/PDF export.
- `resume_tailor.py` handles uploaded DOCX extraction, matching, and optional AI tailoring.
- `content_pages.py` defines the SEO/content-page data used by the app.
- `templates/` contains Jinja pages; shared fragments live in `templates/partials/`.
- `static/css/`, `static/js/`, and `static/img/` hold browser-facing assets. Keep each feature's CSS and JavaScript in the corresponding existing file where practical.
- `.env.example` documents optional environment configuration. Do not commit real credentials.

## Build, Test, and Development Commands

Create an isolated environment and install the pinned dependencies:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
python app.py
```

Open `http://127.0.0.1:5000` to exercise the builder. Before submitting Python changes, run `python -m compileall app.py resume_tailor.py content_pages.py` to catch syntax errors. There is currently no automated test suite; manually verify affected routes, resume previews, and DOCX/PDF downloads.

## Coding Style & Naming Conventions

Use Python 3 type hints where they clarify data shapes, four-space indentation, `snake_case` for functions and variables, and `UPPER_SNAKE_CASE` for module constants. Keep validation and size limits server-side. Follow the existing import grouping and avoid unrelated refactors.

Use semantic HTML and existing Jinja conventions in templates. Use two-space indentation in HTML, CSS, and JavaScript. Name CSS classes descriptively (for example, `.resume-preview`) and keep client-side behavior in `static/js/` rather than inline scripts.

## Security & Configuration

Optional Hugging Face settings (`HF_TOKEN`, `HF_MODEL`) are read from environment variables. Never expose tokens in templates, static JavaScript, screenshots, logs, or commits. Treat uploaded resumes and job descriptions as sensitive user content.

## Commit & Pull Request Guidelines

Git history is not available in this checkout, so use short imperative commit subjects such as `Add resume export validation`. Keep commits focused. Pull requests should describe user-visible behavior, note any configuration changes, link relevant issues, and include screenshots for UI/template changes. State how export and affected flows were manually verified.
