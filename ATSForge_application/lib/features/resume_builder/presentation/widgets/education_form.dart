import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../cubit/resume_builder_cubit.dart';
import 'form_layout.dart';

class EducationForm extends StatelessWidget {
  const EducationForm({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResumeBuilderCubit>();
    final resume = context.watch<ResumeBuilderCubit>().state.resume;
    return Column(children: [
      SectionHeading(
          step: 3,
          title: 'Education & projects',
          action: TextButton.icon(
              onPressed: cubit.addEducation,
              icon: const Icon(Icons.add),
              label: const Text('Add education'))),
      ...resume.education.asMap().entries.map((entry) {
        final i = entry.key;
        final e = entry.value;
        return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        child: Text('Education ${i + 1}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
                    IconButton(
                        onPressed: () => cubit.removeEducation(i),
                        icon: const Icon(Icons.close))
                  ]),
                  FormPair(children: [
                    AppTextField(
                        label: 'Degree ${i + 1}',
                        initialValue: e.degree,
                        onChanged: (v) =>
                            cubit.updateEducation(i, 'degree', v)),
                    AppTextField(
                        label: 'Institution ${i + 1}',
                        initialValue: e.school,
                        onChanged: (v) => cubit.updateEducation(i, 'school', v))
                  ]),
                  const SizedBox(height: 13),
                  FormPair(children: [
                    AppTextField(
                        label: 'Education location ${i + 1}',
                        initialValue: e.location,
                        onChanged: (v) =>
                            cubit.updateEducation(i, 'location', v)),
                    AppTextField(
                        label: 'Education start ${i + 1}',
                        initialValue: e.start,
                        onChanged: (v) => cubit.updateEducation(i, 'start', v)),
                    AppTextField(
                        label: 'Education end ${i + 1}',
                        initialValue: e.end,
                        onChanged: (v) => cubit.updateEducation(i, 'end', v))
                  ]),
                  const SizedBox(height: 13),
                  AppTextField(
                      label: 'Education details ${i + 1}',
                      initialValue: e.details,
                      onChanged: (v) => cubit.updateEducation(i, 'details', v)),
                ])));
      }),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(
            child: Text('Selected projects',
                style: Theme.of(context).textTheme.titleLarge)),
        TextButton.icon(
            onPressed: cubit.addProject,
            icon: const Icon(Icons.add),
            label: const Text('Add project'))
      ]),
      ...resume.projects.asMap().entries.map((entry) {
        final i = entry.key;
        final p = entry.value;
        return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        child: Text('Project ${i + 1}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700))),
                    IconButton(
                        onPressed: () => cubit.removeProject(i),
                        icon: const Icon(Icons.close))
                  ]),
                  FormPair(children: [
                    AppTextField(
                        label: 'Project name ${i + 1}',
                        initialValue: p.name,
                        onChanged: (v) => cubit.updateProject(i, 'name', v)),
                    AppTextField(
                        label: 'Project link ${i + 1}',
                        initialValue: p.link,
                        onChanged: (v) => cubit.updateProject(i, 'link', v))
                  ]),
                  const SizedBox(height: 13),
                  AppTextField(
                      label: 'Project description ${i + 1}',
                      initialValue: p.description,
                      maxLines: 3,
                      onChanged: (v) =>
                          cubit.updateProject(i, 'description', v)),
                ])));
      }),
    ]);
  }
}
