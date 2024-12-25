import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/config/theme/colors.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:eshop/config/helpers/spacing.dart';
import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/features/cart/data/models/add_to_card_request.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/order/presentation/bloc/order_add/order_add_cubit.dart';
import 'package:eshop/features/order_chekout/presentation/pages/order_checkout_view.dart';
import 'package:eshop/features/product/data/models/product_response_model.dart';
import 'package:eshop/features/product/presentation/bloc/product_bloc.dart';
import 'package:eshop/features/profile/presentation/bloc/user/user_bloc.dart';
import 'package:eshop/features/wishlist/presentation/cubit/wishlist_cubit.dart';

import '../../../../config/util/widgets/input_form_button.dart';
import '../../../../core/router/app_router.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;
  final int? itemIndex;

  const ProductDetailsView({
    super.key,
    required this.product,
    this.itemIndex,
  });

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int _currentIndex = 0;
  int _selectedsizeIndex = 0;

  late String _selectedPriceTag;

  @override
  void initState() {
    context.read<ProductBloc>().countity = 1;
    if (widget.product.sizePrice == null || widget.product.sizePrice!.isEmpty) {
      _selectedPriceTag = widget.product.mobilePrice ?? '';
    } else {
      _selectedPriceTag = widget.product.sizePrice![_selectedsizeIndex];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        // actions: [
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
        //   IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        // ],
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          // if (state is CartError) {
          //   EasyLoading.showError(state.failure.toString());
          // }
        },
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).width,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: double.infinity,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: [widget.product.photo].map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Hero(
                        tag: widget.product.id ?? '',
                        child: CachedNetworkImage(
                          imageUrl: image ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.contain,
                                colorFilter: ColorFilter.mode(
                                    Colors.grey.shade50.withOpacity(0.25),
                                    BlendMode.softLight),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.center,
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: [widget.product.photo].length,
                  effect: ScrollingDotsEffect(
                      dotColor: Colors.grey.shade300,
                      maxVisibleDots: 7,
                      activeDotColor: Colors.grey,
                      dotHeight: 6,
                      dotWidth: 6,
                      activeDotScale: 1.1,
                      spacing: 6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 14, top: 20, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name ?? '',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.product.stock == null ||
                            (widget.product.stock ?? 0) <= 0
                        ? AppLocale.outOfStock.getString(context)
                        : "${AppLocale.stockLabel.getString(context)}:${widget.product.sizeQty == null || widget.product.sizeQty!.isEmpty ? widget.product.stock : widget.product.sizeQty?[_selectedsizeIndex]}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: widget.product.size == null || widget.product.size!.isEmpty
                  ? const SizedBox.shrink()
                  : Wrap(
                      children: widget.product.size!
                          .map((priceTag) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedsizeIndex =
                                        widget.product.size!.indexOf(priceTag);
                                    _selectedPriceTag = widget
                                        .product.sizePrice![_selectedsizeIndex];
                                    log(_selectedPriceTag);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _selectedsizeIndex ==
                                            widget.product.size!
                                                .indexOf(priceTag)
                                        ? Colors.grey
                                        : Colors.white,
                                    border: Border.all(
                                      width: _selectedsizeIndex ==
                                              widget.product.size!
                                                  .indexOf(priceTag)
                                          ? 2.0
                                          : 1.0,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(right: 4),
                                  child: Column(
                                    children: [
                                      //    Text(priceTag.),
                                      Text(priceTag.toString()),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: countityWidget(
                isWishlist: widget.product.isWishlist == "true" ?? false,
                stock: widget.product.stock ?? 0,
                id: widget.product.id ?? 0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 10,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Container(
                child: HtmlWidget(
                  widget.product.details ?? '',
                  buildAsync: true,
                  //style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: (widget.product.stock ?? 0) <= 0
          ? const SizedBox.shrink()
          : Container(
              color: Theme.of(context).colorScheme.secondary,
              height: 80 + MediaQuery.of(context).padding.bottom,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 10,
                top: 10,
                left: 20,
                right: 20,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocale.total.getString(context),
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          return Text(
                            '${widget.product.currencyEn ?? ""} ${(double.parse(_selectedPriceTag).toInt() * context.read<ProductBloc>().countity).toString()}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: 120,
                        child: InputFormButton(
                          onClick: () {
                            if (Constants.token != null) {
                              context.read<CartBloc>().add(AddProduct(
                                  cartItem: AddToCardRequest(
                                      id: widget.product.id,
                                      qty: context
                                          .read<ProductBloc>()
                                          .countity
                                          .toString(),
                                      // sizePrice:
                                      //     double.parse(_selectedPriceTag).toInt(),
                                      size: widget.product.size == null ||
                                              widget.product.size!.isEmpty
                                          ? null
                                          : widget.product
                                              .size?[_selectedsizeIndex])));

                              if (widget.itemIndex != null) {
                                final quantityToUpdate = context
                                    .read<ProductBloc>()
                                    .countity; // Assuming this gives the quantity to add
                                context.read<CartBloc>().add(
                                    UpdateCartItemQuantity(
                                        widget.itemIndex!, quantityToUpdate));
                              }

                              Navigator.pop(context);
                            } else {
                              EasyLoading.showError(AppLocale.pleaseLoginError
                                  .getString(context));

                              Navigator.of(context).pushNamed(AppRouter.signIn);
                            }

                            // print("test");
                          },
                          titleText:
                              AppLocale.addToCartButton.getString(context),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    width: 90,
                    child: InputFormButton(
                      onClick: () {
                        if (Constants.token != null) {
                          Navigator.of(context).pushNamed(
                              AppRouter.orderCheckout,
                              arguments: OrderCheckoutView(items: [
                                Cart(
                                  item: widget.product,
                                  qty: context.read<ProductBloc>().countity,
                                  price: (double.parse(_selectedPriceTag) *
                                          context.read<ProductBloc>().countity)
                                      .toInt(),
                                )
                              ], currency: widget.product.currencyEn ?? ''));
                        } else {
                          EasyLoading.showError(
                              AppLocale.pleaseLoginError.getString(context));
                          Navigator.of(context).pushNamed(AppRouter.signIn);
                        }
                      },
                      titleText: AppLocale.buyButton.getString(context),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class countityWidget extends StatefulWidget {
  int stock;
  int id;
  bool isWishlist;

  countityWidget({
    super.key,
    required this.stock,
    required this.id,
    required this.isWishlist,
  });

  @override
  State<countityWidget> createState() => _countityWidgetState();
}

class _countityWidgetState extends State<countityWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor,
                ),
                child: TextButton(
                    onPressed: () {
                      if (context.read<ProductBloc>().countity < widget.stock) {
                        context.read<ProductBloc>().icreaseCountity();
                      } else {
                        EasyLoading.showError(
                            AppLocale.outOfStock.getString(context));
                      }
                    },
                    child: const Text(
                      '+',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))),
            horizontalSpace(12),
            Text(context.read<ProductBloc>().countity.toString()),
            horizontalSpace(12),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor,
                ),
                child: TextButton(
                    onPressed: () {
                      context.read<ProductBloc>().decreaseCountity();
                    },
                    child: const Text('-',
                        style: TextStyle(color: Colors.white, fontSize: 20)))),
            const Spacer(),
            BlocProvider(
              create: (context) => WishlistCubit(sl()),
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  return IconButton(
                      onPressed: () {
                        if (widget.isWishlist) {
                          context
                              .read<WishlistCubit>()
                              .removeFromWishlist(widget.id.toString());
                        } else {
                          context
                              .read<WishlistCubit>()
                              .addToWishlist(widget.id.toString());
                        }
                        widget.isWishlist = !widget.isWishlist;
                        setState(() {});
                      },
                      icon: Icon(
                        widget.isWishlist
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: widget.isWishlist
                            ? ColorsManger.primaryColor
                            : null,
                      ));
                },
              ),
            )
          ],
        );
      },
    );
  }
}
