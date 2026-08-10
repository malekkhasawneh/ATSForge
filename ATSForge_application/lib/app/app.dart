import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/constants/app_constants.dart';
import '../core/design_system/app_theme.dart';
import '../features/connectivity/presentation/cubit/connectivity_cubit.dart';
import '../features/connectivity/presentation/widgets/connectivity_banner.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/resume_builder/presentation/cubit/resume_builder_cubit.dart';
import '../features/resume_builder/presentation/pages/resume_builder_page.dart';
import '../features/tailor/presentation/cubit/tailor_cubit.dart';
import '../features/tailor/presentation/pages/tailor_page.dart';
import '../features/templates/presentation/pages/templates_page.dart';
import '../injection_container.dart';
import 'app_routes.dart';

class ATSForgeApp extends StatelessWidget {
  const ATSForgeApp({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => sl<ConnectivityCubit>()..start(),
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            builder: (context, child) => Column(children: [
              const ConnectivityBanner(),
              Expanded(child: child ?? const SizedBox.shrink())
            ]),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case AppRoutes.templates:
                  return MaterialPageRoute<void>(
                      builder: (_) => const TemplatesPage());
                case AppRoutes.builder:
                  final template = settings.arguments as String?;
                  return MaterialPageRoute<void>(
                      builder: (_) => BlocProvider(
                          create: (_) => sl<ResumeBuilderCubit>()
                            ..initialize(template: template),
                          child: const ResumeBuilderPage()));
                case AppRoutes.tailor:
                  return MaterialPageRoute<void>(
                      builder: (_) => BlocProvider(
                          create: (_) => sl<TailorCubit>(),
                          child: const TailorPage()));
                default:
                  return MaterialPageRoute<void>(
                      builder: (_) => const HomePage());
              }
            },
          ),
        ),
      );
}
