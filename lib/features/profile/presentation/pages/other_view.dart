import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/config/util/app_strings.dart';
import 'package:eshop/features/delivery/presentation/bloc/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import 'package:eshop/features/order/presentation/bloc/order_fetch/order_fetch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constant/images.dart';
import '../../../../core/router/app_router.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../../../../config/util/widgets/other_item_card.dart';

class OtherView extends StatelessWidget {
  const OtherView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserLogged) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.userProfile,
                      arguments: state.user,
                    );
                  },
                  child: Row(
                    children: [
                      state.user.image != null &&
                              state.user.image !=
                                  'https://nffpm-demo.ecom.mm4web.net/assets/images/users'
                          ? CachedNetworkImage(
                              imageUrl: state.user.image!,
                              imageBuilder: (context, image) => CircleAvatar(
                                radius: 36.0,
                                backgroundImage: image,
                                backgroundColor: Colors.transparent,
                              ),
                            )
                          : const CircleAvatar(
                              radius: 36.0,
                              backgroundImage: AssetImage(kUserAvatar),
                              backgroundColor: Colors.transparent,
                            ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${state.user.name} ",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(state.user.email ?? '')
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRouter.signIn);
                  },
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 36.0,
                        backgroundImage: AssetImage(kUserAvatar),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocale.loginInYourAccount.getString(context),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 25),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 4, top: 2),
            child: Text(
              AppLocale.generalSettigs.getString(context),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            return OtherItemCard(
              icon: Icons.person_outline,
              onClick: () {
                if (state is UserLogged) {
                  Navigator.of(context).pushNamed(
                    AppRouter.userProfile,
                    arguments: state.user,
                  );
                } else {
                  Navigator.of(context).pushNamed(AppRouter.signIn);
                }
              },
              title: AppLocale.profile.getString(context),
            );
          }),
          const SizedBox(height: 6),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserLogged) {
              return OtherItemCard(
                icon: Icons.favorite_border_outlined,
                onClick: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.wishList,
                  );
                  // context.read<UserBloc>().add(SignOutUser());
                  // context.read<CartBloc>().add(const ClearCart());
                  // context
                  //     .read<DeliveryInfoFetchCubit>()
                  //     .clearLocalDeliveryInfo();
                  // context.read<OrderFetchCubit>().clearLocalOrders();
                },
                title: AppLocale.wishlist.getString(context),
              );
            } else {
              return const SizedBox();
            }
          }),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserLogged) {
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: OtherItemCard(
                  icon: Icons.shopping_cart_outlined,
                  onClick: () {
                    Navigator.of(context).pushNamed(AppRouter.orders);
                  },
                  title: AppLocale.orders.getString(context),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserLogged) {
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: OtherItemCard(
                  icon: Icons.delivery_dining_outlined,
                  onClick: () {
                    Navigator.of(context).pushNamed(AppRouter.deliveryDetails);
                  },
                  title: AppLocale.deliveryInfo.getString(context),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
          const SizedBox(height: 6),
          OtherItemCard(
            icon: Icons.language_outlined,
            onClick: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            FlutterLocalization localization =
                                FlutterLocalization.instance;

                            localization.translate('ar');
                            Navigator.of(context).pop();
                          },
                          title: const Text('العربية'),
                        ),
                        ListTile(
                          onTap: () {
                            FlutterLocalization localization =
                                FlutterLocalization.instance;

                            localization.translate('en');
                            Navigator.of(context).pop();
                          },
                          title: const Text('English'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            title: AppLocale.language.getString(context),
          ),
          const SizedBox(height: 6),
          OtherItemCard(
            icon: Icons.info_outline_rounded,
            onClick: () async {
              final FlutterLocalization localization =
                  FlutterLocalization.instance;

              String url = localization.currentLocale.localeIdentifier == 'ar'
                  ? AppStrings.ABOUT_URL_AR
                  : AppStrings.ABOUT_URL_EN;
              if (!await launchUrl(Uri.parse(url))) {
                throw Exception('Could not launch $url');
              }

              //    Navigator.of(context).pushNamed(AppRouter.about);
            },
            title: AppLocale.about.getString(context),
          ),
          const SizedBox(height: 6),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state is UserLogged) {
              return OtherItemCard(
                icon: Icons.exit_to_app_outlined,
                onClick: () {
                  context.read<UserBloc>().add(SignOutUser());
                  context.read<CartBloc>().add(const ClearCart());
                  context
                      .read<DeliveryInfoFetchCubit>()
                      .clearLocalDeliveryInfo();
                  context.read<OrderFetchCubit>().clearLocalOrders();
                },
                title: AppLocale.signOut.getString(context),
              );
            } else {
              return const SizedBox();
            }
          }),
          SizedBox(height: (MediaQuery.of(context).padding.bottom + 50)),
        ],
      ),
    );
  }
}
