import 'dart:io';

import '../entities/resume.dart';

abstract interface class ResumeRepository {
  Future<Resume?> loadDraft();
  Future<void> saveDraft(Resume resume);
  Future<void> clearDraft();
  Future<ResumeAnalysis> analyze(Resume resume);
  Future<File> export(Resume resume, String type);
}
