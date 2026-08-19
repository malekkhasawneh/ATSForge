import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_insets.dart';
import '../../../../core/widgets/ats_app_bar.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ATSAppBar(showLogo: true, actions: [
          IconButton(
              tooltip: 'Privacy',
              onPressed: () => launchUrl(Uri.parse(AppConstants.privacyUrl),
                  mode: LaunchMode.externalApplication),
              icon: const Icon(Icons.shield_outlined))
        ]),
        body: SafeArea(
            child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                      padding: constraints.maxWidth > 700
                          ? EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * .15,
                              vertical: 32.h)
                          : AppInsets.page,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 26),
                              decoration: BoxDecoration(
                                  color: AppColors.darkGreen,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                        'ATS-FRIENDLY. PRIVATE BY DESIGN.',
                                        style: TextStyle(
                                            color: AppColors.lime,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.4)),
                                    const SizedBox(height: 18),
                                    Text('Your story, clearly qualified.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize:
                                                    constraints.maxWidth < 500
                                                        ? 38
                                                        : 52)),
                                    const SizedBox(height: 14),
                                    const Text(
                                        'Build a focused résumé, check its readiness, tailor it honestly, and export professional Word or PDF files.',
                                        style: TextStyle(
                                            color: Color(0xFFC2CEC8),
                                            fontSize: 16,
                                            height: 1.5)),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                        onPressed: () => Navigator.pushNamed(
                                            context, AppRoutes.templates),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.lime,
                                            foregroundColor: AppColors.ink),
                                        child: const Text('Start building  →')),
                                  ]),
                            ),
                            const SizedBox(height: 30),
                            Text('What would you like to do?',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 14),
                            FeatureCard(
                                icon: Icons.description_outlined,
                                title: 'Build a résumé',
                                description:
                                    'Create, preview, review, and export an ATS-readable résumé.',
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.templates)),
                            const SizedBox(height: 12),
                            FeatureCard(
                                icon: Icons.auto_fix_high_outlined,
                                title: 'Tailor an existing résumé',
                                description:
                                    'Match your DOCX résumé to a job description without inventing experience.',
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.tailor)),
                            const SizedBox(height: 12),
                            FeatureCard(
                                icon: Icons.markunread_mailbox_outlined,
                                title: 'Create a cover letter',
                                description:
                                    'Connect your saved resume to a specific role with an editable draft.',
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.coverLetter)),
                            const SizedBox(height: 28),
                            const Row(children: [
                              Icon(Icons.lock_outline_rounded,
                                  size: 18, color: AppColors.green),
                              SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                      'Drafts stay on this device. Uploaded documents are processed only for your request.'))
                            ]),
                          ]),
                    ))),
      );
}
