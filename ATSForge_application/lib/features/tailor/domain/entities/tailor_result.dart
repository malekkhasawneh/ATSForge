import 'dart:io';

import 'package:equatable/equatable.dart';

class TailorResult extends Equatable {
  const TailorResult(
      {required this.file,
      required this.beforeScore,
      required this.afterScore,
      required this.mode,
      required this.matched,
      required this.missing});
  final File file;
  final int beforeScore, afterScore;
  final String mode, matched, missing;
  @override
  List<Object> get props =>
      [file.path, beforeScore, afterScore, mode, matched, missing];
}
