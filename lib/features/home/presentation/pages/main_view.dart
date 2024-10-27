import 'package:eshop/config/locale/tranlslations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import '../bloc/navbar_cubit.dart';
import '../../../cart/presentation/pages/cart_view.dart';
import 'home_view.dart';
import '../../../profile/presentation/pages/other_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    CartView(),
                    OtherView(),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 18,
            right: 18,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: BlocBuilder<NavbarCubit, int>(
                builder: (context, state) {
                  return SnakeNavigationBar.color(
                    behaviour: SnakeBarBehaviour.floating,
                    snakeShape: SnakeShape.indicator,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(48)),
                    ),
                    backgroundColor: Colors.black87,
                    snakeViewColor: Colors.black87,
                    height: 68,
                    elevation: 4,
                    selectedItemColor: SnakeShape.circle == SnakeShape.indicator
                        ? Colors.black87
                        : null,
                    unselectedItemColor: Colors.white,
                    selectedLabelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                    showUnselectedLabels: false,
                    showSelectedLabels: true,
                    currentIndex: state,
                    onTap: (index) {
                      setState(() {
                        context.read<NavbarCubit>().controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.linear);
                        context.read<NavbarCubit>().update(index);
                      });
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage("assets/navbar_icons/home.png"),
                          color: Colors.white,
                          size: 26,
                        ),
                        activeIcon: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            maxRadius: 4,
                          ),
                        ),
                        label: AppLocale.home
                            .getString(context), // Localized label
                      ),
                      BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage("assets/navbar_icons/shopping-cart.png"),
                          color: Colors.white,
                          size: 26,
                        ),
                        activeIcon: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            maxRadius: 4,
                          ),
                        ),
                        label: AppLocale.cart
                            .getString(context), // Localized label
                      ),
                      BottomNavigationBarItem(
                        icon: const ImageIcon(
                          AssetImage("assets/navbar_icons/user.png"),
                          color: Colors.white,
                          size: 26,
                        ),
                        activeIcon: const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            maxRadius: 4,
                          ),
                        ),
                        label: AppLocale.other
                            .getString(context), // Localized label
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
