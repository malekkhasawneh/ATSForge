import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';

class TemplateCard extends StatelessWidget {
  const TemplateCard(
      {required this.id,
      required this.name,
      required this.description,
      required this.color,
      required this.onSelect,
      super.key});
  final String id, name, description;
  final Color color;
  final VoidCallback onSelect;
  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: onSelect,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AspectRatio(
                aspectRatio: 1.55,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFE5E9E3),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      child: Column(
                          crossAxisAlignment:
                              id == 'professional' || id == 'executive'
                                  ? CrossAxisAlignment.center
                                  : CrossAxisAlignment.start,
                          children: [
                            Container(width: 90, height: 8, color: color),
                            const SizedBox(height: 9),
                            Container(
                                width: 135, height: 4, color: AppColors.line),
                            const SizedBox(height: 20),
                            ...List.generate(
                                3,
                                (index) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 70,
                                              height: 5,
                                              color: color),
                                          const SizedBox(height: 5),
                                          Container(
                                              height: 3, color: AppColors.line),
                                          const SizedBox(height: 3),
                                          FractionallySizedBox(
                                              widthFactor: .76,
                                              child: Container(
                                                  height: 3,
                                                  color: AppColors.line))
                                        ]))),
                          ])),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(name,
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(description)
                        ])),
                    const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.green)
                  ])),
            ])),
      );
}
