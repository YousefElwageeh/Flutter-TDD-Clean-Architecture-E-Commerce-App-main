import 'package:carousel_slider/carousel_slider.dart';
import 'package:eshop/config/helpers/spacing.dart';
import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/config/theme/styles.dart';
import 'package:eshop/config/util/assetsManger.dart';
import 'package:eshop/features/home/model/slider_model.dart';
import 'package:eshop/features/category/presentation/bloc/category_bloc.dart';
import 'package:eshop/config/util/widgets/category_card.dart';
import 'package:eshop/config/util/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight: 50,
        centerTitle: true,
        title: Image.asset(
          AssetsManger.logowithwords,
          width: 230,
          fit: BoxFit.fill,
        ),
        actions: [
          IconButton(
            onPressed: () {
              //  Navigator.of(context).pushNamed(AppRouter.cart);
            },
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  SizedBox(height: MediaQuery.of(context).padding.top + 10),
          //   const HomeAppBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    return const AlertCard(
                      image: kEmpty,
                      message: AppLocale.productsNotFound,
                    );
                  }

                  if (state is CategoryError &&
                      state.categories.category != null &&
                      state.categories.category!.isEmpty) {
                    if (state.failure is NetworkFailure) {
                      return AlertCard(
                        image: kNoConnection,
                        message:
                            AppLocale.networkFailureMessage.getString(context),
                        onClick: () {
                          context
                              .read<CategoryBloc>()
                              .add(const GetCategories());
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
                        Text(AppLocale.productsNotFound.getString(context)),
                        IconButton(
                          onPressed: () {
                            context
                                .read<CategoryBloc>()
                                .add(const GetCategories());
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
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
                                Text(
                                  AppLocale.categories.getString(context),
                                  style: Styles.font24BlackBold
                                      .copyWith(fontSize: 18),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(AppRouter.category);
                                  },
                                  child: Text(
                                    AppLocale.viewAll.getString(context),
                                    style: Styles.font24BlackBold
                                        .copyWith(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: GridView.builder(
                              itemCount: state.categories.category?.length ??
                                  0 + ((state is CategoryLoaded) ? 10 : 0),
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 20,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 0,
                              ),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
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
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselDemo extends StatefulWidget {
  final List<Sliders> sliders;

  const CarouselDemo({super.key, required this.sliders});

  @override
  State<CarouselDemo> createState() => _CarouselDemoState();
}

class _CarouselDemoState extends State<CarouselDemo> {
  final CarouselSliderController buttonCarouselController =
      CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.sliders.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.sliders.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(widget.sliders[index].photo ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          carouselController: buttonCarouselController,
          options: CarouselOptions(
              autoPlay: true,
              height: 150,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              aspectRatio: 3.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.sliders.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => buttonCarouselController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList()),
      ],
    );
  }
}
