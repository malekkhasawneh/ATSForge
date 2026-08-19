import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_colors.dart';
import '../cubit/resume_builder_cubit.dart';
import 'form_layout.dart';

class ReviewForm extends StatelessWidget {
  const ReviewForm({super.key});
  @override
  Widget build(BuildContext context) {
    final analysis = context.select((ResumeBuilderCubit c) => c.state.analysis);
    final score = analysis?.score ?? 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeading(step: 5, title: 'Review your resume'),
      Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          decoration: BoxDecoration(
              color: const Color(0xFFF1F5ED),
              borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            SizedBox(
                width: 86,
                height: 86,
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 8,
                      backgroundColor: AppColors.line,
                      color: score >= 75
                          ? AppColors.success
                          : score >= 50
                              ? AppColors.warning
                              : AppColors.danger),
                  Text('$score',
                      style: Theme.of(context).textTheme.headlineMedium)
                ])),
            const SizedBox(width: 18),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Resume readiness review',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(analysis == null
                      ? 'Connect to the server to receive your review.'
                      : '${analysis.checks.values.where((v) => v).length} of ${analysis.checks.length} quality checks passed.')
                ]))
          ])),
      const SizedBox(height: 20),
      if (analysis != null)
        ...analysis.checks.entries.map((check) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
                check.value ? Icons.check_circle : Icons.radio_button_unchecked,
                color: check.value ? AppColors.success : AppColors.muted),
            title: Text(check.key),
            subtitle: check.value
                ? null
                : const Text(
                    'Add clear, truthful evidence where applicable.'))),
      const WritingTip(
          title: 'A readiness signal—not an employer ATS score',
          body:
              'Clear structure and honest relevance matter more than keyword stuffing. Review every detail before applying.'),
    ]);
  }
}
