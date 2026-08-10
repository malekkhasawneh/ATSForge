abstract final class AppConstants {
  static const appName = 'ATSForge';
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://atsforge.org',
  );
  static const privacyUrl = 'https://atsforge.org/resources/privacy-policy';
  static const draftKey = 'atsforge_resume_draft_v1';
}
