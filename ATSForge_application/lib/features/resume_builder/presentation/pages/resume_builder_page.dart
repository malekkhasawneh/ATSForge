import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_insets.dart';
import '../../../../core/helpers/file_helper.dart';
import '../../../../core/widgets/ats_app_bar.dart';
import '../cubit/resume_builder_cubit.dart';
import '../widgets/education_form.dart';
import '../widgets/experience_form.dart';
import '../widgets/profile_form.dart';
import '../widgets/resume_preview.dart';
import '../widgets/review_form.dart';
import '../widgets/skills_form.dart';

class ResumeBuilderPage extends StatelessWidget {
  const ResumeBuilderPage({super.key});
  static const labels = [
    'Profile',
    'Experience',
    'Education',
    'Skills',
    'Review'
  ];

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<ResumeBuilderCubit, ResumeBuilderState>(
        listenWhen: (previous, current) =>
            previous.message != current.message ||
            previous.exportedFile?.path != current.exportedFile?.path,
        listener: (context, state) async {
          if (state.exportedFile != null) {
            final saved = await FileHelper.saveToDevice(state.exportedFile!);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(saved
                      ? 'Résumé saved successfully.'
                      : 'Saving was cancelled.')));
            }
          } else if (state.message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          if (state.status == ResumeBuilderStatus.loading) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          final cubit = context.read<ResumeBuilderCubit>();
          return Scaffold(
            appBar: ATSAppBar(title: 'Builder', actions: [
              PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'clear') _confirmClear(context);
                  },
                  itemBuilder: (_) => const [
                        PopupMenuItem(
                            value: 'clear', child: Text('Start a new résumé'))
                      ])
            ]),
            body: LayoutBuilder(builder: (context, constraints) {
              final editor = _Editor(state: state);
              final preview = Container(
                  color: AppColors.mist,
                  padding: AppInsets.page,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ResumePreview(resume: state.resume)));
              if (constraints.maxWidth >= 1050) {
                return Row(children: [
                  SizedBox(width: 190, child: _Steps(current: state.step)),
                  Expanded(child: editor),
                  Expanded(child: preview)
                ]);
              }
              return Column(children: [
                _Steps(current: state.step, horizontal: true),
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(children: [
                  editor,
                  ExpansionTile(
                      title: const Text('Live résumé preview'),
                      leading: const Icon(Icons.visibility_outlined),
                      children: [preview])
                ])))
              ]);
            }),
            bottomNavigationBar: SafeArea(
                top: false,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: AppColors.line))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: Row(children: [
                      TextButton(
                          onPressed: state.step == 0 ? null : cubit.previous,
                          child: const Text('← Back')),
                      const Spacer(),
                      Text('${state.step + 1} / 5',
                          style: const TextStyle(color: AppColors.muted)),
                      const Spacer(),
                      if (state.step < 4)
                        ElevatedButton(
                            onPressed: cubit.next,
                            child: const Text('Continue →'))
                      else
                        Row(children: [
                          OutlinedButton(
                              onPressed:
                                  state.status == ResumeBuilderStatus.exporting
                                      ? null
                                      : () => _showPreview(context, state),
                              child: const Text('Preview')),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  foregroundColor: Colors.white,
                                  side:
                                      const BorderSide(color: AppColors.green)),
                              onPressed:
                                  state.status == ResumeBuilderStatus.exporting
                                      ? null
                                      : () => _chooseSaveFormat(context),
                              icon: const Icon(Icons.save_alt_rounded),
                              label: Text(
                                  state.status == ResumeBuilderStatus.exporting
                                      ? 'Preparing…'
                                      : 'Save'))
                        ]),
                    ]))),
          );
        },
      );

  Future<void> _showPreview(
      BuildContext context, ResumeBuilderState state) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (previewContext) => Scaffold(
              appBar: AppBar(
                title: const Text('Résumé preview'),
                leading: IconButton(
                    onPressed: () => Navigator.pop(previewContext),
                    icon: const Icon(Icons.close_rounded)),
              ),
              backgroundColor: AppColors.mist,
              body: SafeArea(
                  child: SingleChildScrollView(
                      padding: AppInsets.page,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ResumePreview(resume: state.resume)))),
            )));
  }

  Future<void> _chooseSaveFormat(BuildContext context) async {
    final type = await showModalBottomSheet<String>(
        context: context,
        builder: (sheetContext) => SafeArea(
              child: Padding(
                padding: AppInsets.card,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Save résumé to mobile',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 6),
                    const Text('Choose the file format you want to save.'),
                    const SizedBox(height: 18),
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf_outlined),
                      title: const Text('PDF document'),
                      subtitle: const Text('Best for applications and sharing'),
                      onTap: () => Navigator.pop(sheetContext, 'pdf'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Editable Word document'),
                      subtitle: const Text('DOCX format for future editing'),
                      onTap: () => Navigator.pop(sheetContext, 'docx'),
                    ),
                  ],
                ),
              ),
            ));
    if (type != null && context.mounted) {
      context.read<ResumeBuilderCubit>().export(type);
    }
  }

  Future<void> _confirmClear(BuildContext context) async {
    final accepted = await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
                    title: const Text('Start over?'),
                    content: const Text(
                        'This removes the locally saved draft from this device.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text('Clear draft'))
                    ])) ??
        false;
    if (accepted && context.mounted) {
      context.read<ResumeBuilderCubit>().clearDraft();
    }
  }
}

class _Steps extends StatelessWidget {
  const _Steps({required this.current, this.horizontal = false});
  final int current;
  final bool horizontal;
  @override
  Widget build(BuildContext context) {
    final children = List.generate(
        ResumeBuilderPage.labels.length,
        (index) => InkWell(
            onTap: () => context.read<ResumeBuilderCubit>().goToStep(index),
            child: Container(
                width: horizontal ? 72 : null,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                    color: current == index
                        ? const Color(0xFFE7EFE8)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10)),
                child: horizontal
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            CircleAvatar(
                                radius: 13,
                                backgroundColor: current == index
                                    ? AppColors.green
                                    : AppColors.line,
                                foregroundColor: current == index
                                    ? Colors.white
                                    : AppColors.ink,
                                child: Text('${index + 1}',
                                    style: const TextStyle(fontSize: 10))),
                            const SizedBox(height: 3),
                            Text(ResumeBuilderPage.labels[index],
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 9))
                          ])
                    : Row(children: [
                        CircleAvatar(
                            radius: 14,
                            backgroundColor: current == index
                                ? AppColors.green
                                : AppColors.line,
                            foregroundColor:
                                current == index ? Colors.white : AppColors.ink,
                            child: Text('${index + 1}',
                                style: const TextStyle(fontSize: 11))),
                        const SizedBox(width: 9),
                        Text(ResumeBuilderPage.labels[index],
                            style: const TextStyle(fontWeight: FontWeight.w600))
                      ]))));
    return Container(
        color: const Color(0xFFF7F8F5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: horizontal
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: children),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children));
  }
}

class _Editor extends StatelessWidget {
  const _Editor({required this.state});
  final ResumeBuilderState state;
  @override
  Widget build(BuildContext context) {
    final form = switch (state.step) {
      0 => const ProfileForm(),
      1 => const ExperienceForm(),
      2 => const EducationForm(),
      3 => const SkillsForm(),
      _ => const ReviewForm()
    };
    return Container(color: Colors.white, padding: AppInsets.page, child: form);
  }
}
