# Apple App Store — ATSForge

## App Store Connect — App Information

**Name** (8/30 characters) — `ATSForge`

**Subtitle** (28/30 characters) — `Build resumes with clarity`

**Bundle ID** — `[CONFIRM: unique registered iOS bundle ID, e.g. org.atsforge.app]`

**SKU** — `atsforge-ios-001`

**Primary category** — `Business`

**Secondary category** — `Productivity` (optional)

**Privacy Policy URL** — `https://atsforge.org/resources/privacy-policy`

**Support URL** — `https://atsforge.org/resources/contact`

**Marketing URL** (optional) — `https://atsforge.org`

## Version Information (English U.S.)

**Promotional text** (optional; up to 170 characters) —

```text
Build a focused résumé, check its readiness, tailor it honestly to a role, and export a professional DOCX or PDF.
```

**Description** —

```text
Build a clear, professional résumé with ATSForge.

Create your résumé step by step with profile details, experience, education, projects, skills, and languages. Choose an ATS-friendly template and use the live preview to keep the final document focused and readable.

ATSForge includes a practical readiness check to help you identify missing details and strengthen your content. It is not an employer ATS score and does not guarantee an interview or employment outcome.

For an existing résumé, upload a DOCX file and add a target job description. ATSForge compares relevant role language and prepares an ATS-readable tailored DOCX using evidence from your original résumé.

Export your finished résumé as an editable Word document or a text-based PDF. Always review the final document before applying and keep all information accurate and truthful.

Privacy-minded by design: drafts are stored on your device. Data is sent to ATSForge only when you ask for analysis, export, or tailoring. See our Privacy Policy for details.
```

**Keywords** (96/100 characters; no spaces after commas) —

```text
resume,CV,job search,career,job application,cover letter,ATS,resume builder,Word,PDF
```

**What’s New — Version 1.0.0** —

```text
Welcome to ATSForge.

Build, review, tailor, and export professional ATS-friendly resumes from your iPhone or iPad.
```

## App Review Information

**Sign-in required?** — No. The app has no account or login flow.

**Demo account** — Not required.

**Review notes** —

```text
ATSForge is a resume builder and document-tailoring app. No account, payment, or login is required.

Review path:
1. Open ATSForge and select “Build my résumé” to create a resume, preview it, run the readiness check, and export a DOCX or PDF.
2. Select “Tailor” to choose a DOCX resume from the Files app, enter a job description, and request an ATS-readable tailored DOCX.

The app uses the production API at https://atsforge.org. Users may enter personal and employment information because that is necessary to create a resume. Drafts are stored locally on the device. Information is transmitted only when a user requests analysis, export, or tailoring.
```

**Contact name / phone / email** — `[CONFIRM: a real reviewer contact who can reply during review]`

## App Privacy — draft answers

Apple requires an accurate disclosure of all data collected by the app and by
third-party services in the released app. Start with the following, then
confirm against the production backend and any AI provider.

| Apple data type | Collected? | Linked to identity? | Used for tracking? | Purpose |
| --- | --- | --- | --- | --- |
| Contact Info: Name | Yes | No — processed per request, not kept as an account record | No | App functionality |
| Contact Info: Email Address, Phone Number, Physical Address | Yes, if entered in the résumé | No | No | App functionality |
| User Content: Other User Content | Yes — résumé fields and pasted job description | No | No | App functionality |
| User Content: Photos or Videos | No | — | — | — |
| User Content: Other User Content / Documents | Yes — uploaded résumé or job-description DOCX | No | No | App functionality |
| Identifiers, Usage Data, Diagnostics, Financial Info, Location, Contacts | No, based on the current app dependencies | — | — | — |

If Hugging Face AI mode is enabled in production, include that provider’s data
handling in these answers. Apple treats information sent off-device to provide
the service as collected even if it is not retained. Do not claim that data is
“not linked” or “not retained” unless that remains true for server logs,
support tooling, crash reporting, and the AI provider.

## Screenshots and assets

- Provide real screenshots for every required iPhone/iPad display size shown by
  App Store Connect for the devices you support.
- Suggested screenshot captions:
  1. `Build your résumé step by step`
  2. `See a clear live preview`
  3. `Choose an ATS-friendly template`
  4. `Tailor your résumé to a role`
  5. `Export to Word or PDF`
- App icon: submit the required 1024 × 1024 px App Store icon through Xcode or
  the asset catalog; it must not contain transparency.

## Release blockers to resolve before submission

1. Remove the unused `NSPhotoLibraryUsageDescription` entry from
   `ios/Runner/Info.plist`, unless you add a real photo-library feature.
   ATSForge’s current file picker selects DOCX documents via Files, not photos.
2. Confirm `org.atsforge.app` is also a unique iOS bundle ID. Android’s
   application ID does not automatically create an Apple bundle ID.
3. Confirm the privacy-policy and contact URLs render successfully on a mobile
   connection and that `support@atsforge.org` is monitored.
