import 'package:equatable/equatable.dart';

class ResumeBasics extends Equatable {
  const ResumeBasics(
      {this.name = '',
      this.title = '',
      this.email = '',
      this.phone = '',
      this.location = '',
      this.linkedin = '',
      this.summary = ''});
  final String name, title, email, phone, location, linkedin, summary;

  ResumeBasics copyWith(
          {String? name,
          String? title,
          String? email,
          String? phone,
          String? location,
          String? linkedin,
          String? summary}) =>
      ResumeBasics(
        name: name ?? this.name,
        title: title ?? this.title,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        location: location ?? this.location,
        linkedin: linkedin ?? this.linkedin,
        summary: summary ?? this.summary,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'email': email,
        'phone': phone,
        'location': location,
        'linkedin': linkedin,
        'summary': summary
      };
  factory ResumeBasics.fromJson(Map<String, dynamic> json) => ResumeBasics(
        name: json['name'] as String? ?? '',
        title: json['title'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        location: json['location'] as String? ?? '',
        linkedin: json['linkedin'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
      );
  @override
  List<Object?> get props =>
      [name, title, email, phone, location, linkedin, summary];
}

class ExperienceEntry extends Equatable {
  const ExperienceEntry(
      {this.title = '',
      this.company = '',
      this.location = '',
      this.start = '',
      this.end = '',
      this.highlights = ''});
  final String title, company, location, start, end, highlights;
  ExperienceEntry copyWith(
          {String? title,
          String? company,
          String? location,
          String? start,
          String? end,
          String? highlights}) =>
      ExperienceEntry(
        title: title ?? this.title,
        company: company ?? this.company,
        location: location ?? this.location,
        start: start ?? this.start,
        end: end ?? this.end,
        highlights: highlights ?? this.highlights,
      );
  Map<String, dynamic> toJson() => {
        'title': title,
        'company': company,
        'location': location,
        'start': start,
        'end': end,
        'highlights': highlights
      };
  factory ExperienceEntry.fromJson(Map<String, dynamic> j) => ExperienceEntry(
      title: j['title'] as String? ?? '',
      company: j['company'] as String? ?? '',
      location: j['location'] as String? ?? '',
      start: j['start'] as String? ?? '',
      end: j['end'] as String? ?? '',
      highlights: j['highlights'] as String? ?? '');
  @override
  List<Object?> get props => [title, company, location, start, end, highlights];
}

class EducationEntry extends Equatable {
  const EducationEntry(
      {this.degree = '',
      this.school = '',
      this.location = '',
      this.start = '',
      this.end = '',
      this.details = ''});
  final String degree, school, location, start, end, details;
  EducationEntry copyWith(
          {String? degree,
          String? school,
          String? location,
          String? start,
          String? end,
          String? details}) =>
      EducationEntry(
        degree: degree ?? this.degree,
        school: school ?? this.school,
        location: location ?? this.location,
        start: start ?? this.start,
        end: end ?? this.end,
        details: details ?? this.details,
      );
  Map<String, dynamic> toJson() => {
        'degree': degree,
        'school': school,
        'location': location,
        'start': start,
        'end': end,
        'details': details
      };
  factory EducationEntry.fromJson(Map<String, dynamic> j) => EducationEntry(
      degree: j['degree'] as String? ?? '',
      school: j['school'] as String? ?? '',
      location: j['location'] as String? ?? '',
      start: j['start'] as String? ?? '',
      end: j['end'] as String? ?? '',
      details: j['details'] as String? ?? '');
  @override
  List<Object?> get props => [degree, school, location, start, end, details];
}

class ProjectEntry extends Equatable {
  const ProjectEntry({this.name = '', this.link = '', this.description = ''});
  final String name, link, description;
  ProjectEntry copyWith({String? name, String? link, String? description}) =>
      ProjectEntry(
          name: name ?? this.name,
          link: link ?? this.link,
          description: description ?? this.description);
  Map<String, dynamic> toJson() =>
      {'name': name, 'link': link, 'description': description};
  factory ProjectEntry.fromJson(Map<String, dynamic> j) => ProjectEntry(
      name: j['name'] as String? ?? '',
      link: j['link'] as String? ?? '',
      description: j['description'] as String? ?? '');
  @override
  List<Object?> get props => [name, link, description];
}

class Resume extends Equatable {
  const Resume(
      {this.template = 'professional',
      this.basics = const ResumeBasics(),
      this.experience = const [],
      this.education = const [],
      this.projects = const [],
      this.skills = const [],
      this.languages = const []});
  final String template;
  final ResumeBasics basics;
  final List<ExperienceEntry> experience;
  final List<EducationEntry> education;
  final List<ProjectEntry> projects;
  final List<String> skills, languages;

  Resume copyWith(
          {String? template,
          ResumeBasics? basics,
          List<ExperienceEntry>? experience,
          List<EducationEntry>? education,
          List<ProjectEntry>? projects,
          List<String>? skills,
          List<String>? languages}) =>
      Resume(
        template: template ?? this.template,
        basics: basics ?? this.basics,
        experience: experience ?? this.experience,
        education: education ?? this.education,
        projects: projects ?? this.projects,
        skills: skills ?? this.skills,
        languages: languages ?? this.languages,
      );
  Map<String, dynamic> toJson() => {
        'template': template,
        'basics': basics.toJson(),
        'experience': experience.map((e) => e.toJson()).toList(),
        'education': education.map((e) => e.toJson()).toList(),
        'projects': projects.map((e) => e.toJson()).toList(),
        'skills': skills,
        'languages': languages
      };
  factory Resume.fromJson(Map<String, dynamic> j) => Resume(
        template: j['template'] as String? ?? 'professional',
        basics: ResumeBasics.fromJson(
            Map<String, dynamic>.from(j['basics'] as Map? ?? {})),
        experience: (j['experience'] as List? ?? [])
            .map((e) =>
                ExperienceEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        education: (j['education'] as List? ?? [])
            .map((e) =>
                EducationEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        projects: (j['projects'] as List? ?? [])
            .map((e) =>
                ProjectEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        skills: List<String>.from(j['skills'] as List? ?? []),
        languages: List<String>.from(j['languages'] as List? ?? []),
      );
  @override
  List<Object?> get props =>
      [template, basics, experience, education, projects, skills, languages];
}

class ResumeAnalysis extends Equatable {
  const ResumeAnalysis({required this.score, required this.checks});
  final int score;
  final Map<String, bool> checks;
  @override
  List<Object?> get props => [score, checks];
}
