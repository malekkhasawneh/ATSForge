# Google Play — ATSForge

## Main store listing (English / United States)

**App name** — `ATSForge`

**Short description** (78/80 characters) —

```text
Build, check, tailor, and export ATS-friendly resumes from your phone.
```

**Full description** —

```text
ATSForge helps you create a clear, professional résumé that is easy to review and ready to export.

Build your résumé step by step. Add your profile, experience, education, projects, skills, and languages, then choose an ATS-friendly template and preview the result as you work.

Use the built-in readiness check to spot missing core details, such as contact information, experience, skills, and measurable results. The check is a practical writing aid, not an employer’s ATS score and not a guarantee of an interview.

Already have a résumé? Upload a DOCX file and add a target job description. ATSForge compares relevant role language and prepares a tailored, ATS-readable DOCX while keeping the focus on evidence from your original résumé.

Export your completed résumé as an editable Word document or a text-based PDF. Review every export before applying and make sure the content is accurate and truthful.

Privacy matters. Drafts are stored on your device. Resume information is sent to ATSForge only when you request analysis, export, or document tailoring. Uploaded and generated files are processed to provide the requested feature and are not intentionally kept as a résumé database. See the privacy policy for full details.

ATSForge does not promise job interviews, employment outcomes, or compatibility with every employer’s private screening system.
```

**App category** — `Business`

**Suggested tags** — `resume`, `job search`, `career`, `productivity`

**Developer contact email** — `support@atsforge.org` — confirm this mailbox is monitored.

**Website** — `https://atsforge.org`

**Privacy policy** — `https://atsforge.org/resources/privacy-policy`

## App content declarations

Use these as the starting point in Play Console. The final answers must match
the released app, your production server, and any third-party AI provider.

| Play Console item | Recommended answer |
| --- | --- |
| App or game | App |
| Category | Business |
| Ads | No — only if the shipped app and backend contain no ads/AdMob/ad SDKs |
| Target audience | Ages 18 and over; the app is intended for job seekers, not children |
| Content rating | Complete the questionnaire truthfully; expected result: no objectionable content |
| App access | All core features are accessible without an account or login |
| Data deletion | No account exists. Users can clear the local draft in the app. Support-record deletion requests: `support@atsforge.org` |

## Data safety — draft answers

Choose **Yes, data is collected**. The app transmits user-provided résumé and
job-description information to the ATSForge server when a user asks for
analysis, export, or tailoring.

| Data type in Play Console | Collected | Shared | Purpose | Required? | Ephemeral? |
| --- | --- | --- | --- | --- | --- |
| Personal info: name | Yes | No* | App functionality | User chooses to provide it | Yes, for the request |
| Personal info: email address, phone number, address/location | Yes | No* | App functionality | User chooses to provide it | Yes, for the request |
| Personal info: other user-provided personal information | Yes | No* | App functionality | User chooses to provide it | Yes, for the request |
| User content: files and docs (uploaded résumé / job-description DOCX) | Yes | No* | App functionality | User chooses to provide it | Yes, for the request |
| User content: other user-generated content (résumé fields / pasted job description) | Yes | No* | App functionality | User chooses to provide it | Yes, for the request |

`*` Select **Shared** only if a third party receives the data. If production AI
tailoring sends extracted résumé/job-description text to Hugging Face, declare
the applicable data types as **shared with a service provider for app
functionality** and complete the provider/retention answers exactly as the
provider’s current terms require. Do not mark data as encrypted in transit
unless every production API and provider connection uses HTTPS/TLS.

Do not declare analytics, advertising IDs, purchase data, location, contacts,
photos, videos, audio, or tracking. The Android release manifest explicitly
removes photo/video and storage-library permissions because ATSForge uses the
system document picker for DOCX files.

## Graphics needed

- App icon: 512 × 512 px, 32-bit PNG with alpha, maximum 1 MB.
- Feature graphic: 1024 × 500 px, PNG or JPEG. Suggested headline:
  `Build a clearer résumé.`
- At least two phone screenshots; use real app screens. Suggested sequence:
  1. Home screen with “Build a focused résumé”.
  2. Resume builder with form and live preview.
  3. Template picker.
  4. Tailor screen with DOCX and job-description inputs.
  5. Export-ready résumé preview.

Avoid price, discount, ranking, “best”, “#1”, or interview-guarantee claims in
screenshots, graphics, title, or description.

## Submission notes

- Upload a signed Android App Bundle (`.aab`), not only an APK.
- Upload a newly built bundle after the manifest change; Play Console evaluates
  permissions from the uploaded bundle, not this source code.
- The Android package name is `org.atsforge.app`; confirm it is registered to
  your verified Play Console developer account.
- Complete policy declarations, privacy policy, Data safety, content rating,
  and testing before production rollout.
