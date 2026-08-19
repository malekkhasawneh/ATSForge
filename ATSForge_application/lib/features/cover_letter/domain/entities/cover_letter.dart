import 'package:equatable/equatable.dart';

class CoverLetter extends Equatable {
  const CoverLetter({
    this.greeting = '',
    this.paragraphs = const [],
    this.closing = '',
  });

  final String greeting;
  final List<String> paragraphs;
  final String closing;

  Map<String, dynamic> toJson() => {
        'greeting': greeting,
        'paragraphs': paragraphs,
        'closing': closing,
      };

  factory CoverLetter.fromJson(Map<String, dynamic> json) => CoverLetter(
        greeting: json['greeting'] as String? ?? '',
        paragraphs: List<String>.from(json['paragraphs'] as List? ?? []),
        closing: json['closing'] as String? ?? '',
      );

  CoverLetter copyWith(
          {String? greeting, List<String>? paragraphs, String? closing}) =>
      CoverLetter(
        greeting: greeting ?? this.greeting,
        paragraphs: paragraphs ?? this.paragraphs,
        closing: closing ?? this.closing,
      );

  @override
  List<Object?> get props => [greeting, paragraphs, closing];
}
