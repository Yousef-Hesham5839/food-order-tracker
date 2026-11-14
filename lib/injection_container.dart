import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => AuthBloc(sl()));
}