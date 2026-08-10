import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../cubit/resume_builder_cubit.dart';
import 'form_layout.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResumeBuilderCubit>();
    final b = context.select((ResumeBuilderCubit c) => c.state.resume.basics);
    return Column(children: [
      const SectionHeading(step: 1, title: 'Introduce yourself'),
      FormPair(children: [
        AppTextField(
            label: 'Full name',
            initialValue: b.name,
            hint: 'e.g. Maya Haddad',
            onChanged: (v) => cubit.updateBasic('name', v)),
        AppTextField(
            label: 'Professional title',
            initialValue: b.title,
            hint: 'e.g. Product Designer',
            onChanged: (v) => cubit.updateBasic('title', v))
      ]),
      const SizedBox(height: 13),
      FormPair(children: [
        AppTextField(
            label: 'Email',
            initialValue: b.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) => cubit.updateBasic('email', v)),
        AppTextField(
            label: 'Phone',
            initialValue: b.phone,
            keyboardType: TextInputType.phone,
            onChanged: (v) => cubit.updateBasic('phone', v))
      ]),
      const SizedBox(height: 13),
      FormPair(children: [
        AppTextField(
            label: 'Location',
            initialValue: b.location,
            onChanged: (v) => cubit.updateBasic('location', v)),
        AppTextField(
            label: 'LinkedIn / portfolio',
            initialValue: b.linkedin,
            keyboardType: TextInputType.url,
            onChanged: (v) => cubit.updateBasic('linkedin', v))
      ]),
      const SizedBox(height: 13),
      AppTextField(
          label: 'Professional summary',
          initialValue: b.summary,
          maxLines: 5,
          hint:
              'Name your field, experience, capabilities, and the value you create.',
          onChanged: (v) => cubit.updateBasic('summary', v)),
      const WritingTip(
          title: 'Make it credible',
          body:
              'Aim for three or four specific lines. Avoid generic claims such as “hard-working team player.”'),
    ]);
  }
}
