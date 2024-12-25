import 'package:eshop/config/util/widgets/cart_item_card.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eshop/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  void initState() {
    // BlocProvider.of<WishlistCubit>(context).getWishlist();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            BlocBuilder<WishlistCubit, WishlistState>(
              builder: (context, state) {
                if (state is WishlistLoading) {
                  return Expanded(
                    child: RefreshIndicator.adaptive(
                      onRefresh: () {
                        BlocProvider.of<WishlistCubit>(context).getWishlist();
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return const CartItemCard();
                        },
                      ),
                    ),
                  );
                } else if (state is WishlistError) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else if (state is WishlistLoaded) {
                  return Expanded(
                    child: RefreshIndicator.adaptive(
                      onRefresh: () {
                        BlocProvider.of<WishlistCubit>(context).getWishlist();
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        itemCount: state.wishlist.wishlists?.length,
                        itemBuilder: (context, index) {
                          state.wishlist.wishlists?[index].isWishlist = "true";
                          return CartItemCard(
                            iswishlist: true,
                            currency: state.wishlist.currencyEn,
                            cartItem: Cart(
                                price: state.wishlist.wishlists?[index].price
                                    ?.toInt(),
                                item: state.wishlist.wishlists?[index]),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
