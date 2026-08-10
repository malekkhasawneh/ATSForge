import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_logo.dart';

class ATSAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ATSAppBar(
      {super.key, this.title, this.actions = const [], this.showLogo = false});
  final String? title;
  final List<Widget> actions;
  final bool showLogo;

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: false,
        titleSpacing: 16.w,
        title: Align(
          alignment: Alignment.centerLeft,
          child: showLogo
              ? AppLogo(size: 36.r, label: title)
              : Text(title ?? '',
                  style: Theme.of(context).textTheme.titleLarge),
        ),
        actions: [
          ...actions.map(
              (action) => Align(alignment: Alignment.center, child: action)),
          SizedBox(width: 8.w),
        ],
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
