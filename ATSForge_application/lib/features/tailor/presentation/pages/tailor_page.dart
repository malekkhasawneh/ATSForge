import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_insets.dart';
import '../../../../core/widgets/ats_app_bar.dart';
import '../../../../core/widgets/async_button.dart';
import '../cubit/tailor_cubit.dart';
import '../widgets/file_picker_card.dart';
import '../widgets/tailor_result_view.dart';

class TailorPage extends StatelessWidget {
  const TailorPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const ATSAppBar(title: 'Tailor'),
        body: BlocBuilder<TailorCubit, TailorState>(builder: (context, state) {
          final cubit = context.read<TailorCubit>();
          return SingleChildScrollView(
              padding: AppInsets.page,
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('EVIDENCE-CONSTRAINED TAILORING',
                                style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.3)),
                            const SizedBox(height: 10),
                            Text('Tailor your résumé to the role.',
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                            const SizedBox(height: 8),
                            const Text(
                                'Improve relevance and ATS readability while keeping every claim grounded in your real experience.'),
                            const SizedBox(height: 24),
                            Card(
                                child: Padding(
                                    padding: AppInsets.card,
                                    child: state.status ==
                                                TailorStatus.success &&
                                            state.result != null
                                        ? TailorResultView(
                                            result: state.result!,
                                            onReset: cubit.reset)
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                                Text('1  Upload your résumé',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge),
                                                const SizedBox(height: 5),
                                                const Text(
                                                    'Microsoft Word .docx, up to 5 MB'),
                                                const SizedBox(height: 13),
                                                FilePickerCard(
                                                    title:
                                                        'Choose your Word résumé',
                                                    subtitle: 'DOCX only',
                                                    filename: state.resumeFile
                                                        ?.uri.pathSegments.last,
                                                    onTap: cubit.pickResume),
                                                const SizedBox(height: 24),
                                                Text(
                                                    '2  Add the job description',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge),
                                                const SizedBox(height: 13),
                                                FilePickerCard(
                                                    title:
                                                        'Upload job description DOCX',
                                                    subtitle:
                                                        'Optional—pasting below also works',
                                                    filename: state.jobFile?.uri
                                                        .pathSegments.last,
                                                    onTap: cubit.pickJobFile),
                                                const SizedBox(height: 13),
                                                TextFormField(
                                                    initialValue:
                                                        state.jobDescription,
                                                    onChanged:
                                                        cubit.updateDescription,
                                                    minLines: 7,
                                                    maxLines: 12,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText:
                                                                'Paste the complete job description',
                                                            alignLabelWithHint:
                                                                true)),
                                                const SizedBox(height: 12),
                                                CheckboxListTile(
                                                    value: state.consent,
                                                    onChanged: (v) =>
                                                        cubit.updateConsent(
                                                            v ?? false),
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                    title: const Text(
                                                        'I understand my documents are processed for this request and, when AI mode is enabled, extracted text is sent to the configured inference provider.',
                                                        style: TextStyle(
                                                            fontSize: 12))),
                                                if (state.message != null)
                                                  Container(
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 12,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFFFF0ED),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Text(
                                                          state.message!,
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .danger))),
                                                SizedBox(
                                                    width: double.infinity,
                                                    child: AsyncButton(
                                                        label:
                                                            'Tailor my résumé',
                                                        loading: state.status ==
                                                            TailorStatus
                                                                .submitting,
                                                        onPressed:
                                                            state.canSubmit
                                                                ? cubit.submit
                                                                : null,
                                                        icon: Icons
                                                            .auto_fix_high)),
                                                const SizedBox(height: 10),
                                                const Center(
                                                    child: Text(
                                                        'Connected securely to ${AppConstants.apiBaseUrl}',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .muted))),
                                              ]))),
                            const SizedBox(height: 20),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 16),
                                decoration: BoxDecoration(
                                    color: AppColors.darkGreen,
                                    borderRadius: BorderRadius.circular(14)),
                                child: const Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.shield_outlined,
                                          color: AppColors.lime),
                                      SizedBox(width: 12),
                                      Expanded(
                                          child: Text(
                                              'Tailoring can improve wording and relevance. It cannot create experience you do not have, guarantee an interview, or reproduce an employer’s private screening system.',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1.5)))
                                    ])),
                          ]))));
        }),
      );
}
