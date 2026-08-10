import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/helpers/file_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/resume.dart';

class ResumeRemoteDataSource {
  const ResumeRemoteDataSource(this.client);
  final ApiClient client;

  Future<ResumeAnalysis> analyze(Resume resume) async {
    try {
      final response = await client.dio
          .post<Map<String, dynamic>>('/api/analyze', data: resume.toJson());
      final analysis =
          Map<String, dynamic>.from(response.data?['analysis'] as Map? ?? {});
      return ResumeAnalysis(
          score: analysis['score'] as int? ?? 0,
          checks: Map<String, bool>.from(analysis['checks'] as Map? ?? {}));
    } on DioException catch (error) {
      throw AppException(_message(error));
    }
  }

  Future<File> export(Resume resume, String type) async {
    try {
      final response = await client.dio.post<List<int>>('/api/download/$type',
          data: resume.toJson(),
          options: Options(responseType: ResponseType.bytes));
      final safeName =
          resume.basics.name.trim().replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '_');
      return FileHelper.saveTemporary(response.data ?? [],
          '${safeName.isEmpty ? 'ATS_Resume' : safeName}_ATS_Resume.$type');
    } on DioException catch (error) {
      throw AppException(_message(error));
    }
  }

  String _message(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['error'] is String) return data['error'] as String;
    return 'ATSForge could not reach the server. Check your connection and try again.';
  }
}
