import 'dart:io';

import '../entities/tailor_result.dart';

abstract interface class TailorRepository {
  Future<TailorResult> tailor(
      {required File resume, File? jobFile, required String jobDescription});
}
