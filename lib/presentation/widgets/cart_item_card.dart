import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';
import 'package:eshop/domain/entities/cart/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/router/app_router.dart';
import '../blocs/cart/cart_bloc.dart';

class CartItemCard extends StatelessWidget {
  final Cart? cartItem;
  final Function? onFavoriteToggle;
  final Function? onClick;
  final Function()? onLongClick;
  final bool isSelected;
  const CartItemCard({
    super.key,
    this.cartItem,
    this.onFavoriteToggle,
    this.onClick,
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
          Navigator.of(context)
              .pushNamed(AppRouter.productDetails, arguments: cartItem!.item);
        }
      },
      onLongPress: onLongClick,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade50,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          ),
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
                                    r'$' + cartItem!.price.toString(),
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
                    context.read<CartBloc>().delteItem(cartItem!.item!.id!);
                  },
                  icon: const Icon(Icons.delete)),
            ],
          ),
          // Positioned(
          //   top: 10,
          //   right: 0,
          //   child: FavoriteClothButton(
          //     cloth: cloth,
          //   ),
          // ),
        ],
      ),
    );
  }
}
