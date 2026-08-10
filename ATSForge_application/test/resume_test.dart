import 'package:atsforge_application/features/resume_builder/domain/entities/resume.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Resume', () {
    test('round-trips through the Flask API JSON shape', () {
      const resume = Resume(
        template: 'modern',
        basics: ResumeBasics(name: 'Maya Haddad', email: 'maya@example.com'),
        experience: [
          ExperienceEntry(title: 'Product Designer', company: 'Northstar')
        ],
        skills: ['Research', 'Figma'],
      );

      expect(Resume.fromJson(resume.toJson()), resume);
    });

    test('uses safe defaults for an empty API payload', () {
      final resume = Resume.fromJson(const {});

      expect(resume.template, 'professional');
      expect(resume.experience, isEmpty);
      expect(resume.basics.name, isEmpty);
    });
  });
}
