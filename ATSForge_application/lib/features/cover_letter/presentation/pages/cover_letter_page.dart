import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_insets.dart';
import '../../../../core/helpers/file_helper.dart';
import '../../../../core/widgets/ats_app_bar.dart';
import '../../domain/entities/cover_letter.dart';
import '../cubit/cover_letter_cubit.dart';

class CoverLetterPage extends StatelessWidget {
  const CoverLetterPage({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocConsumer<CoverLetterCubit, CoverLetterState>(
        listenWhen: (previous, current) =>
            previous.message != current.message ||
            previous.exportedFile?.path != current.exportedFile?.path,
        listener: (context, state) async {
          if (state.exportedFile != null) {
            final saved = await FileHelper.saveToDevice(state.exportedFile!);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(saved
                      ? 'Cover letter saved successfully.'
                      : 'Saving was cancelled.')));
            }
          } else if (state.message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<CoverLetterCubit>();
          return Scaffold(
              appBar: const ATSAppBar(title: 'Cover Letter'),
              body: state.status == CoverLetterStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: SingleChildScrollView(
                          padding: AppInsets.page,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Create a focused cover letter',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                const SizedBox(height: 8),
                                const Text(
                                    'Your saved resume is used as evidence. Review every draft before applying.'),
                                const SizedBox(height: 20),
                                _ResumeStatus(
                                    available: state.resume != null,
                                    name: state.resume?.basics.name),
                                const SizedBox(height: 20),
                                TextFormField(
                                    initialValue: state.company,
                                    onChanged: (value) =>
                                        cubit.update(company: value),
                                    decoration: const InputDecoration(
                                        labelText: 'Company name')),
                                const SizedBox(height: 14),
                                TextFormField(
                                    initialValue: state.recipient,
                                    onChanged: (value) =>
                                        cubit.update(recipient: value),
                                    decoration: const InputDecoration(
                                        labelText:
                                            'Hiring manager (optional)')),
                                const SizedBox(height: 14),
                                TextFormField(
                                    initialValue: state.jobDescription,
                                    minLines: 7,
                                    maxLines: 11,
                                    onChanged: (value) =>
                                        cubit.update(jobDescription: value),
                                    decoration: const InputDecoration(
                                        labelText: 'Job description',
                                        alignLabelWithHint: true)),
                                const SizedBox(height: 14),
                                TextFormField(
                                    initialValue: state.motivation,
                                    minLines: 3,
                                    maxLines: 5,
                                    onChanged: (value) =>
                                        cubit.update(motivation: value),
                                    decoration: const InputDecoration(
                                        labelText: 'Why this role? (optional)',
                                        alignLabelWithHint: true)),
                                const SizedBox(height: 16),
                                Text('Tone',
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Wrap(
                                    spacing: 8,
                                    children: ['professional', 'warm', 'direct']
                                        .map((tone) => ChoiceChip(
                                            label: Text(tone[0].toUpperCase() +
                                                tone.substring(1)),
                                            selected: state.tone == tone,
                                            onSelected: (_) =>
                                                cubit.update(tone: tone)))
                                        .toList()),
                                const SizedBox(height: 22),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                        onPressed: state.status ==
                                                CoverLetterStatus.generating
                                            ? null
                                            : cubit.generate,
                                        icon: const Icon(
                                            Icons.auto_awesome_outlined),
                                        label: Text(state.status ==
                                                CoverLetterStatus.generating
                                            ? 'Generating...'
                                            : 'Generate cover letter'))),
                                if (state.letter != null) ...[
                                  const SizedBox(height: 30),
                                  _LetterEditor(
                                      letter: state.letter!,
                                      onChanged: cubit.updateLetter),
                                  const SizedBox(height: 14),
                                  Row(children: [
                                    Expanded(
                                        child: OutlinedButton.icon(
                                            onPressed: state.status ==
                                                    CoverLetterStatus.exporting
                                                ? null
                                                : () => cubit.export('docx'),
                                            icon: const Icon(
                                                Icons.description_outlined),
                                            label: const Text('DOCX'))),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: ElevatedButton.icon(
                                            onPressed: state.status ==
                                                    CoverLetterStatus.exporting
                                                ? null
                                                : () => cubit.export('pdf'),
                                            icon: const Icon(
                                                Icons.picture_as_pdf_outlined),
                                            label: const Text('PDF')))
                                  ])
                                ],
                                const SizedBox(height: 34),
                                const _Explainer(),
                              ]))));
        },
      );
}

class _ResumeStatus extends StatelessWidget {
  const _ResumeStatus({required this.available, this.name});
  final bool available;
  final String? name;
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: available ? const Color(0xFFEDF4E9) : const Color(0xFFFFF4E5),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Icon(available ? Icons.check_circle_outline : Icons.info_outline,
            color: AppColors.green),
        const SizedBox(width: 10),
        Expanded(
            child: Text(available
                ? 'Using saved resume for $name.'
                : 'No saved resume found. Build your resume first, then return here.'))
      ]));
}

class _LetterEditor extends StatelessWidget {
  const _LetterEditor({required this.letter, required this.onChanged});
  final CoverLetter letter;
  final ValueChanged<CoverLetter> onChanged;
  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
          padding: AppInsets.card,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Editable draft',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextFormField(
                initialValue: letter.greeting,
                onChanged: (value) =>
                    onChanged(letter.copyWith(greeting: value))),
            ...List.generate(
                letter.paragraphs.length,
                (index) => Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                        initialValue: letter.paragraphs[index],
                        minLines: 3,
                        maxLines: 7,
                        onChanged: (value) {
                          final paragraphs = [...letter.paragraphs];
                          paragraphs[index] = value;
                          onChanged(letter.copyWith(paragraphs: paragraphs));
                        }))),
            const SizedBox(height: 12),
            TextFormField(
                initialValue: letter.closing,
                onChanged: (value) =>
                    onChanged(letter.copyWith(closing: value))),
          ])));
}

class _Explainer extends StatelessWidget {
  const _Explainer();
  @override
  Widget build(BuildContext context) => Container(
      padding: AppInsets.card,
      decoration: BoxDecoration(
          color: AppColors.darkGreen, borderRadius: BorderRadius.circular(16)),
      child:
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('What a cover letter adds',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        SizedBox(height: 8),
        Text(
            'It connects the most relevant resume evidence to one specific role, gives you room to explain your interest, and helps you personalize an application.',
            style: TextStyle(color: Color(0xFFC2CEC8), height: 1.5))
      ]));
}
