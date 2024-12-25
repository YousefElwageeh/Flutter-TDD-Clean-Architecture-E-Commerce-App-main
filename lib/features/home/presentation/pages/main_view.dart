import 'package:eshop/config/theme/colors.dart';
import 'package:eshop/features/search/presentation/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import 'package:eshop/config/locale/tranlslations.dart';

import '../../../cart/presentation/pages/cart_view.dart';
import '../../../profile/presentation/pages/other_view.dart';
import '../bloc/navbar_cubit.dart';
import 'home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: BlocBuilder<NavbarCubit, int>(
          builder: (context, state) {
            return SnakeNavigationBar.color(
              behaviour: SnakeBarBehaviour.floating,
              snakeShape: SnakeShape.indicator,
              backgroundColor: Colors.white,
              snakeViewColor: Colors.white,
              height: 68,
              elevation: 4,
              selectedItemColor: SnakeShape.circle == SnakeShape.indicator
                  ? Colors.black87
                  : null,
              unselectedItemColor: Colors.white,
              selectedLabelStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
              showUnselectedLabels: false,
              showSelectedLabels: true,
              currentIndex: state,
              onTap: (index) {
                setState(() {
                  context.read<NavbarCubit>().controller.animateToPage(index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linear);
                  context.read<NavbarCubit>().update(index);
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Commonicon(
                    assetsPath: "assets/navbar_icons/home.png",
                  ),
                  activeIcon: Commonicon(
                    assetsPath: "assets/navbar_icons/home.png",
                    isactive: true,
                  ),
                  label: AppLocale.home.getString(context), // Localized label
                ),
                BottomNavigationBarItem(
                  icon: Commonicon(
                    assetsPath: "assets/navbar_icons/search.png",
                  ),
                  activeIcon: Commonicon(
                    assetsPath: "assets/navbar_icons/search.png",
                    isactive: true,
                  ),
                  label: AppLocale.searchCaregory
                      .getString(context), // Localized label
                ),
                BottomNavigationBarItem(
                  icon: Commonicon(
                    assetsPath: "assets/navbar_icons/shopping-cart.png",
                  ),
                  activeIcon: Commonicon(
                    assetsPath: "assets/navbar_icons/shopping-cart.png",
                    isactive: true,
                  ),
                  label: AppLocale.cart.getString(context), // Localized label
                ),
                BottomNavigationBarItem(
                  icon: Commonicon(
                    assetsPath: "assets/navbar_icons/user.png",
                  ),
                  activeIcon: Commonicon(
                    assetsPath: "assets/navbar_icons/user.png",
                    isactive: true,
                  ),
                  label: AppLocale.other.getString(context), // Localized label
                ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<NavbarCubit, int>(
            builder: (context, state) {
              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: context.read<NavbarCubit>().controller,
                  children: const <Widget>[
                    HomeView(),
                    SearchScreen(),
                    CartView(),
                    OtherView(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Commonicon extends StatelessWidget {
  String assetsPath;
  bool isactive = false;
  Commonicon({super.key, required this.assetsPath, this.isactive = false});

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      AssetImage(assetsPath),
      color: isactive ? ColorsManger.primaryColor : Colors.black,
      size: 26,
    );
  }
}
