import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/core/helpers/spacing.dart';
import 'package:eshop/data/models/cart/add_to_card_request.dart';
import 'package:eshop/data/models/cart/cart_item_model.dart';
import 'package:eshop/data/models/product/product_response_model.dart';
import 'package:eshop/presentation/blocs/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../domain/entities/cart/cart_item.dart';
import '../../../../../domain/entities/product/price_tag.dart';
import '../../../core/router/app_router.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../widgets/input_form_button.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
        ],
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartError) {
            EasyLoading.showError(state.failure.toString());
          } else if (state is CartLoaded) {
            EasyLoading.showSuccess("Product added to cart");
          }
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
                    widget.product.stock == 0 || widget.product.stock == null
                        ? "Out Of Stock"
                        : 'Stock: ${widget.product.sizeQty == null || widget.product.sizeQty!.isEmpty ? widget.product.stock : widget.product.sizeQty?[_selectedsizeIndex]}',
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: countityWidget(),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 10,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Text(
                widget.product.details ?? '',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.product.stock == 0
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
                      const Text(
                        "Total",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      BlocBuilder<ProductBloc, ProductState>(
                        builder: (context, state) {
                          return Text(
                            '\$${(double.parse(_selectedPriceTag).toInt() * context.read<ProductBloc>().countity).toString()}',
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
                  SizedBox(
                    width: 120,
                    child: InputFormButton(
                      onClick: () {
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
                                    : widget
                                        .product.size?[_selectedsizeIndex])));
                        // print("test");
                        Navigator.pop(context);
                      },
                      titleText: "Add to Cart",
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    width: 90,
                    child: InputFormButton(
                      onClick: () {
                        Navigator.of(context)
                            .pushNamed(AppRouter.orderCheckout, arguments: [
                          Cart(
                            item: widget.product,
                            price: (double.parse(_selectedPriceTag) *
                                    context.read<ProductBloc>().countity)
                                .toInt(),
                          )
                        ]);
                      },
                      titleText: "Buy",
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class countityWidget extends StatefulWidget {
  const countityWidget({
    super.key,
  });

  @override
  State<countityWidget> createState() => _countityWidgetState();
}

class _countityWidgetState extends State<countityWidget> {
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
                      context.read<ProductBloc>().icreaseCountity();
                    },
                    child: const Text('+'))),
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
                    child: const Text('-'))),
          ],
        );
      },
    );
  }
}
