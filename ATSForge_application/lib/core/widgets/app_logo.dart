import 'package:flutter/material.dart';

import '../resources/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 42, this.showName = true, this.label});
  final double size;
  final bool showName;
  final String? label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppAssets.logo, width: size),
          if (showName) ...[
            const SizedBox(width: 9),
            Text(label ?? 'ATSForge',
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ],
      );
}
