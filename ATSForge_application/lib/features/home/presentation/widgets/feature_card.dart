import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard(
      {required this.icon,
      required this.title,
      required this.description,
      required this.onTap,
      super.key});
  final IconData icon;
  final String title, description;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Row(children: [
              Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(.1),
                      borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: AppColors.green)),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 5),
                    Text(description)
                  ])),
              const Icon(Icons.arrow_forward_rounded, color: AppColors.green),
            ]),
          ),
        ),
      );
}
