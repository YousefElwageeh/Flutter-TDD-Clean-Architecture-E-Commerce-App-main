import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:eshop/features/product/presentation/pages/product_details_view.dart';

import '../../../core/router/app_router.dart';
import '../../../features/cart/presentation/bloc/cart_bloc.dart';

class CartItemCard extends StatelessWidget {
  final Cart? cartItem;
  final Function? onFavoriteToggle;
  final Function? onClick;
  final int? index;
  final String? currency;
  final bool iswishlist;

  final Function()? onLongClick;
  final bool isSelected;
  const CartItemCard({
    super.key,
    this.cartItem,
    this.onFavoriteToggle,
    this.onClick,
    this.iswishlist = false,
    this.index,
    this.currency,
    this.onLongClick,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: cartItem == null
          ? Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey.shade100,
              child: buildBody(context),
            )
          : buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cartItem != null) {
          Navigator.of(context).pushNamed(AppRouter.productDetails,
              arguments: ProductDetailsView(
                product: cartItem!.item ?? Product(),
                itemIndex: index,
              ));
        }
      },
      onLongPress: onLongClick,
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: cartItem == null
                  ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        color: Colors.grey.shade300,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: CachedNetworkImage(
                        imageUrl: cartItem!.item?.photo ?? "",
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                      child: SizedBox(
                        // height: 18,
                        child: cartItem == null
                            ? Container(
                                width: 150,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              )
                            : SizedBox(
                                child: Text(
                                  cartItem!.item?.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 18,
                          child: cartItem == null
                              ? Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                )
                              : Text(
                                  '$currency ${cartItem!.price}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        const Spacer(),
                        cartItem?.sizePrice == null
                            ? const SizedBox.shrink()
                            : Text(
                                '${cartItem!.sizePrice == null || cartItem!.sizePrice!.isEmpty ? cartItem!.item?.price.toString() : cartItem!.sizePrice}x${cartItem!.qty}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  if (iswishlist) {
                    context
                        .read<WishlistCubit>()
                        .removeFromWishlist(cartItem!.item!.id!.toString());
                  } else {
                    context.read<CartBloc>().delteItem(cartItem!.item!.id!);
                  }
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
