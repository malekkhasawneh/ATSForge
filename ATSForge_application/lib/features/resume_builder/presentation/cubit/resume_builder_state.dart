part of 'resume_builder_cubit.dart';

enum ResumeBuilderStatus { loading, ready, analyzing, exporting, failure }

class ResumeBuilderState extends Equatable {
  const ResumeBuilderState({
    this.status = ResumeBuilderStatus.loading,
    this.resume = const Resume(),
    this.step = 0,
    this.analysis,
    this.message,
    this.exportedFile,
  });
  final ResumeBuilderStatus status;
  final Resume resume;
  final int step;
  final ResumeAnalysis? analysis;
  final String? message;
  final File? exportedFile;

  ResumeBuilderState copyWith(
          {ResumeBuilderStatus? status,
          Resume? resume,
          int? step,
          ResumeAnalysis? analysis,
          String? message,
          File? exportedFile,
          bool clearMessage = false,
          bool clearFile = false}) =>
      ResumeBuilderState(
        status: status ?? this.status,
        resume: resume ?? this.resume,
        step: step ?? this.step,
        analysis: analysis ?? this.analysis,
        message: clearMessage ? null : message ?? this.message,
        exportedFile: clearFile ? null : exportedFile ?? this.exportedFile,
      );
  @override
  List<Object?> get props =>
      [status, resume, step, analysis, message, exportedFile];
}
