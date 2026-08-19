part of 'cover_letter_cubit.dart';

enum CoverLetterStatus { loading, ready, generating, exporting, failure }

class CoverLetterState extends Equatable {
  const CoverLetterState(
      {this.status = CoverLetterStatus.loading,
      this.resume,
      this.company = '',
      this.recipient = '',
      this.jobDescription = '',
      this.motivation = '',
      this.tone = 'professional',
      this.letter,
      this.message,
      this.exportedFile});
  final CoverLetterStatus status;
  final Resume? resume;
  final String company, recipient, jobDescription, motivation, tone;
  final CoverLetter? letter;
  final String? message;
  final File? exportedFile;
  bool get canGenerate =>
      resume != null &&
      resume!.basics.name.trim().isNotEmpty &&
      company.trim().isNotEmpty &&
      jobDescription.trim().split(RegExp(r'\s+')).length >= 30;
  CoverLetterState copyWith(
          {CoverLetterStatus? status,
          Resume? resume,
          String? company,
          String? recipient,
          String? jobDescription,
          String? motivation,
          String? tone,
          CoverLetter? letter,
          String? message,
          File? exportedFile,
          bool clearMessage = false,
          bool clearFile = false}) =>
      CoverLetterState(
          status: status ?? this.status,
          resume: resume ?? this.resume,
          company: company ?? this.company,
          recipient: recipient ?? this.recipient,
          jobDescription: jobDescription ?? this.jobDescription,
          motivation: motivation ?? this.motivation,
          tone: tone ?? this.tone,
          letter: letter ?? this.letter,
          message: clearMessage ? null : message ?? this.message,
          exportedFile: clearFile ? null : exportedFile ?? this.exportedFile);
  @override
  List<Object?> get props => [
        status,
        resume,
        company,
        recipient,
        jobDescription,
        motivation,
        tone,
        letter,
        message,
        exportedFile
      ];
}
