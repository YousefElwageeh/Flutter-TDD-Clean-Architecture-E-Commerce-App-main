// import 'package:eshop/core/helpers/spacing.dart';
// import 'package:eshop/domain/entities/product/product.dart';
// import 'package:eshop/presentation/blocs/product/product_bloc.dart';
// import 'package:eshop/presentation/widgets/menu_divider.dart';
// import 'package:eshop/presentation/widgets/product_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AllCategory extends StatelessWidget {
//   const AllCategory({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProductBloc, ProductState>(
//       builder: (context, state) {
//         return false //    context.read<ProductBloc>().searchResults.isNotEmpty
//             ? const SizedBox.shrink()
          
//                 : Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: 
//                       3,//context.read<ProductBloc>().catrgories.length,
//                       separatorBuilder: (context, indexItems) {
//                         return verticalSpace(15);
//                       },
//                       itemBuilder: (BuildContext context, int indexCategory) {
//                         // String categoryName = context
//                         //     .read<ProductBloc>()
//                         //     .catrgories
//                         //     .keys
//                         //     .toList()[indexCategory];
//                         String categoryName = "categoryName";
//                         //  log(categoryName);

//                         return Column(
//                           children: [
//                             MenuDivider(
//                               title: categoryName,
//                               onTap: () {
//                                 // context.goTo(Routes.viewAll,
//                                 //     arguments: context
//                                 //         .read<ProductBloc>()
//                                 //         .getProductsByCategory(categoryName));
//                               },
//                             ),
//                             SizedBox(
//                               height: 230,
//                               child: ListView.builder(
//                                 itemCount: 
//                                 3,
                                
//                                 // context
//                                 //         .read<ProductBloc>()
//                                 //         .menu
//                                 //         .products
//                                 //         ?.length ??
//                                  //   0,
//                                 scrollDirection: Axis.horizontal,
//                                 itemBuilder: (context, indexItems) {
//                                   Product Item = context
//                                       .read<ProductBloc>()
//                                       .menu
//                                       .products![indexItems];

//                                   if (categoryName == Item.category) {
//                                     return Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 15),
//                                       child: ProductCard(
//                                         product: state.products
//                                                 .products?[indexItems] ??
//                                             [],
//                                       ),
//                                     );
//                                   } else {
//                                     return const SizedBox.shrink();
//                                   }
//                                 },
//                               ),
//                             )
//                           ],
//                         );
//                       },
//                     ),
//                   );
//       },
//     );
//   }
// }
