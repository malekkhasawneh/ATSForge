import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/app_colors.dart';
import '../cubit/connectivity_cubit.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          if (state.status != ConnectionStatus.offline) {
            return const SizedBox.shrink();
          }
          return Material(
            color: AppColors.ink,
            child: SafeArea(
              bottom: false,
              child: InkWell(
                onTap: context.read<ConnectivityCubit>().check,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off_rounded,
                            color: Colors.white, size: 17),
                        SizedBox(width: 8),
                        Flexible(
                            child: Text(
                                'Offline — drafts still work. Tap to reconnect.',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))),
                      ]),
                ),
              ),
            ),
          );
        },
      );
}
