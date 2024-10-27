import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/core/constant/images.dart';
import 'package:eshop/core/router/app_router.dart';
import 'package:eshop/features/profile/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        if (state is UserLogged) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  log(state.user.image.toString());
                },
                child: Text(
                  "${state.user.name}",
                  style: const TextStyle(fontSize: 26),
                ),
              ),
              const Spacer(),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AppRouter.userProfile, arguments: state.user);
                },
                child: _buildUserAvatar(state.user.image),
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    AppLocale.welcome.getString(context), // Localized welcome
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 36),
                  ),
                  Text(
                    AppLocale.storeName
                        .getString(context), // Localized store name
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 22),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRouter.signIn);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 24.0,
                    backgroundImage: AssetImage(kUserAvatar),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget _buildUserAvatar(String? imageUrl) {
    if (imageUrl != null &&
        imageUrl != 'https://nffpm-demo.ecom.mm4web.net/assets/images/users') {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, image) => CircleAvatar(
          radius: 24.0,
          backgroundImage: image,
          backgroundColor: Colors.transparent,
        ),
      );
    } else {
      return const CircleAvatar(
        radius: 24.0,
        backgroundImage: AssetImage(kUserAvatar),
        backgroundColor: Colors.transparent,
      );
    }
  }
}
