import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/order/presentation/bloc/order_add/order_add_cubit.dart';
import 'package:eshop/features/order_chekout/presentation/pages/webview.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart'
    as pm;
import 'package:eshop/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:eshop/features/auth/presentation/pages/forget_password.dart';
import 'package:eshop/features/category/presentation/pages/category_view.dart';
import 'package:eshop/features/home/presentation/pages/filter/filter_view.dart';
import 'package:eshop/features/order_chekout/presentation/pages/pickup_screen.dart';
import 'package:eshop/features/product/presentation/pages/proudcuts_by_category_id.dart';
import 'package:eshop/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:eshop/features/wishlist/presentation/pages/wish_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  static const String wishList = '/wishList';

  static const String orderCheckout = '/order-checkout';
  static const String deliveryDetails = '/delivery-details';
  static const String orders = '/orders';
  static const String settings = '/settings';
  static const String proudcutsByCategory = '/proudcutsByCategory';
  static const String category = '/category';
  static const String forgetPassword = '/ForgetPassword';
  static const String pickUp = '/pickUp';
  static const String webView = '/webView';

  static const String notifications = '/notifications';
  static const String about = '/about';
  static const String filter = '/filter';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainView());
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInView());
      case webView:
        return MaterialPageRoute(builder: (_) {
          String webViewUrl = routeSettings.arguments as String;

          return BlocProvider(
            create: (context) => OrderAddCubit(sl()),
            child: PaymentWebView(
              webViewUrl: webViewUrl,
            ),
          );
        });
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
        ProductDetailsView arguments =
            routeSettings.arguments as ProductDetailsView;
        return MaterialPageRoute(
            builder: (_) => ProductDetailsView(
                  product: arguments.product,
                  itemIndex: arguments.itemIndex,
                ));
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
        OrderCheckoutView arguments =
            routeSettings.arguments as OrderCheckoutView;

        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => OrderAddCubit(sl()),
                  child: OrderCheckoutView(
                    currency: arguments.currency,
                    items: arguments.items,
                  ),
                ));

      case wishList:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => WishlistCubit(sl())..getWishlist(),
                  child: const WishListScreen(),
                ));

      case deliveryDetails:
        return MaterialPageRoute(builder: (_) {
          bool isFromCheckout = routeSettings.arguments as bool? ?? false;

          return DeliveryInfoView(
            isFromCheckout: isFromCheckout,
          );
        });
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
