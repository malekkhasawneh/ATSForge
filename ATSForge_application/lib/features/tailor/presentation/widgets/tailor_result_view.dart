import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/helpers/file_helper.dart';
import '../../domain/entities/tailor_result.dart';

class TailorResultView extends StatelessWidget {
  const TailorResultView(
      {required this.result, required this.onReset, super.key});
  final TailorResult result;
  final VoidCallback onReset;
  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
                color: Color(0xFFE0EFDF), shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded,
                size: 34, color: AppColors.green)),
        const SizedBox(height: 18),
        Text('Your tailored résumé is ready',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 7),
        Text(
            result.mode == 'ai'
                ? 'Wording and hierarchy were tailored using source-supported evidence only.'
                : 'Your original wording was preserved and reformatted for ATS readability.',
            textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _Score(label: 'BEFORE', score: result.beforeScore),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Icon(Icons.arrow_forward)),
          _Score(label: 'AFTER', score: result.afterScore)
        ]),
        const SizedBox(height: 20),
        _Keywords(
            label: 'Matched keywords',
            value: result.matched.isEmpty
                ? 'No strong matches found yet.'
                : result.matched,
            color: AppColors.success),
        const SizedBox(height: 10),
        _Keywords(
            label: 'Potential gaps',
            value: result.missing.isEmpty
                ? 'No major keyword gaps detected.'
                : result.missing,
            color: AppColors.warning),
        const SizedBox(height: 22),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
                onPressed: () => FileHelper.open(result.file),
                icon: const Icon(Icons.download_rounded),
                label: const Text('Open tailored DOCX'))),
        TextButton.icon(
            onPressed: () => FileHelper.share(result.file),
            icon: const Icon(Icons.ios_share),
            label: const Text('Share or save')),
        TextButton(
            onPressed: onReset, child: const Text('Tailor another résumé')),
      ]);
}

class _Score extends StatelessWidget {
  const _Score({required this.label, required this.score});
  final String label;
  final int score;
  @override
  Widget build(BuildContext context) => Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Text(label,
            style: const TextStyle(fontSize: 9, color: AppColors.muted)),
        Text('$score%', style: Theme.of(context).textTheme.headlineMedium)
      ]));
}

class _Keywords extends StatelessWidget {
  const _Keywords(
      {required this.label, required this.value, required this.color});
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: color.withOpacity(.08),
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 4),
        Text(value)
      ]));
}
