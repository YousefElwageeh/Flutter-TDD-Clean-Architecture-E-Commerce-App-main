import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/category/data/models/category_model.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart'
    as pm;
import 'package:eshop/features/product/domain/usecases/get_product_usecase.dart';
import 'package:eshop/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:eshop/features/product/presentation/bloc/product_bloc.dart';
import 'package:eshop/features/auth/presentation/pages/forget_password.dart';
import 'package:eshop/features/category/presentation/pages/category_view.dart';
import 'package:eshop/features/home/presentation/pages/filter/filter_view.dart';
import 'package:eshop/features/order_chekout/presentation/pages/pickup_screen.dart';
import 'package:eshop/features/product/presentation/pages/proudcuts_by_category_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/cart/domain/entities/cart_item.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/pages/signin_view.dart';
import '../../features/auth/presentation/pages/signup_view.dart';
import '../../features/home/presentation/pages/main_view.dart';
import '../../features/profile/presentation/pages/about_view.dart';
import '../../features/delivery/presentation/pages/delivery_info.dart';
import '../../features/profile/presentation/pages/notification_view.dart';
import '../../features/order/presentation/pages/order_view.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/settings_view.dart';
import '../../features/order_chekout/presentation/pages/order_checkout_view.dart';
import '../../features/product/presentation/pages/product_details_view.dart';
import '../error/exceptions.dart';

class AppRouter {
  //main menu
  static const String home = '/';
  //authentication
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  //products
  static const String productDetails = '/product-details';
  //other
  static const String userProfile = '/user-profile';
  static const String orderCheckout = '/order-checkout';
  static const String deliveryDetails = '/delivery-details';
  static const String orders = '/orders';
  static const String settings = '/settings';
  static const String proudcutsByCategory = '/proudcutsByCategory';
  static const String category = '/category';
  static const String forgetPassword = '/ForgetPassword';
  static const String pickUp = '/pickUp';

  static const String notifications = '/notifications';
  static const String about = '/about';
  static const String filter = '/filter';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainView());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInView());
      case category:
        return MaterialPageRoute(builder: (_) => const CategoryView());
      case proudcutsByCategory:
        int categoryID = routeSettings.arguments as int;

        return MaterialPageRoute(
            builder: (_) => ProductsByCatrgory(
                  categoryID: categoryID,
                ),
            settings: RouteSettings(arguments: routeSettings.arguments));
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case productDetails:
        pm.Product product = routeSettings.arguments as pm.Product;
        return MaterialPageRoute(
            builder: (_) => ProductDetailsView(product: product));
      case userProfile:
        User user = routeSettings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => ProfileCubit(),
                  child: UserProfileScreen(
                    user: user,
                  ),
                ));
      case orderCheckout:
        List<Cart> items = routeSettings.arguments as List<Cart>;
        return MaterialPageRoute(
            builder: (_) => OrderCheckoutView(
                  items: items,
                ));
      case deliveryDetails:
        return MaterialPageRoute(builder: (_) => const DeliveryInfoView());
      case orders:
        return MaterialPageRoute(builder: (_) => const OrderView());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationView());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutView());
      case filter:
        return MaterialPageRoute(builder: (_) => const FilterView());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordScreen());
      case pickUp:
        return MaterialPageRoute(builder: (_) => const PickUpScreen());
      default:
        throw const RouteException('Route not found!');
    }
  }
}
