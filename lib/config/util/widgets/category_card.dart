import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/config/theme/styles.dart';
import 'package:eshop/core/router/app_router.dart';
import 'package:eshop/features/category/data/models/category_model.dart';
import 'package:eshop/features/home/presentation/bloc/filter_cubit.dart';
import 'package:eshop/features/product/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade100),
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: category!.id ?? '',
                            child: CachedNetworkImage(
                              imageUrl: category?.photo ?? '',
                              height: 150,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade100,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            category?.name ?? '',
                            style: Styles.font14DarkBlueMedium.copyWith(
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // Text(
                  //   category?.name ?? '',
                  //   style: const TextStyle(
                  //     fontSize: 18,
                  //   ),
                  // )
                ],
              ),
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
