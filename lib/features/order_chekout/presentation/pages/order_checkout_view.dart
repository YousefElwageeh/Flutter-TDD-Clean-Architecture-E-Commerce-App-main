import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/config/helpers/spacing.dart';
import 'package:eshop/config/locale/tranlslations.dart';
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
import 'package:flutter_localization/flutter_localization.dart';
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
    DropdownMenuEntry(
      value: 'Pick up',
      label: isArabic() ? 'استلام' : AppLocale.pickUp,
    ),
  ];
  double? totalPrice;

  @override
  void initState() {
    totalPrice = widget.items.fold(
      0.0,
      (previousValue, element) => element.price!.toDouble() + previousValue!,
    );

    if (totalPrice! > 1000) {
      options.add(DropdownMenuEntry(
        value: 'Delivery',
        label: isArabic() ? 'توصيل' : AppLocale.delivery,
      ));
      final deliveryCubit = context.read<DeliveryInfoActionCubit>();
      deliveryCubit.selectedPaymentMethode = '';
      deliveryCubit.deliveryPrice = '';
      deliveryCubit.selectedBranch = NearestBrancheModel();
      deliveryCubit.selectedDlivery = AddressResponseModel();
    }

    super.initState();
    context.read<DeliveryInfoActionCubit>().getpaymentOption();
    context.read<DeliveryInfoActionCubit>().getVat();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<OrderAddCubit>(),
      child: BlocListener<OrderAddCubit, OrderAddState>(
        listener: (context, state) {
          EasyLoading.dismiss();
          if (state is OrderAddLoading) {
            EasyLoading.show(status: AppLocale.loading.getString(context));
          }
          if (state is OrderAddSuccess) {
            context.read<NavbarCubit>().update(0);
            context.read<NavbarCubit>().controller.jumpToPage(0);
          } else if (state is OrderAddFail) {
            EasyLoading.showError(AppLocale.error.getString(context));
          } else if (state is OrderGetWebViewSuccess) {
            Navigator.of(context).pushNamed(
              AppRouter.webView,
              arguments: context.read<OrderAddCubit>().webViewUrl,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(AppLocale.orderCheckoutTitle.getString(context)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                DropdownMenu(
                  label:
                      Text(AppLocale.chooseDeliveryMethod.getString(context)),
                  width: double.infinity,
                  onSelected: (value) {
                    if (value == 'Delivery') {
                      Navigator.of(context).pushNamed(
                        AppRouter.deliveryDetails,
                        arguments: true,
                      );
                    } else if (value == 'Pick up') {
                      Navigator.of(context).pushNamed(AppRouter.pickUp);
                    }
                  },
                  dropdownMenuEntries: options,
                ),
                const SizedBox(height: 10),
                BlocBuilder<DeliveryInfoActionCubit, DeliveryInfoActionState>(
                  builder: (context, state) {
                    return DropdownMenu(
                      label: Text(
                          AppLocale.choosePaymentMethod.getString(context)),
                      width: double.infinity,
                      onSelected: (value) {
                        context
                            .read<DeliveryInfoActionCubit>()
                            .selectedPaymentMethode = value;
                        log(context
                            .read<DeliveryInfoActionCubit>()
                            .selectedPaymentMethode);
                      },
                      dropdownMenuEntries:
                          context.read<DeliveryInfoActionCubit>().paymentOption,
                    );
                  },
                ),
                const SizedBox(height: 16),
                OutlineLabelCard(
                  title: AppLocale.selectedProducts.getString(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 8),
                    child: Column(
                      children: widget.items.map((product) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 75,
                                child: AspectRatio(
                                  aspectRatio: 0.88,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl: product.item?.photo ?? '',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.item?.name ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text('\$${product.price}')
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlineLabelCard(
                  title: AppLocale.orderSummary.getString(context),
                  child: _buildOrderSummary(context),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: InputFormButton(
                color: Colors.black87,
                onClick: () => _onConfirm(context),
                titleText: AppLocale.confirm.getString(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryRow(
            AppLocale.totalProducts.getString(context),
            "x${widget.items.length}",
          ),
          BlocBuilder<DeliveryInfoActionCubit, DeliveryInfoActionState>(
            builder: (context, state) {
              if (state is OrderGEtVatSuccess) {
                double vatValue = ((state.vatValue / 100) * (totalPrice ?? 0));
                if (state.updateTotalPrice) {
                  totalPrice = (totalPrice ?? 0) + vatValue;
                }
                totalPrice = double.parse(totalPrice!.toStringAsFixed(1));
                log('Vat  $vatValue');

                log('totalPrice $totalPrice');

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${AppLocale.vatPercentage.getString(context)} ${state.vatValue}%"),
                    Text("\$${vatValue.toStringAsFixed(2)}")
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<DeliveryInfoActionCubit, DeliveryInfoActionState>(
            builder: (context, state) {
              return _buildSummaryRow(
                AppLocale.totalPrice.getString(context),
                "\$${totalPrice!.toStringAsFixed(1)}",
              );
            },
          ),
        ],
      ),
    );
  }

  Row _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text(value)],
    );
  }

  void _onConfirm(BuildContext context) {
    final deliveryInfoFetchCubit = context.read<DeliveryInfoFetchCubit>();
    final deliveryInfoActionCubit = context.read<DeliveryInfoActionCubit>();

    if (deliveryInfoFetchCubit.state.selectedDeliveryInformation?.id == null &&
        deliveryInfoActionCubit.selectedBranch.id == null) {
      EasyLoading.showError(
          AppLocale.pleaseSelectDeliveryMethod.getString(context));
    } else if (deliveryInfoActionCubit.selectedPaymentMethode.isEmpty) {
      EasyLoading.showError(
          AppLocale.pleaseSelectPaymentMethod.getString(context));
    } else {
      context.read<OrderAddCubit>().addOrder(
          OrderRequestModel(
              productsId: widget.items.map((item) => item.item!.id!).toList(),
              addressId: context
                  .read<DeliveryInfoFetchCubit>()
                  .state
                  .selectedDeliveryInformation
                  ?.id!,
              isPickup:
                  context.read<DeliveryInfoActionCubit>().selectedBranch.id ==
                          null
                      ? 0
                      : 1,
              branchId:
                  context.read<DeliveryInfoActionCubit>().selectedBranch.id,
              shipmentId: context
                  .read<DeliveryInfoActionCubit>()
                  .shipmentPrice
                  .data
                  ?.shipmentPrice
                  ?.shipmentId,
              paymentMethod: int.parse(context
                  .read<DeliveryInfoActionCubit>()
                  .selectedPaymentMethode),
              productsQu: widget.items.map((item) => item.qty ?? 1).toList()),
          onSuccess: () {
        if (context.read<DeliveryInfoActionCubit>().selectedPaymentMethode ==
            '94') {
          Navigator.of(context).pop();
          context.read<CartBloc>().add(const ClearCart());
        }
      });
    }
  }
}

isArabic() {
  FlutterLocalization localization = FlutterLocalization.instance;
  return localization.currentLocale.localeIdentifier == 'ar';
}
