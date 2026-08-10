import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_insets.dart';
import '../../../../core/widgets/ats_app_bar.dart';
import '../widgets/template_card.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});
  static const templates = [
    (
      'professional',
      'Professional',
      'Balanced, centered, and versatile.',
      Color(0xFF18221D)
    ),
    (
      'modern',
      'Modern',
      'Confident green accents and left alignment.',
      Color(0xFF235F47)
    ),
    (
      'minimal',
      'Minimal',
      'Quiet typography with restrained detail.',
      Color(0xFF333333)
    ),
    (
      'executive',
      'Executive',
      'Classic serif character for senior roles.',
      Color(0xFF20354A)
    ),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const ATSAppBar(title: 'Templates'),
        body: LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth >= 900
              ? 4
              : constraints.maxWidth >= 600
                  ? 2
                  : 1;
          return SingleChildScrollView(
              padding: AppInsets.page,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ATS-SAFE DESIGNS',
                        style: TextStyle(
                            color: AppColors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3)),
                    const SizedBox(height: 10),
                    Text('Professional structure. Your voice.',
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    const Text(
                        'Every design uses one column, familiar headings, selectable text, and ordinary bullets.'),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: templates.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          childAspectRatio: columns == 1 ? 1.05 : .78,
                          crossAxisSpacing: 15.w,
                          mainAxisSpacing: 15.h),
                      itemBuilder: (_, index) {
                        final item = templates[index];
                        return TemplateCard(
                            id: item.$1,
                            name: item.$2,
                            description: item.$3,
                            color: item.$4,
                            onSelect: () => Navigator.pushReplacementNamed(
                                context, AppRoutes.builder,
                                arguments: item.$1));
                      },
                    ),
                  ]));
        }),
      );
}
