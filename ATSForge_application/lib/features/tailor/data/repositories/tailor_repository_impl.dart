import 'dart:io';

import '../../domain/entities/tailor_result.dart';
import '../../domain/repositories/tailor_repository.dart';
import '../datasources/tailor_remote_data_source.dart';

class TailorRepositoryImpl implements TailorRepository {
  const TailorRepositoryImpl(this.remote);
  final TailorRemoteDataSource remote;
  @override
  Future<TailorResult> tailor(
          {required File resume,
          File? jobFile,
          required String jobDescription}) =>
      remote.tailor(
          resume: resume, jobFile: jobFile, jobDescription: jobDescription);
}
