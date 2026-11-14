import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/menu/data/datasources/menu_remote_datasource.dart';
import 'features/menu/data/repositories/menu_repository_impl.dart';
import 'features/menu/domain/repositories/menu_repository.dart';
import 'features/menu/presentation/bloc/menu_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerLazySingleton<MenuRemoteDataSource>(() => MenuRemoteDataSource());
  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(sl()));
  sl.registerFactory(() => MenuBloc(sl()));
}