import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:eshop/features/delivery/data/models/add_address_request.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';

import '../../../../config/util/widgets/delivery_info_card.dart';
import '../../../../config/util/widgets/input_form_button.dart';
import '../../../../config/util/widgets/input_text_form_field.dart';
import '../../../../core/constant/images.dart';
import '../bloc/delivery_info_action/delivery_info_action_cubit.dart';
import '../bloc/delivery_info_fetch/delivery_info_fetch_cubit.dart';

class DeliveryInfoView extends StatefulWidget {
  bool isFromCheckout;
  DeliveryInfoView({
    super.key,
    required this.isFromCheckout,
  });

  @override
  State<DeliveryInfoView> createState() => _DeliveryInfoViewState();
}

class _DeliveryInfoViewState extends State<DeliveryInfoView> {
  @override
  void initState() {
    context.read<DeliveryInfoActionCubit>().getCountries();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryInfoActionCubit, DeliveryInfoActionState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is DeliveryInfoActionLoading) {
          EasyLoading.show(status: 'Loading...');
        } else if (state is DeliveryInfoSelectActionSuccess) {
          context
              .read<DeliveryInfoFetchCubit>()
              .selectDeliveryInfo(state.deliveryInfo);
        } else if (state is DeliveryInfoActionFail) {
          EasyLoading.showError("Error");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Delivery Details"),
        ),
        body: BlocBuilder<DeliveryInfoFetchCubit, DeliveryInfoFetchState>(
          builder: (context, state) {
            if (state is! DeliveryInfoFetchLoading &&
                state.deliveryInformation.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kEmptyDeliveryInfo),
                  const Text("Delivery information are Empty!"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              );
            }
            return RefreshIndicator.adaptive(
              onRefresh: () {
                context.read<DeliveryInfoFetchCubit>().fetchDeliveryInfo();

                return Future.value();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: (state is DeliveryInfoFetchLoading &&
                        state.deliveryInformation.isEmpty)
                    ? 5
                    : state.deliveryInformation.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemBuilder: (context, index) => (state
                            is DeliveryInfoFetchLoading &&
                        state.deliveryInformation.isEmpty)
                    ? DeliveryInfoCard()
                    : DeliveryInfoCard(
                        deliveryInformation: state.deliveryInformation[index],
                        isSelected: state.deliveryInformation[index].id ==
                            context
                                .read<DeliveryInfoActionCubit>()
                                .selectedDlivery
                                .id,
                      ),
              ),
            );
          },
        ),
        floatingActionButton: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.isFromCheckout
                    ? FloatingActionButton(
                        onPressed: () {
                          if (context
                                  .read<DeliveryInfoActionCubit>()
                                  .selectedDlivery
                                  .id !=
                              null) {
                            context
                                .read<DeliveryInfoActionCubit>()
                                .updateVATWidget();

                            Navigator.pop(context);
                          } else {
                            EasyLoading.showError(
                                "Please select a Delivery Info");
                          }
                        },
                        child: const Icon(Icons.done),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 20,
                ),
                FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      builder: (BuildContext context) {
                        return const DeliveryInfoForm();
                      },
                    );
                  },
                  tooltip: 'Increment',
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeliveryInfoForm extends StatefulWidget {
  final AddressResponseModel? deliveryInfo;
  const DeliveryInfoForm({
    super.key,
    this.deliveryInfo,
  });

  @override
  State<DeliveryInfoForm> createState() => _DeliveryInfoFormState();
}

class _DeliveryInfoFormState extends State<DeliveryInfoForm> {
  String? id;
  String countryName = '';
  final TextEditingController addressLineOne = TextEditingController();
  String city = '';
  final TextEditingController contactNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.deliveryInfo != null) {
      id = widget.deliveryInfo?.id.toString() ?? '';
      countryName = widget.deliveryInfo!.country ?? "";
      // lastName.text = widget.deliveryInfo!.city ?? '';
      addressLineOne.text = widget.deliveryInfo!.address ?? '';
      // addressLineTwo.text = widget.deliveryInfo!.addressLineTwo;
      city = widget.deliveryInfo!.city ?? '';
      // zipCode.text = widget.deliveryInfo!.zipCode;
      contactNumber.text = widget.deliveryInfo!.phone ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryInfoActionCubit, DeliveryInfoActionState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is DeliveryInfoActionLoading) {
          EasyLoading.show(status: 'Loading...');
        } else if (state is DeliveryInfoAddActionSuccess) {
          Navigator.of(context).pop();
          context
              .read<DeliveryInfoFetchCubit>()
              .addDeliveryInfo(state.deliveryInfo);
          EasyLoading.showSuccess("Delivery info successfully added!");
        } else if (state is DeliveryInfoEditActionSuccess) {
          Navigator.of(context).pop();
          context
              .read<DeliveryInfoFetchCubit>()
              .editDeliveryInfo(state.deliveryInfo);
          EasyLoading.showSuccess("Delivery info successfully edited!");
        } else if (state is DeliveryInfoActionFail) {
          EasyLoading.showError("Error");
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const SizedBox(
                    height: 24,
                  ),
                  DropdownMenu<String>(
                    label: Text(countryName),
                    width: double.infinity,
                    dropdownMenuEntries: context
                            .read<DeliveryInfoActionCubit>()
                            .countries
                            .country
                            ?.map<DropdownMenuEntry<String>>(
                              (e) => DropdownMenuEntry(
                                label: e.countryName ?? '',
                                value: e.id.toString() ?? '',
                              ),
                            )
                            .toList() ??
                        [],
                    onSelected: (value) {
                      context
                          .read<DeliveryInfoActionCubit>()
                          .selectCountry(value ?? '');
                      context
                          .read<DeliveryInfoActionCubit>()
                          .getCiteies(value ?? '');
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<DeliveryInfoActionCubit, DeliveryInfoActionState>(
                    builder: (context, state) {
                      return DropdownMenu<String>(
                        label: Text(city),
                        width: double.infinity,
                        dropdownMenuEntries: context
                                .read<DeliveryInfoActionCubit>()
                                .cities
                                .city
                                ?.map<DropdownMenuEntry<String>>(
                                  (e) => DropdownMenuEntry(
                                    label: e.name ?? '',
                                    value: e.id.toString() ?? '',
                                  ),
                                )
                                .toList() ??
                            [],
                        onSelected: (value) {
                          context
                              .read<DeliveryInfoActionCubit>()
                              .selectCity(value ?? '');
                        },
                      );
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  InputTextFormField(
                    controller: addressLineOne,
                    hint: 'Address line one',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // InputTextFormField(
                  //   controller: addressLineTwo,
                  //   hint: 'Address line two',
                  //   contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  //   validation: (String? val) {
                  //     if (val == null || val.isEmpty) {
                  //       return 'This field can\'t be empty';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(
                    height: 10,
                  ),

                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // InputTextFormField(
                  //   controller: zipCode,
                  //   hint: 'Zip code',
                  //   contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  //   validation: (String? val) {
                  //     if (val == null || val.isEmpty) {
                  //       return 'This field can\'t be empty';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputTextFormField(
                    controller: contactNumber,
                    hint: 'Contact number',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return 'This field can\'t be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.deliveryInfo == null) {
                          context
                              .read<DeliveryInfoActionCubit>()
                              .addDeliveryInfo(AddressRequestModel(
                                id: '',
                                // lastName: lastName.text,
                                address: addressLineOne.text,
                                // country: addressLineTwo.text,

                                // zipCode: zipCode.text,
                                phone: contactNumber.text,
                              ));
                        } else {
                          context
                              .read<DeliveryInfoActionCubit>()
                              .editDeliveryInfo(AddressRequestModel(
                                id: id!,

                                // lastName: lastName.text,
                                address: addressLineOne.text,
                                //  country: addressLineTwo.text,

                                // zipCode: zipCode.text,
                                phone: contactNumber.text,
                              ));
                        }
                      }
                    },
                    titleText: widget.deliveryInfo == null ? 'Save' : 'Update',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                    titleText: 'Cancel',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
