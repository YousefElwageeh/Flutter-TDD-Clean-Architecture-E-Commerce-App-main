import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cc_avenue/cc_avenue.dart';
import 'package:ccavenue_unofficial/ccavenue_unofficial.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';
import 'package:eshop/features/delivery/data/models/nearest_branches.dart';
import 'package:eshop/features/cart/data/models/cart_item_model.dart';
import 'package:eshop/features/order_chekout/domain/entities/order_request_model.dart';
import 'package:eshop/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eshop/features/delivery/presentation/bloc/delivery_info_action/delivery_info_action_cubit.dart';
import 'package:eshop/features/home/presentation/bloc/navbar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  @override
  void initState() {
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
            EasyLoading.show(status: 'Loading...');
          } else if (state is OrderAddSuccess) {
            context.read<NavbarCubit>().update(0);
            // context.read<NavbarCubit>().controller.jumpToPage(0);
            // context.read<CartBloc>().add(const ClearCart());
            // Navigator.of(context).pop();
          } else if (state is OrderAddFail) {
            EasyLoading.showError("Error");
          } else if (state is OrderGetWebViewSuccess) {
            Navigator.of(context).pushNamed(AppRouter.webView,
                arguments: context.read<OrderAddCubit>().webViewUrl);
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
                        Navigator.of(context).pushNamed(
                            AppRouter.deliveryDetails,
                            arguments: true);
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
                        BlocBuilder<DeliveryInfoActionCubit,
                            DeliveryInfoActionState>(
                          builder: (context, state) {
                            if (state is OrderGEtVatSuccess) {
                              double vatValue =
                                  ((state.vatValue / 100) * (totalPrice ?? 0));
                              if (state.updateTotalPrice) {
                                totalPrice = (totalPrice ?? 0) + vatValue;
                              }
                              totalPrice =
                                  double.parse(totalPrice!.toStringAsFixed(1));
                              log('Vat  $vatValue');

                              log('totalPrice $totalPrice');

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("VAt Prectage ${state.vatValue}%"),
                                  Text("\$${vatValue.toStringAsFixed(2)}")
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
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
                                    ? Text(
                                        "\$${totalPrice!.toStringAsFixed(1)}")
                                    : Text(
                                        "\$${(totalPrice! + int.parse(context.read<DeliveryInfoActionCubit>().deliveryPrice))}")
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
                    //   _initiateSDK();

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

// Method to initiate the payment
_initiateSDK() async {
  //final ccavenue = CcavenueUnofficial();
  // ccavenue.initiatePayment(
  //     transUrl: 'https://secure.ccavenue.com/transaction/initTrans',
  //     accessCode: 'AVXO05LI16CK65OXKC',
  //     amount: '1',
  //     cancelUrl: 'http://127.0.0.1:3001/ccavResponseHandler',
  //     currencyType: 'INR',
  //     merchantId: '45990',
  //     orderId: '2344',
  //     redirectUrl: 'http://127.0.0.1:3001/ccavResponseHandler',
  //     rsaKeyUrl: 'https://secure.ccavenue.com/transaction/jsp/GetRSA.jsp');
  CcAvenue.cCAvenueInit(
      transUrl: 'https://secure.ccavenue.com/transaction/initTrans',
      accessCode: 'AVXO05LI16CK65OXKC',
      amount: '10',
      cancelUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
      currencyType: 'INR',
      merchantId: '45990',
      orderId: '519',
      redirectUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
      rsaKeyUrl: 'https://secure.ccavenue.com/transaction/jsp/GetRSA.jsp');
  // final Map<String, String> data = {
  //   "mId": "45990", // Your merchant ID
  //   'accessCode': "AVXO05LI16CK65OXKC", // Your access code
  //   'currency': "AED", // Currency for the transaction
  //   'amount': "126", // Amount for the transaction
  //   'redirect_url':
  //       "https://www.linkedin.com/in/yousef-elwageeh/", // Redirect URL after payment
  //   'cancel_url':
  //       "https://www.linkedin.com/in/yousef-elwageeh/", // URL for payment cancellation
  //   'order_id': "627627267222288", // Unique order ID
  //   'customer_id': "728728728", // Customer ID
  //   'tracking_id': "2678278278272", // Tracking ID for the transaction
  //   'request_hash':
  //       "HDUY8WYD8UY8WDU8U38DUE83U8DYU38Y8YF83YF83Y8F383U8", // Request hash
  //   'promo': "", // Promo code if any
  //   'billing_name': "John", // Billing name
  //   'billing_address': "Santacruz", // Billing address
  //   'billing_country': "India", // Billing country
  //   'billing_state': "Maharashtra", // Billing state
  //   'billing_city': "Mumbai", // Billing city
  //   'billing_telephone': "67566523452112", // Billing telephone
  //   'billing_email': "mymail@gmail.com", // Billing email
  //   'shipping_name': "John", // Shipping name
  //   'shipping_address': "Santacruz", // Shipping address
  //   'shipping_country': "India", // Shipping country
  //   'shipping_state': "Maharashtra", // Shipping state
  //   'shipping_city': "Mumbai", // Shipping city
  //   'shipping_telephone': "67566523452112", // Shipping telephone
  //   'merchantParam1': "",
  //   'merchantParam2': "",
  //   'merchantParam3': "",
  //   'merchantParam4': "",
  //   'merchantParam5': "",
  //   'siType': "",
  //   'siRef': "",
  //   'siSetupAmount': "",
  //   'siAmount': "",
  //   'siStartDate': "",
  //   'siFreqType': "",
  //   'siFreq': "",
  //   'siBillCycle': "",
  //   'display_address': "Y", // Show billing address
  // };

  // // Call native code to perform payment
  // final response = await pay(data); // Handle response as per requirement
  // // Optionally, handle the response
  // print(response);
}

// Method to call the native payment method
Future<String> pay(Map<String, String> data) async {
  const MethodChannel channel =
      MethodChannel('plugin_ccavenue'); // Your method channel name
  return await channel.invokeMethod('payCCAvenue', data);
}
