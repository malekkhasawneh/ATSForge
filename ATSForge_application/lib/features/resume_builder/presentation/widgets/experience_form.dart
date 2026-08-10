import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../cubit/resume_builder_cubit.dart';
import 'form_layout.dart';

class ExperienceForm extends StatelessWidget {
  const ExperienceForm({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResumeBuilderCubit>();
    final items =
        context.select((ResumeBuilderCubit c) => c.state.resume.experience);
    return Column(children: [
      SectionHeading(
          step: 2,
          title: 'Show your impact',
          action: TextButton.icon(
              onPressed: cubit.addExperience,
              icon: const Icon(Icons.add),
              label: const Text('Add role'))),
      if (items.isEmpty)
        const _Empty(message: 'No roles yet. Add your first role.')
      else
        ...items.asMap().entries.map((entry) {
          final i = entry.key;
          final e = entry.value;
          return Card(
              key: ValueKey('experience-$i'),
              margin: const EdgeInsets.only(bottom: 14),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                          child: Text('Role ${i + 1}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700))),
                      IconButton(
                          tooltip: 'Remove role',
                          onPressed: () => cubit.removeExperience(i),
                          icon: const Icon(Icons.close))
                    ]),
                    FormPair(children: [
                      AppTextField(
                          label: 'Job title ${i + 1}',
                          initialValue: e.title,
                          onChanged: (v) =>
                              cubit.updateExperience(i, 'title', v)),
                      AppTextField(
                          label: 'Company ${i + 1}',
                          initialValue: e.company,
                          onChanged: (v) =>
                              cubit.updateExperience(i, 'company', v))
                    ]),
                    const SizedBox(height: 13),
                    FormPair(children: [
                      AppTextField(
                          label: 'Location ${i + 1}',
                          initialValue: e.location,
                          onChanged: (v) =>
                              cubit.updateExperience(i, 'location', v)),
                      AppTextField(
                          label: 'Start ${i + 1}',
                          initialValue: e.start,
                          onChanged: (v) =>
                              cubit.updateExperience(i, 'start', v)),
                      AppTextField(
                          label: 'End ${i + 1}',
                          initialValue: e.end,
                          onChanged: (v) => cubit.updateExperience(i, 'end', v))
                    ]),
                    const SizedBox(height: 13),
                    AppTextField(
                        label: 'Achievements ${i + 1}',
                        initialValue: e.highlights,
                        maxLines: 6,
                        hint: 'One truthful achievement per line',
                        onChanged: (v) =>
                            cubit.updateExperience(i, 'highlights', v)),
                  ])));
        }),
      const WritingTip(
          title: 'Write evidence, not duties',
          body:
              'Start with a strong verb, describe what changed, then quantify the result where truthful. Never invent a metric.'),
    ]);
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 26),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD8DDD8)),
          borderRadius: BorderRadius.circular(10)),
      child: Text(message, textAlign: TextAlign.center));
}
