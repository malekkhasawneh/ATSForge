import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class DraftStorage {
  const DraftStorage(this.preferences);
  final SharedPreferences preferences;

  String? read() => preferences.getString(AppConstants.draftKey);
  Future<bool> write(String value) =>
      preferences.setString(AppConstants.draftKey, value);
  Future<bool> clear() => preferences.remove(AppConstants.draftKey);
}
