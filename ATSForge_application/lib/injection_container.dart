import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/storage/draft_storage.dart';
import 'features/connectivity/presentation/cubit/connectivity_cubit.dart';
import 'features/resume_builder/data/datasources/resume_local_data_source.dart';
import 'features/resume_builder/data/datasources/resume_remote_data_source.dart';
import 'features/resume_builder/data/repositories/resume_repository_impl.dart';
import 'features/resume_builder/domain/repositories/resume_repository.dart';
import 'features/resume_builder/presentation/cubit/resume_builder_cubit.dart';
import 'features/tailor/data/datasources/tailor_remote_data_source.dart';
import 'features/tailor/data/repositories/tailor_repository_impl.dart';
import 'features/tailor/domain/repositories/tailor_repository.dart';
import 'features/tailor/presentation/cubit/tailor_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final preferences = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => preferences)
    ..registerLazySingleton(ApiClient.new)
    ..registerLazySingleton(Connectivity.new)
    ..registerLazySingleton(() => DraftStorage(sl()))
    ..registerLazySingleton(() => ResumeLocalDataSource(sl()))
    ..registerLazySingleton(() => ResumeRemoteDataSource(sl()))
    ..registerLazySingleton<ResumeRepository>(
        () => ResumeRepositoryImpl(sl(), sl()))
    ..registerLazySingleton(() => TailorRemoteDataSource(sl()))
    ..registerLazySingleton<TailorRepository>(() => TailorRepositoryImpl(sl()))
    ..registerFactory(() => ConnectivityCubit(sl(), sl()))
    ..registerFactory(() => ResumeBuilderCubit(sl()))
    ..registerFactory(() => TailorCubit(sl()));
}
