import 'dart:developer';

import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/core/Bloc_observer.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constant/strings.dart';
import 'core/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/category/presentation/bloc/category_bloc.dart';
import 'features/delivery/presentation/bloc/delivery_info_action/delivery_info_action_cubit.dart';
import 'features/delivery/presentation/bloc/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import 'features/home/presentation/bloc/filter_cubit.dart';

import 'core/services/services_locator.dart' as di;
import 'features/home/presentation/bloc/navbar_cubit.dart';
import 'features/order/presentation/bloc/order_fetch/order_fetch_cubit.dart';
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/profile/presentation/bloc/user/user_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await di.init();
  log(Constants.token ?? "");
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('ar', AppLocale.AR),
      ],
      initLanguageCode: 'ar',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavbarCubit(),
        ),
        BlocProvider(
          create: (context) => FilterCubit(),
        ),
        BlocProvider(
          create: (context) => di.sl<ProductBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CategoryBloc>()
            ..add(const GetCategories())
            ..getSliders(),
        ),
        BlocProvider(
          create: (context) => di.sl<CartBloc>()..add(const GetCart()),
        ),
        BlocProvider(
          create: (context) => di.sl<UserBloc>()..add(CheckUser()),
        ),
        BlocProvider(
          create: (context) => di.sl<DeliveryInfoActionCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              di.sl<DeliveryInfoFetchCubit>()..fetchDeliveryInfo(),
        ),
        BlocProvider(
          create: (context) => di.sl<OrderFetchCubit>()..getOrders(),
        ),
      ],
      child: OKToast(
        child: MaterialApp(
          supportedLocales: localization.supportedLocales,
          localizationsDelegates: localization.localizationsDelegates,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRouter.home,
          onGenerateRoute: AppRouter.onGenerateRoute,
          title: appTitle,
          theme: AppTheme.lightTheme,
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = true;
}
