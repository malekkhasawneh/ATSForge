import 'dart:convert';

import '../../../../core/storage/draft_storage.dart';
import '../../domain/entities/resume.dart';

class ResumeLocalDataSource {
  const ResumeLocalDataSource(this.storage);
  final DraftStorage storage;

  Future<Resume?> load() async {
    final raw = storage.read();
    if (raw == null) return null;
    try {
      return Resume.fromJson(Map<String, dynamic>.from(jsonDecode(raw) as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> save(Resume resume) async =>
      storage.write(jsonEncode(resume.toJson()));
  Future<void> clear() async => storage.clear();
}
