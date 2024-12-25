import 'dart:async';

import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/config/util/widgets/product_card.dart';
import 'package:eshop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eshop/features/category/presentation/bloc/category_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  Timer? _debounceTimer; // To store the debounce timer
  final int _debounceDuration =
      1000; // Duration to wait before sending request (in milliseconds)

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
              ),
              child: TextField(
                controller: _textEditingController,
                autofocus: false,
                onSubmitted: (val) {
                  context.read<CartBloc>().searchProduct(val);
                },
                onChanged: (val) => setState(() {
                  if (_debounceTimer?.isActive ?? false) {
                    _debounceTimer?.cancel();
                  }

                  // Start a new timer to wait for the pause in typing
                  _debounceTimer =
                      Timer(Duration(milliseconds: _debounceDuration), () {
                    if (val.isNotEmpty) {
                      context.read<CartBloc>().searchProduct(val);
                    }
                  });
                }),
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.only(left: 20, bottom: 22, top: 22),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.search),
                    ),
                    suffixIcon: _textEditingController.text.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _textEditingController.clear();
                                    context
                                        .read<CategoryBloc>()
                                        .add(const FilterCategories(''));
                                  });
                                },
                                icon: const Icon(Icons.clear)),
                          )
                        : null,
                    border: const OutlineInputBorder(),
                    hintText: AppLocale.searchCaregory.getString(context),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3.0),
                        borderRadius: BorderRadius.circular(26)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 3.0),
                    )),
              ),
            ),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: GridView.builder(
                        itemCount:
                            (context.read<CartBloc>().serchResult.length),
                        //    controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                            top: 18,
                            left: 20,
                            right: 20,
                            bottom:
                                (80 + MediaQuery.of(context).padding.bottom)),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.55,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 10,
                        ),

                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          if ((context.read<CartBloc>().serchResult.length ??
                                  0) >
                              index) {
                            return ProductCard(
                              product:
                                  context.read<CartBloc>().serchResult[index],
                            );
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade100,
                              highlightColor: Colors.white,
                              child: const ProductCard(),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
