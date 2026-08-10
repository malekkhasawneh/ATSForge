import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../cubit/resume_builder_cubit.dart';
import 'form_layout.dart';

class SkillsForm extends StatelessWidget {
  const SkillsForm({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResumeBuilderCubit>();
    final resume = context.select((ResumeBuilderCubit c) => c.state.resume);
    return Column(children: [
      const SectionHeading(step: 4, title: 'Map your capabilities'),
      AppTextField(
          label: 'Core skills',
          initialValue: resume.skills.join(', '),
          maxLines: 5,
          hint: 'Product strategy, User research, Figma, Accessibility',
          onChanged: cubit.updateSkills),
      const SizedBox(height: 13),
      AppTextField(
          label: 'Languages',
          initialValue: resume.languages.join(', '),
          hint: 'Arabic — Native, English — Professional',
          onChanged: cubit.updateLanguages),
      const WritingTip(
          title: 'Keep it relevant',
          body:
              'Use recognized names for tools and methods. Prioritize capabilities you can support with experience.'),
    ]);
  }
}
