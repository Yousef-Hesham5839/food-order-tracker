import 'package:get_it/get_it.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/menu/data/datasources/menu_remote_datasource.dart';
import 'features/menu/data/repositories/menu_repository_impl.dart';
import 'features/menu/domain/repositories/menu_repository.dart';
import 'features/menu/presentation/bloc/menu_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/orders/data/datasources/order_remote_datasource.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/domain/repositories/order_repository.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerLazySingleton<MenuRemoteDataSource>(() => MenuRemoteDataSource());
  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(sl()));
  sl.registerFactory(() => MenuBloc(sl()));
  sl.registerLazySingleton(() => CartBloc());
  sl.registerLazySingleton<OrderRemoteDataSource>(() => OrderRemoteDataSource());
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(sl()));
  sl.registerFactory(() => OrderBloc(sl()));
}