import 'package:eshop/core/api/app_interceptors.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/features/profile/data/datasources/profile_data_source.dart';
import 'package:eshop/features/profile/data/datasources/profile_repo_impl.dart';
import 'package:eshop/features/delivery/domain/usecases/clear_local_delivery_info_usecase.dart';
import 'package:eshop/features/delivery/domain/usecases/edit_delivery_info_usecase.dart';
import 'package:eshop/features/delivery/domain/usecases/get_selected_delivery_info_usecase.dart';
import 'package:eshop/features/delivery/domain/usecases/select_delivery_info_usecase.dart';
import 'package:eshop/features/order_chekout/domain/usecases/clear_local_order_usecase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/category/data/datasources/category_local_data_source.dart';
import '../../features/delivery/data/datasources/delivery_info_local_data_source.dart';
import '../../features/order_chekout/data/datasources/order_local_data_source.dart';
import '../../features/product/data/datasources/product_local_data_source.dart';
import '../../features/auth/data/datasources/user_local_data_source.dart';
import '../../features/cart/data/datasources/cart_remote_data_source.dart';
import '../../features/category/data/datasources/category_remote_data_source.dart';
import '../../features/delivery/data/datasources/delivery_info_remote_data_source.dart';
import '../../features/order_chekout/data/datasources/order_remote_data_source.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/auth/data/datasources/user_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/category/data/repositories/category_repository_impl.dart';
import '../../features/delivery/data/repositories/delivery_info_impl.dart';
import '../../features/order_chekout/data/repositories/order_repository_impl.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/auth/data/repositories/user_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/delivery/domain/repositories/delivery_info_repository.dart';
import '../../features/order_chekout/domain/repositories/order_repository.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/auth/domain/repositories/user_repository.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/domain/usecases/sync_cart_usecase.dart';
import '../../features/category/domain/usecases/filter_category_usecase.dart';
import '../../features/category/domain/usecases/get_cached_category_usecase.dart';
import '../../features/category/domain/usecases/get_remote_category_usecase.dart';
import '../../features/delivery/domain/usecases/add_dilivey_info_usecase.dart';
import '../../features/delivery/domain/usecases/get_cached_delivery_info_usecase.dart';
import '../../features/delivery/domain/usecases/get_remote_delivery_info_usecase.dart';
import '../../features/order_chekout/domain/usecases/add_order_usecase.dart';
import '../../features/order_chekout/domain/usecases/get_cached_orders_usecase.dart';
import '../../features/order_chekout/domain/usecases/get_remote_orders_usecase.dart';
import '../../features/product/domain/usecases/get_product_usecase.dart';
import '../../features/auth/domain/usecases/get_cached_user_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_usecase.dart';
import '../../features/auth/domain/usecases/sign_out_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_usecase.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/category/presentation/bloc/category_bloc.dart';
import '../../features/delivery/presentation/bloc/delivery_info_action/delivery_info_action_cubit.dart';
import '../../features/delivery/presentation/bloc/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../features/order/presentation/bloc/order_add/order_add_cubit.dart';
import '../../features/order/presentation/bloc/order_fetch/order_fetch_cubit.dart';
import '../../features/product/presentation/bloc/product_bloc.dart';
import '../../features/profile/presentation/bloc/user/user_bloc.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Features - Product
  // Bloc Get.lazyPut<FlutterSecureStorage>(

  sl.registerFactory(
    () => ProductBloc(sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetProductUseCase(sl()));
  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //Features - Category
  // Bloc
  sl.registerFactory(
    () => CategoryBloc(sl(), sl(), sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetRemoteCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedCategoryUseCase(sl()));
  sl.registerLazySingleton(() => FilterCategoryUseCase(sl()));
  // Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //Features - Cart
  // Bloc
  sl.registerFactory(
    () => CartBloc(
      sl(),
      sl(),
      //   sl(),
    ),
  );
  // Use cases
  // sl.registerLazySingleton(() => GetCachedCartUseCase(sl()));
  // sl.registerLazySingleton(() => AddCartUseCase(sl()));
  sl.registerLazySingleton(() => SyncCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));
  // Repository
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      userLocalDataSource: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //Features - Delivery Info
  // Bloc
  sl.registerFactory(
    () => DeliveryInfoActionCubit(sl(), sl(), sl()),
  );
  sl.registerFactory(
    () => DeliveryInfoFetchCubit(sl(), sl(), sl(), sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetRemoteDeliveryInfoUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedDeliveryInfoUseCase(sl()));
  sl.registerLazySingleton(() => AddDeliveryInfoUseCase(sl()));
  sl.registerLazySingleton(() => EditDeliveryInfoUseCase(sl()));
  sl.registerLazySingleton(() => SelectDeliveryInfoUseCase(sl()));
  sl.registerLazySingleton(() => GetSelectedDeliveryInfoInfoUseCase(sl()));
  sl.registerLazySingleton(() => ClearLocalDeliveryInfoUseCase(sl()));
  // Repository
  sl.registerLazySingleton<DeliveryInfoRepository>(
    () => DeliveryInfoRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      userLocalDataSource: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<DeliveryInfoRemoteDataSource>(
    () => DeliveryInfoRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<DeliveryInfoLocalDataSource>(
    () => DeliveryInfoLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //Features - Order
  // Bloc
  sl.registerFactory(
    () => OrderAddCubit(sl()),
  );
  sl.registerFactory(
    () => OrderFetchCubit(sl(), sl(), sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => AddOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetRemoteOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedOrdersUseCase(sl()));
  sl.registerLazySingleton(() => ClearLocalOrdersUseCase(sl()));
  // Repository
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      userLocalDataSource: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //Features - User
  // Bloc
  sl.registerFactory(
    () => UserBloc(sl(), sl(), sl(), sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton(() => ProfileRemoteDataSourceImpl());
  sl.registerLazySingleton(() => ProfileRepoImplmenter(
      profileRemoteDataSource: sl(), localDataSource: sl()));

  ///***********************************************
  ///! Core
  /// sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  ///! External
  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => secureStorage);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<AppIntercepters>(() => AppIntercepters());
  Constants.token =
      await sl<FlutterSecureStorage>().read(key: Constants.tokenKey);
  DioFactory.getDio();
}
