import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

class ApiClient {
  ApiClient()
      : dio = Dio(BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          connectTimeout: const Duration(seconds: 12),
          receiveTimeout: const Duration(seconds: 100),
          sendTimeout: const Duration(seconds: 100),
          headers: const {'Accept': 'application/json'},
        ));

  final Dio dio;
}
