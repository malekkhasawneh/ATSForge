import 'package:flutter/material.dart';

import '../../../../core/design_system/app_colors.dart';

class FilePickerCard extends StatelessWidget {
  const FilePickerCard(
      {required this.title,
      required this.subtitle,
      required this.onTap,
      super.key,
      this.filename});
  final String title, subtitle;
  final String? filename;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
                color: const Color(0xFFF8FAF6),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                    color:
                        filename == null ? AppColors.line : AppColors.success,
                    width: 1.4)),
            child: Row(children: [
              Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.description_outlined,
                      color: Colors.white)),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(filename ?? title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: const TextStyle(fontSize: 12))
                  ])),
              Icon(
                  filename == null
                      ? Icons.upload_file_outlined
                      : Icons.check_circle,
                  color:
                      filename == null ? AppColors.green : AppColors.success),
            ])),
      );
}
