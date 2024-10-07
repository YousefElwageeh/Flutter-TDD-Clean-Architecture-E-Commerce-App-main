import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/config/helpers/spacing.dart';
import 'package:eshop/features/home/model/slider_model.dart';
import 'package:eshop/features/category/presentation/bloc/category_bloc.dart';
import 'package:eshop/config/util/widgets/category_card.dart';
import 'package:eshop/config/util/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/images.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_router.dart';
import '../../../../config/util/widgets/alert_card.dart';
import '../../../../config/util/widgets/product_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController scrollController = ScrollController();

  void _scrollListener() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    double scrollPercentage = 0.7;
    if (currentScroll > (maxScroll * scrollPercentage)) {
      if (context.read<CategoryBloc>().state is CategoryLoaded) {
        context.read<CategoryBloc>().add(const GetCategories());
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).padding.top + 10),
          ),
          const HomeAppBar(),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     top: 12,
          //     left: 20,
          //     right: 20,
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: BlocBuilder<FilterCubit, FilterProductParams>(
          //           builder: (context, state) {
          //             return TextField(
          //               autofocus: false,
          //               controller:
          //                   context.read<FilterCubit>().searchController,
          //               onChanged: (val) => setState(() {}),
          //               onSubmitted: (val) => context.read<CategoryBloc>().add(
          //                   GetProducts(FilterProductParams(keyword: val))),
          //               decoration: InputDecoration(
          //                   contentPadding: const EdgeInsets.only(
          //                       left: 20, bottom: 22, top: 22),
          //                   prefixIcon: const Padding(
          //                     padding: EdgeInsets.only(left: 8),
          //                     child: Icon(Icons.search),
          //                   ),
          //                   suffixIcon: context
          //                           .read<FilterCubit>()
          //                           .searchController
          //                           .text
          //                           .isNotEmpty
          //                       ? Padding(
          //                           padding: const EdgeInsets.only(right: 8),
          //                           child: IconButton(
          //                               onPressed: () {
          //                                 context
          //                                     .read<FilterCubit>()
          //                                     .searchController
          //                                     .clear();
          //                                 context
          //                                     .read<FilterCubit>()
          //                                     .update(keyword: '');
          //                               },
          //                               icon: const Icon(Icons.clear)),
          //                         )
          //                       : null,
          //                   border: const OutlineInputBorder(),
          //                   hintText: "Search Product",
          //                   fillColor: Colors.grey.shade100,
          //                   filled: true,
          //                   focusedBorder: OutlineInputBorder(
          //                       borderSide: const BorderSide(
          //                           color: Colors.white, width: 3.0),
          //                       borderRadius: BorderRadius.circular(26)),
          //                   enabledBorder: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(26),
          //                     borderSide: const BorderSide(
          //                         color: Colors.white, width: 3.0),
          //                   )),
          //             );
          //           },
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 8,
          //       ),
          //       SizedBox(
          //         width: 55,
          //         child: BlocBuilder<FilterCubit, FilterProductParams>(
          //           builder: (context, state) {
          //             return Badge(
          //               alignment: AlignmentDirectional.topEnd,
          //               label: Text(
          //                 context
          //                     .read<FilterCubit>()
          //                     .getFiltersCount()
          //                     .toString(),
          //                 style: const TextStyle(color: Colors.black87),
          //               ),
          //               isLabelVisible:
          //                   context.read<FilterCubit>().getFiltersCount() != 0,
          //               backgroundColor: Theme.of(context).primaryColor,
          //               child: InputFormButton(
          //                 color: Colors.black87,
          //                 onClick: () {
          //                   Navigator.of(context).pushNamed(AppRouter.filter);
          //                 },
          //               ),
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                  //  Result Empty and No Error
                  if (state is CategoryLoaded
                      //&&
                      //  state.products.products!.isEmpty
                      ) {
                    return const AlertCard(
                      image: kEmpty,
                      message: "Products not found!",
                    );
                  }
                  //   Error and no preloaded data
                  if (state is CategoryError &&
                      state.categories.category != null &&
                      state.categories.category!.isEmpty) {
                    if (state.failure is NetworkFailure) {
                      return AlertCard(
                        image: kNoConnection,
                        message: "Network failure\nTry again!",
                        onClick: () {
                          context.read<CategoryBloc>().add(const GetCategories(
                              // FilterProductParams(
                              //     keyword: context
                              //         .read<FilterCubit>()
                              //         .searchController
                              //         .text

                              //         )

                              ));
                        },
                      );
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.failure is ServerFailure)
                          Image.asset(
                              'assets/status_image/internal-server-error.png'),
                        if (state.failure is CacheFailure)
                          Image.asset('assets/status_image/no-connection.png'),
                        const Text("Products not found!"),
                        IconButton(
                            onPressed: () {
                              context
                                  .read<CategoryBloc>()
                                  .add(const GetCategories(
                                      // FilterProductParams(
                                      //     keyword: context
                                      //         .read<FilterCubit>()
                                      //         .searchController
                                      //         .text

                                      //         )

                                      ));
                            },
                            icon: const Icon(Icons.refresh)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        )
                      ],
                    );
                  }
                  return RefreshIndicator.adaptive(
                    onRefresh: () async {
                      context.read<CategoryBloc>().add(const GetCategories());
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          verticalSpace(20),
                          CarouselDemo(
                            sliders:
                                context.read<CategoryBloc>().sliders.sliders ??
                                    [],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                const Text(
                                  'Categories',
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(AppRouter.category);
                                  },
                                  child: const Text('View All'),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: GridView.builder(
                              itemCount: (state.categories.category?.length) ??
                                  0 + ((state is CategoryLoaded) ? 10 : 0),
                              controller: scrollController,
                              padding: const EdgeInsets.only(
                                  top: 18, left: 20, right: 20, bottom: 5),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.6,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 0,
                              ),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                if (state.categories.category!.length > index) {
                                  return CategoryCard(
                                    category: state.categories.category![index],
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
                        ],
                      ),
                    ),
                  );
                })),
          )
        ],
      ),
    );
  }
}

class CarouselDemo extends StatelessWidget {
  List<Sliders> sliders = [];
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();

  CarouselDemo({
    super.key,
    required this.sliders,
  });

  @override
  Widget build(BuildContext context) => sliders.isEmpty
      ? const SizedBox.shrink()
      : Column(children: <Widget>[
          CarouselSlider.builder(
            itemBuilder: (context, index, realIndex) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage("${sliders[index].photo}"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            itemCount: sliders.length,
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 2.0,
              initialPage: 2,
            ),
          ),
          // RaisedButton(
          //   onPressed: () => buttonCarouselController.nextPage(
          //       duration: const Duration(milliseconds: 300),
          //       curve: Curves.linear),
          //   child: const Text('→'),
          // )
        ]);
}
