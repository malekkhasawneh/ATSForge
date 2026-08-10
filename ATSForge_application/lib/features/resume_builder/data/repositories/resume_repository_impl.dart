import 'dart:io';

import '../../domain/entities/resume.dart';
import '../../domain/repositories/resume_repository.dart';
import '../datasources/resume_local_data_source.dart';
import '../datasources/resume_remote_data_source.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  const ResumeRepositoryImpl(this.local, this.remote);
  final ResumeLocalDataSource local;
  final ResumeRemoteDataSource remote;
  @override
  Future<Resume?> loadDraft() => local.load();
  @override
  Future<void> saveDraft(Resume resume) => local.save(resume);
  @override
  Future<void> clearDraft() => local.clear();
  @override
  Future<ResumeAnalysis> analyze(Resume resume) => remote.analyze(resume);
  @override
  Future<File> export(Resume resume, String type) =>
      remote.export(resume, type);
}
