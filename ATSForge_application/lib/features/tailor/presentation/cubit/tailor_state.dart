part of 'tailor_cubit.dart';

enum TailorStatus { idle, ready, submitting, success, failure }

class TailorState extends Equatable {
  const TailorState(
      {this.status = TailorStatus.idle,
      this.resumeFile,
      this.jobFile,
      this.jobDescription = '',
      this.consent = false,
      this.result,
      this.message});
  final TailorStatus status;
  final File? resumeFile, jobFile;
  final String jobDescription;
  final bool consent;
  final TailorResult? result;
  final String? message;
  bool get canSubmit =>
      resumeFile != null &&
      (jobFile != null ||
          jobDescription.trim().split(RegExp(r'\s+')).length >= 30) &&
      consent;
  TailorState copyWith(
          {TailorStatus? status,
          File? resumeFile,
          File? jobFile,
          String? jobDescription,
          bool? consent,
          TailorResult? result,
          String? message,
          bool clearResult = false,
          bool clearJobFile = false}) =>
      TailorState(
        status: status ?? this.status,
        resumeFile: resumeFile ?? this.resumeFile,
        jobFile: clearJobFile ? null : jobFile ?? this.jobFile,
        jobDescription: jobDescription ?? this.jobDescription,
        consent: consent ?? this.consent,
        result: clearResult ? null : result ?? this.result,
        message: message,
      );
  @override
  List<Object?> get props => [
        status,
        resumeFile?.path,
        jobFile?.path,
        jobDescription,
        consent,
        result,
        message
      ];
}
