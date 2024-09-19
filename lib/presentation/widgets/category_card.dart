import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/core/router/app_router.dart';
import 'package:eshop/data/models/category/category_model.dart';
import 'package:eshop/domain/entities/category/category.dart';
import 'package:eshop/presentation/blocs/filter/filter_cubit.dart';
import 'package:eshop/presentation/blocs/product/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../blocs/home/navbar_cubit.dart';

class CategoryCard extends StatelessWidget {
  final Category? category;
  const CategoryCard({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (category != null) {
          // context.read<NavbarCubit>().controller.animateToPage(0,
          //     duration: const Duration(milliseconds: 400),
          //     curve: Curves.linear);
          // context.read<NavbarCubit>().update(0);
          //  context.read<FilterCubit>().update(category: category);
          Navigator.of(context).pushNamed(AppRouter.proudcutsByCategory,
              arguments: category?.id);

          context
              .read<ProductBloc>()
              .add(GetProducts(context.read<FilterCubit>().state));
        }
      },
      child: category != null
          ? Column(
              children: [
                Card(
                  color: Colors.grey.shade100,
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: Hero(
                      tag: category!.id ?? '',
                      child: CachedNetworkImage(
                        imageUrl: category?.photo ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade100,
                        ),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                Text(
                  category?.name ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            )
          : Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.white70,
              child: Card(
                color: Colors.grey.shade100,
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
              ),
            ),
    );
  }
}
