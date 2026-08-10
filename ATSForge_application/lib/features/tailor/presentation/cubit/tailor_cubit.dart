import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/tailor_result.dart';
import '../../domain/repositories/tailor_repository.dart';

part 'tailor_state.dart';

class TailorCubit extends Cubit<TailorState> {
  TailorCubit(this.repository) : super(const TailorState());
  final TailorRepository repository;

  Future<void> pickResume() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: const ['docx']);
    final path = result?.files.single.path;
    if (path != null) {
      emit(state.copyWith(
          status: TailorStatus.ready, resumeFile: File(path), message: null));
    }
  }

  Future<void> pickJobFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: const ['docx']);
    final path = result?.files.single.path;
    if (path != null) {
      emit(state.copyWith(
          status: TailorStatus.ready, jobFile: File(path), message: null));
    }
  }

  void updateDescription(String value) => emit(state.copyWith(
      status: TailorStatus.ready,
      jobDescription: value,
      clearJobFile: value.trim().isNotEmpty,
      message: null));
  void updateConsent(bool value) =>
      emit(state.copyWith(consent: value, message: null));
  Future<void> submit() async {
    if (!state.canSubmit || state.resumeFile == null) {
      emit(state.copyWith(
          status: TailorStatus.failure,
          message:
              'Choose a DOCX résumé, add a complete job description, and confirm consent.'));
      return;
    }
    emit(state.copyWith(
        status: TailorStatus.submitting, message: null, clearResult: true));
    try {
      final result = await repository.tailor(
          resume: state.resumeFile!,
          jobFile: state.jobFile,
          jobDescription: state.jobDescription);
      emit(state.copyWith(status: TailorStatus.success, result: result));
    } on AppException catch (error) {
      emit(
          state.copyWith(status: TailorStatus.failure, message: error.message));
    } catch (_) {
      emit(state.copyWith(
          status: TailorStatus.failure,
          message: 'The résumé could not be tailored.'));
    }
  }

  void reset() => emit(const TailorState());
}
