import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/helpers/file_helper.dart';
import '../../../core/network/api_client.dart';
import '../../resume_builder/domain/entities/resume.dart';
import '../domain/entities/cover_letter.dart';

class CoverLetterRemoteDataSource {
  const CoverLetterRemoteDataSource(this.client);
  final ApiClient client;

  Future<CoverLetter> generate({
    required Resume resume,
    required String company,
    required String recipient,
    required String jobDescription,
    required String motivation,
    required String tone,
  }) async {
    try {
      final response = await client.dio.post<Map<String, dynamic>>(
        '/api/generate-cover-letter',
        data: {
          'resume': resume.toJson(),
          'company': company,
          'recipient': recipient,
          'job_description': jobDescription,
          'motivation': motivation,
          'tone': tone,
        },
      );
      return CoverLetter.fromJson(
          Map<String, dynamic>.from(response.data?['letter'] as Map? ?? {}));
    } on DioException catch (error) {
      throw AppException(_message(error));
    }
  }

  Future<File> export({
    required Resume resume,
    required String company,
    required String recipient,
    required CoverLetter letter,
    required String type,
  }) async {
    try {
      final response = await client.dio.post<List<int>>(
        '/api/download/cover-letter/$type',
        data: {
          'resume': resume.toJson(),
          'company': company,
          'recipient': recipient,
          'letter': letter.toJson(),
        },
        options: Options(responseType: ResponseType.bytes),
      );
      final safeName =
          resume.basics.name.trim().replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '_');
      return FileHelper.saveTemporary(response.data ?? [],
          '${safeName.isEmpty ? 'ATSForge' : safeName}_Cover_Letter.$type');
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
