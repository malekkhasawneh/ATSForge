import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/helpers/file_helper.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/tailor_result.dart';

class TailorRemoteDataSource {
  const TailorRemoteDataSource(this.client);
  final ApiClient client;

  Future<TailorResult> tailor(
      {required File resume,
      File? jobFile,
      required String jobDescription}) async {
    try {
      final form = FormData.fromMap({
        'resume': await MultipartFile.fromFile(resume.path,
            filename: resume.uri.pathSegments.last),
        'job_description': jobDescription,
        if (jobFile != null)
          'job_file': await MultipartFile.fromFile(jobFile.path,
              filename: jobFile.uri.pathSegments.last),
      });
      final response = await client.dio.post<List<int>>('/api/tailor-resume',
          data: form, options: Options(responseType: ResponseType.bytes));
      String header(String name) => response.headers.value(name) ?? '';
      final original = resume.uri.pathSegments.last
          .replaceFirst(RegExp(r'\.docx$', caseSensitive: false), '');
      final file = await FileHelper.saveTemporary(
          response.data ?? [], '${original}_Tailored_ATS.docx');
      return TailorResult(
        file: file,
        mode: header('x-tailor-mode'),
        beforeScore: int.tryParse(header('x-job-match-before')) ?? 0,
        afterScore: int.tryParse(header('x-job-match-after')) ?? 0,
        matched: header('x-matched-keywords'),
        missing: header('x-missing-keywords'),
      );
    } on DioException catch (error) {
      var message =
          'The résumé could not be tailored. Check your connection and try again.';
      final data = error.response?.data;
      if (data is Map && data['error'] is String) {
        message = data['error'] as String;
      }
      if (data is List<int>) {
        try {
          message = String.fromCharCodes(data);
        } catch (_) {}
      }
      throw AppException(message);
    }
  }
}
