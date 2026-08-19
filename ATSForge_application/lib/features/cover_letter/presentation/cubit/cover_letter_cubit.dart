import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../resume_builder/domain/entities/resume.dart';
import '../../../resume_builder/domain/repositories/resume_repository.dart';
import '../../data/cover_letter_remote_data_source.dart';
import '../../domain/entities/cover_letter.dart';

part 'cover_letter_state.dart';

class CoverLetterCubit extends Cubit<CoverLetterState> {
  CoverLetterCubit(this._resumeRepository, this._remote)
      : super(const CoverLetterState());

  final ResumeRepository _resumeRepository;
  final CoverLetterRemoteDataSource _remote;

  Future<void> initialize() async {
    final resume = await _resumeRepository.loadDraft();
    emit(state.copyWith(resume: resume, status: CoverLetterStatus.ready));
  }

  void update(
          {String? company,
          String? recipient,
          String? jobDescription,
          String? motivation,
          String? tone}) =>
      emit(state.copyWith(
          company: company,
          recipient: recipient,
          jobDescription: jobDescription,
          motivation: motivation,
          tone: tone,
          clearMessage: true));

  void updateLetter(CoverLetter letter) =>
      emit(state.copyWith(letter: letter, clearMessage: true));

  Future<void> generate() async {
    if (!state.canGenerate) {
      emit(state.copyWith(
          message:
              'Add a saved resume, company name, and a complete job description.'));
      return;
    }
    emit(state.copyWith(
        status: CoverLetterStatus.generating, clearMessage: true));
    try {
      final letter = await _remote.generate(
          resume: state.resume!,
          company: state.company,
          recipient: state.recipient,
          jobDescription: state.jobDescription,
          motivation: state.motivation,
          tone: state.tone);
      emit(state.copyWith(status: CoverLetterStatus.ready, letter: letter));
    } on AppException catch (error) {
      emit(state.copyWith(
          status: CoverLetterStatus.failure, message: error.message));
    }
  }

  Future<void> export(String type) async {
    if (state.resume == null || state.letter == null) return;
    emit(state.copyWith(
        status: CoverLetterStatus.exporting,
        clearMessage: true,
        clearFile: true));
    try {
      final file = await _remote.export(
          resume: state.resume!,
          company: state.company,
          recipient: state.recipient,
          letter: state.letter!,
          type: type);
      emit(state.copyWith(status: CoverLetterStatus.ready, exportedFile: file));
    } on AppException catch (error) {
      emit(state.copyWith(
          status: CoverLetterStatus.failure, message: error.message));
    }
  }
}
