import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/config/util/widgets/delivery_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shimmer/shimmer.dart';

import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/product/domain/usecases/get_product_usecase.dart';
import 'package:eshop/features/product/presentation/bloc/product_bloc.dart';
import 'package:eshop/config/util/widgets/product_card.dart';

import '../../../category/data/models/category_model.dart';

class ProductsByCatrgory extends StatelessWidget {
  int categoryID;
  ProductsByCatrgory({
    super.key,
    required this.categoryID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.Products.getString(context)),
      ),
      body: BlocProvider<ProductBloc>(
        create: (context) => sl<ProductBloc>()
          ..add(GetProducts(
              FilterProductParams(categories: [Category(id: categoryID)]))),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<ProductBloc>()
                    .add(const GetProducts(FilterProductParams()));
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: GridView.builder(
                    itemCount: (state.products.products?.length) ??
                        0 + ((state is ProductLoading) ? 10 : 0),
                    //    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 18,
                        left: 20,
                        right: 20,
                        bottom: (80 + MediaQuery.of(context).padding.bottom)),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 10,
                    ),

                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      if ((state.products.products?.length ?? 0) > index) {
                        return ProductCard(
                          product: state.products.products?[index],
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
              ),
            );
          },
        ),
      ),
    );
  }
}
