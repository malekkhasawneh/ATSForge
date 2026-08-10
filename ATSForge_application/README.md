# ATSForge mobile application

Native Flutter client for the ATSForge Flask service. The project uses clean,
feature-based layers, Cubit state management, and a GetIt injection container.
No application feature calls `setState`.

## Structure

```text
lib/
  app/                  App routing and composition
  core/                 Design system, helpers, resources, networking, storage
  features/
    connectivity/       Network and server reachability
    home/               Branded landing experience
    templates/          ATS-safe template selection
    resume_builder/     Local drafts, analysis, preview, and export
    tailor/             DOCX upload and tailoring workflow
  injection_container.dart
```

Each business feature is separated into `data`, `domain`, and `presentation`
layers where applicable. Presentation components are split into `widgets/`.

## Run

The production API defaults to `https://atsforge.org`:

```bash
flutter pub get
flutter run
```

To use the Flask service running on another host, provide the URL at build time:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

Use `10.0.2.2` for an Android emulator, the Mac host address for a physical
device, and `http://127.0.0.1:5000` for an iOS simulator. Plain HTTP is intended
only for local development; production must use HTTPS.

## Verification

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk
flutter build ios
```

Resume drafts are stored locally with SharedPreferences. Generated files are
written to the application temporary directory and can be opened or shared by
the user. The Hugging Face token remains exclusively in the Flask environment.
