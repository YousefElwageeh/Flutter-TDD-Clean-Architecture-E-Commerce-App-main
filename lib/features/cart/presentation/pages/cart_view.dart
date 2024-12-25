import 'dart:developer';

import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/home/presentation/bloc/navbar_cubit.dart';
import 'package:eshop/features/order_chekout/presentation/pages/order_checkout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../core/constant/images.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_router.dart';
import '../bloc/cart_bloc.dart';
import '../../../../config/util/widgets/cart_item_card.dart';
import '../../../../config/util/widgets/input_form_button.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<Cart> selectedCartItems = [];
  @override
  void initState() {
    BlocProvider.of<CartBloc>(context).add(const GetCart());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartError) {
                      return ErrorCardWidget(state, context);
                    }
                    if ((state.cart.cart == null || state.cart.cart!.isEmpty) &&
                        state is CartLoaded) {
                      return const CardEmptyWidget();
                    }
                    if (state is CartLoading) {
                      return RefreshIndicator.adaptive(
                        onRefresh: () {
                          return Future(
                            () {
                              BlocProvider.of<CartBloc>(context)
                                  .add(const GetCart());
                            },
                          );
                        },
                        child: ListView.builder(
                            itemCount: 5,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                const CartItemCard()),
                      );
                    }
                    return RefreshIndicator.adaptive(
                      onRefresh: () {
                        return Future(
                          () {
                            BlocProvider.of<CartBloc>(context)
                                .add(const GetCart());
                          },
                        );
                      },
                      child: ListView.builder(
                        itemCount: state is CartLoading
                            ? 10
                            : (state.cart.cart?.length ?? 0),
                        padding: EdgeInsets.only(
                            top: (MediaQuery.of(context).padding.top + 20),
                            bottom:
                                MediaQuery.of(context).padding.bottom + 200),
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          if (state is CartLoading &&
                              state.cart.cart!.isEmpty) {
                            return const CartItemCard();
                          } else {
                            if ((state.cart.cart?.length ?? 0) < index) {
                              return const CartItemCard();
                            }
                            log(index.toString());
                            return CartItemCard(
                              currency: state.cart.currency?.name,
                              index: index,
                              cartItem: state.cart.cart![index],
                              isSelected: selectedCartItems.any((element) =>
                                  element == state.cart.cart![index]),
                              onLongClick: () {
                                setState(() {
                                  if (selectedCartItems.any((element) =>
                                      element == state.cart.cart![index])) {
                                    selectedCartItems
                                        .remove(state.cart.cart![index]);
                                  } else {
                                    selectedCartItems
                                        .add(state.cart.cart![index]);
                                  }
                                });
                              },
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            BlocBuilder<CartBloc, CartState>(builder: (context, state) {
              if (state.cart.cart == null || state.cart.cart!.isEmpty) {
                return const SizedBox();
              }
              return Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 4, left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocale.total.getString(context)} ${state.cart.cart?.length}  ${AppLocale.item.getString(context)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${state.cart.currency?.name ?? ""} ${state.cart.cart?.fold(0.0, (previousValue, element) => (double.parse(element.price!.toDouble().toString()) + previousValue))}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: InputFormButton(
                        cornerRadius: 36,
                        padding: EdgeInsets.zero,
                        onClick: () {
                          Navigator.of(context).pushNamed(
                              AppRouter.orderCheckout,
                              arguments: OrderCheckoutView(
                                  items: state.cart.cart ?? [],
                                  currency: state.cart.currency?.name ?? ''));
                        },
                        titleText: AppLocale.checkout
                            .getString(context), // Localized checkout button
                      ),
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Column ErrorCardWidget(CartError state, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state.failure is NetworkFailure) Image.asset(kNoConnection),
        if (state.failure is ServerFailure) Image.asset(kInternalServerError),
        Text(AppLocale.cartEmpty
            .getString(context)), // Localized cart empty message
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),

        InputFormButton(
          titleText: 'Shop Now',
          onClick: () {
            context.read<NavbarCubit>().controller.animateToPage(0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.linear);
            context.read<NavbarCubit>().update(0);
          },
        )
      ],
    );
  }
}

class CardEmptyWidget extends StatelessWidget {
  const CardEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(kEmptyCart),
        Text(AppLocale.cartEmpty
            .getString(context)), // Localized cart empty message
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
      ],
    );
  }
}
