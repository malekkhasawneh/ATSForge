import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/resume.dart';

class ResumePreview extends StatelessWidget {
  const ResumePreview({required this.resume, super.key});
  final Resume resume;
  @override
  Widget build(BuildContext context) {
    final accent = switch (resume.template) {
      'modern' => const Color(0xFF235F47),
      'minimal' => const Color(0xFF333333),
      'executive' => const Color(0xFF20354A),
      _ => const Color(0xFF18221D)
    };
    final centered =
        resume.template == 'professional' || resume.template == 'executive';
    final contact = [
      resume.basics.location,
      resume.basics.phone,
      resume.basics.email,
      resume.basics.linkedin
    ].where((e) => e.isNotEmpty).join('  |  ');
    return Container(
      width: 560,
      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 34),
      color: Colors.white,
      child: DefaultTextStyle(
          style:
              const TextStyle(color: AppColors.ink, fontSize: 10, height: 1.4),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: centered
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                          resume.basics.name.isEmpty
                              ? 'YOUR NAME'
                              : resume.basics.name.toUpperCase(),
                          textAlign:
                              centered ? TextAlign.center : TextAlign.left,
                          style: TextStyle(
                              fontSize:
                                  resume.template == 'executive' ? 24 : 22,
                              fontWeight: FontWeight.w800,
                              color: accent,
                              fontFamily: resume.template == 'executive'
                                  ? 'serif'
                                  : null)),
                      if (resume.basics.title.isNotEmpty)
                        Text(resume.basics.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                      if (contact.isNotEmpty)
                        Text(contact,
                            textAlign:
                                centered ? TextAlign.center : TextAlign.left),
                    ])),
            const SizedBox(height: 10),
            Divider(color: accent),
            _Section(
                title: 'Professional Summary',
                accent: accent,
                visible: resume.basics.summary.isNotEmpty,
                child: Text(resume.basics.summary)),
            _Section(
                title: 'Core Skills',
                accent: accent,
                visible: resume.skills.isNotEmpty,
                child: Text(resume.skills.join(' • '))),
            _Section(
                title: 'Professional Experience',
                accent: accent,
                visible: resume.experience
                    .any((e) => e.title.isNotEmpty || e.company.isNotEmpty),
                child: Column(
                    children: resume.experience
                        .where(
                            (e) => e.title.isNotEmpty || e.company.isNotEmpty)
                        .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Expanded(
                                        child: Text(
                                            [e.title, e.company]
                                                .where((v) => v.isNotEmpty)
                                                .join(' | '),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700))),
                                    Text([e.start, e.end]
                                        .where((v) => v.isNotEmpty)
                                        .join(' – '))
                                  ]),
                                  if (e.location.isNotEmpty) Text(e.location),
                                  ...e.highlights
                                      .split(RegExp(r'\n|•'))
                                      .where((v) => v.trim().isNotEmpty)
                                      .map((v) => Text('•  ${v.trim()}'))
                                ])))
                        .toList())),
            _Section(
                title: 'Selected Projects',
                accent: accent,
                visible: resume.projects.any((e) => e.name.isNotEmpty),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: resume.projects
                        .where((e) => e.name.isNotEmpty)
                        .map((p) => Text(
                            '${p.name}${p.link.isEmpty ? '' : ' | ${p.link}'}${p.description.isEmpty ? '' : ' — ${p.description}'}'))
                        .toList())),
            _Section(
                title: 'Education',
                accent: accent,
                visible: resume.education
                    .any((e) => e.degree.isNotEmpty || e.school.isNotEmpty),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: resume.education
                        .where(
                            (e) => e.degree.isNotEmpty || e.school.isNotEmpty)
                        .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text('${[
                              e.degree,
                              e.school
                            ].where((v) => v.isNotEmpty).join(' — ')}${e.details.isEmpty ? '' : ' | ${e.details}'}')))
                        .toList())),
            _Section(
                title: 'Languages',
                accent: accent,
                visible: resume.languages.isNotEmpty,
                child: Text(resume.languages.join(' • '))),
          ])),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(
      {required this.title,
      required this.accent,
      required this.visible,
      required this.child});
  final String title;
  final Color accent;
  final bool visible;
  final Widget child;
  @override
  Widget build(BuildContext context) => visible
      ? Padding(
          padding: const EdgeInsets.only(top: 9),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: double.infinity,
                child: Text(title.toUpperCase(),
                    style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1))),
            Divider(color: accent, height: 7),
            child
          ]))
      : const SizedBox.shrink();
}
