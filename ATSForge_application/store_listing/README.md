# ATSForge Store Publishing Pack

These files contain copy-ready English metadata for the Google Play Store and
Apple App Store. Copy the text exactly, then replace every value marked
`[CONFIRM ...]` before submitting.

## Files

- `GOOGLE_PLAY.md` — store listing copy, required console declarations, and
  graphics checklist.
- `APPLE_APP_STORE.md` — App Store Connect copy, privacy answers, review notes,
  and screenshot checklist.

## Important release checks

1. Confirm that `https://atsforge.org/resources/privacy-policy` is live,
   publicly accessible, and updated to say **ATSForge** consistently. The
   current website source still contains several references to “ClearCV”.
2. This app handles highly sensitive résumé and job-description content. Its
   Google Data safety and Apple App Privacy answers must match the final server
   and any enabled Hugging Face AI processing.
3. Before iOS submission, remove `NSPhotoLibraryUsageDescription` from
   `ios/Runner/Info.plist` unless the released app genuinely accesses the photo
   library. ATSForge uses a document picker for DOCX files, so the permission is
   not needed by the current feature set.
4. Test the released build with the production API (`https://atsforge.org`) and
   capture real screenshots from that build. Do not use mockups or marketing
   claims that the app cannot demonstrate.

Store requirements and limits change. Check the official console validation
messages before submitting: Google requires a title of up to 30 characters, a
short description of up to 80 characters, and a full description of up to
4,000 characters. Apple allows 30 characters each for the app name and
subtitle.
