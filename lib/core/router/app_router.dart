import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';
import 'package:eshop/data/models/category/category_model.dart';
import 'package:eshop/data/models/product/product_response_model.dart' as pm;
import 'package:eshop/domain/usecases/product/get_product_usecase.dart';
import 'package:eshop/presentation/blocs/cubit/profile_cubit.dart';
import 'package:eshop/presentation/blocs/product/product_bloc.dart';
import 'package:eshop/presentation/views/authentication/forget_password.dart';
import 'package:eshop/presentation/views/main/category/category_view.dart';
import 'package:eshop/presentation/views/main/home/filter/filter_view.dart';
import 'package:eshop/presentation/views/product/proudcuts_by_category_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart/cart_item.dart';
import '../../domain/entities/user/user.dart';
import '../../presentation/views/authentication/signin_view.dart';
import '../../presentation/views/authentication/signup_view.dart';
import '../../presentation/views/main/main_view.dart';
import '../../presentation/views/main/other/about/about_view.dart';
import '../../presentation/views/main/other/delivery_info/delivery_info.dart';
import '../../presentation/views/main/other/notification/notification_view.dart';
import '../../presentation/views/main/other/orders/order_view.dart';
import '../../presentation/views/main/other/profile/profile_screen.dart';
import '../../presentation/views/main/other/settings/settings_view.dart';
import '../../presentation/views/order_chekout/order_checkout_view.dart';
import '../../presentation/views/product/product_details_view.dart';
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
      default:
        throw const RouteException('Route not found!');
    }
  }
}
