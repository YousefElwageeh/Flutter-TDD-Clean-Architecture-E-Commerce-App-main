import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';
import 'package:eshop/features/delivery/data/models/nearest_branches.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';
import 'package:eshop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eshop/features/delivery/presentation/bloc/delivery_info_action/delivery_info_action_cubit.dart';
import 'package:eshop/features/home/presentation/bloc/navbar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../core/services/services_locator.dart' as di;
import '../../../../core/router/app_router.dart';
import '../../../delivery/presentation/bloc/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../../order/presentation/bloc/order_add/order_add_cubit.dart';
import '../../../../config/util/widgets/input_form_button.dart';
import '../../../../config/util/widgets/outline_label_card.dart';

class OrderCheckoutView extends StatefulWidget {
  final List<Cart> items;
  const OrderCheckoutView({super.key, required this.items});

  @override
  State<OrderCheckoutView> createState() => _OrderCheckoutViewState();
}

class _OrderCheckoutViewState extends State<OrderCheckoutView> {
  List<DropdownMenuEntry> options = [
    const DropdownMenuEntry(
      value: 'Pick up',
      label: 'Pick up',
    ),
  ];
  double? totalPrice;
  int vatValue = 0;

  @override
  void initState() {
    log('test');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      log('test');

      vatValue = await context.read<OrderAddCubit>().getVat() ?? 0;
    });
    totalPrice = widget.items.fold(
        0.0,
        (previousValue, element) =>
            (element.price!.toDouble() + previousValue!));
    if (totalPrice! > 1000) {
      options.add(const DropdownMenuEntry(
        value: 'Delivery',
        label: 'Delivery',
      ));

      context.read<DeliveryInfoActionCubit>().deliveryPrice = '';
      context.read<DeliveryInfoActionCubit>().selectedBranch =
          NearestBrancheModel();
      context.read<DeliveryInfoActionCubit>().selectedDlivery =
          AddressResponseModel();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<OrderAddCubit>(),
      child: BlocListener<OrderAddCubit, OrderAddState>(
        listener: (context, state) {
          EasyLoading.dismiss();
          if (state is OrderAddLoading) {
            EasyLoading.show(status: 'Loading...');
          } else if (state is OrderAddSuccess) {
            context.read<NavbarCubit>().update(0);
            context.read<NavbarCubit>().controller.jumpToPage(0);
            context.read<CartBloc>().add(const ClearCart());
            Navigator.of(context).pop();
          } else if (state is OrderAddFail) {
            EasyLoading.showError("Error");
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Order Checkout'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 12,
                ),
                DropdownMenu(
                    label: const Text('Choose delivery method'),
                    width: double.infinity,
                    onSelected: (value) {
                      if (value == 'Delivery') {
                        Navigator.of(context)
                            .pushNamed(AppRouter.deliveryDetails);
                      } else if (value == 'Pick up') {
                        Navigator.of(context).pushNamed(AppRouter.pickUp);
                      }
                    },
                    dropdownMenuEntries: options),
                const SizedBox(
                  height: 16,
                ),
                OutlineLabelCard(
                  title: 'Selected Products',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8),
                    child: Column(
                      children: widget.items
                          .map((product) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 75,
                                      child: AspectRatio(
                                        aspectRatio: 0.88,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    product.item?.photo ?? '',
                                              ),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.item?.name ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text('\$${product.price}')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                OutlineLabelCard(
                  title: 'Order Summery',
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Number of Items"),
                            Text("x${widget.items.length}")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("VAt Prectage $vatValue%"),
                            Text("x${vatValue * totalPrice! / 100}")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Price"),
                            Text(
                                "\$${widget.items.fold(0.0, (previousValue, element) => (element.price!.toDouble() + previousValue))}")
                          ],
                        ),
                        BlocBuilder<DeliveryInfoActionCubit,
                            DeliveryInfoActionState>(
                          builder: (context, state) {
                            return context
                                        .read<DeliveryInfoActionCubit>()
                                        .deliveryPrice ==
                                    ''
                                ? const SizedBox.shrink()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Dleivery Charge"),
                                      Text(
                                          "\$${context.read<DeliveryInfoActionCubit>().deliveryPrice}")
                                    ],
                                  );
                          },
                        ),
                        // const Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [Text("Delivery Charge"), Text("\$4.99")],
                        // ),
                        BlocBuilder<DeliveryInfoActionCubit,
                            DeliveryInfoActionState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total"),
                                context
                                            .read<DeliveryInfoActionCubit>()
                                            .deliveryPrice ==
                                        ''
                                    ? Text("\$${totalPrice!}")
                                    : Text(
                                        "\$${totalPrice! + int.parse(context.read<DeliveryInfoActionCubit>().deliveryPrice)}")
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Builder(builder: (context) {
                return InputFormButton(
                  color: Colors.black87,
                  onClick: () {
                    if (context
                                .read<DeliveryInfoFetchCubit>()
                                .state
                                .selectedDeliveryInformation ==
                            null &&
                        context
                                .read<DeliveryInfoActionCubit>()
                                .selectedBranch ==
                            NearestBrancheModel()) {
                      EasyLoading.showError(
                          "Error \nPlease select delivery add your delivery information");
                    } else {
                      context.read<OrderAddCubit>().addOrder(OrderRequestModel(
                          productsId: widget.items
                              .map((item) => item.item!.id!)
                              .toList(),
                          addressId: context
                              .read<DeliveryInfoFetchCubit>()
                              .state
                              .selectedDeliveryInformation
                              ?.id!,
                          isPickup: context
                                      .read<DeliveryInfoActionCubit>()
                                      .selectedBranch
                                      .id ==
                                  null
                              ? 0
                              : 1,
                          branchId: context
                              .read<DeliveryInfoActionCubit>()
                              .selectedBranch
                              .id,
                          shipmentId: context
                              .read<DeliveryInfoActionCubit>()
                              .shipmentPrice
                              .data
                              ?.shipmentPrice
                              ?.shipmentId,
                          paymentMethod: 94,
                          productsQu: widget.items
                              .map((item) => item.qty ?? 1)
                              .toList()));
                    }
                  },
                  titleText: 'Confirm',
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
