import 'package:eshop/config/locale/tranlslations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:eshop/features/delivery/data/models/add_address_request.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';
import 'package:flutter_localization/flutter_localization.dart';

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
          EasyLoading.show(status: AppLocale.loading.getString(context));
        } else if (state is DeliveryInfoSelectActionSuccess) {
          context
              .read<DeliveryInfoFetchCubit>()
              .selectDeliveryInfo(state.deliveryInfo);
        } else if (state is DeliveryInfoActionFail) {
          EasyLoading.showError(AppLocale.error.getString(context));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocale.deliveryDetails.getString(context)),
        ),
        body: BlocBuilder<DeliveryInfoFetchCubit, DeliveryInfoFetchState>(
          builder: (context, state) {
            if (state is! DeliveryInfoFetchLoading &&
                state.deliveryInformation.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kEmptyDeliveryInfo),
                  Text(AppLocale.deliveryInformationEmpty.getString(context)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              );
            }
            return RefreshIndicator.adaptive(
              onRefresh: () {
                context.read<DeliveryInfoFetchCubit>().fetchDeliveryInfo();
                context.read<DeliveryInfoActionCubit>().getCountries();
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
                            EasyLoading.showError(AppLocale
                                .pleaseSelectDeliveryInfo
                                .getString(context));
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
      addressLineOne.text = widget.deliveryInfo!.address ?? '';
      city = widget.deliveryInfo!.city ?? '';
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
          EasyLoading.show(status: AppLocale.loading.getString(context));
        } else if (state is DeliveryInfoAddActionSuccess) {
          Navigator.of(context).pop();
          context
              .read<DeliveryInfoFetchCubit>()
              .addDeliveryInfo(state.deliveryInfo);
          EasyLoading.showSuccess(
              AppLocale.deliveryInfoSuccessfullyAdded.getString(context));
        } else if (state is DeliveryInfoEditActionSuccess) {
          Navigator.of(context).pop();
          context
              .read<DeliveryInfoFetchCubit>()
              .editDeliveryInfo(state.deliveryInfo);
          EasyLoading.showSuccess(
              AppLocale.deliveryInfoSuccessfullyEdited.getString(context));
        } else if (state is DeliveryInfoActionFail) {
          EasyLoading.showError(AppLocale.error.getString(context));
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
                    hint: AppLocale.addressLineOneHint.getString(context),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return AppLocale.thisFieldCantBeEmpty
                            .getString(context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputTextFormField(
                    controller: contactNumber,
                    hint: AppLocale.contactNumberHint.getString(context),
                    keyboardType: TextInputType.phone,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return AppLocale.thisFieldCantBeEmpty
                            .getString(context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    titleText: widget.deliveryInfo == null
                        ? AppLocale.save.getString(context)
                        : AppLocale.update.getString(context),
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        AddressRequestModel addressRequest =
                            AddressRequestModel(
                          id: id,
                          address: addressLineOne.text,
                          city: city,
                          country: countryName,
                          phone: contactNumber.text,
                        );
                        if (widget.deliveryInfo == null) {
                          context
                              .read<DeliveryInfoActionCubit>()
                              .addDeliveryInfo(addressRequest);
                        } else {
                          context
                              .read<DeliveryInfoActionCubit>()
                              .editDeliveryInfo(addressRequest);
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    titleText: AppLocale.cancel.getString(context),
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 8,
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
