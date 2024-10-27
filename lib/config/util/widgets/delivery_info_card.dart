import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/core/extension/string_extension.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';
import 'package:eshop/features/delivery/presentation/bloc/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shimmer/shimmer.dart';

import '../../../features/delivery/presentation/bloc/delivery_info_action/delivery_info_action_cubit.dart';
import '../../../features/delivery/presentation/pages/delivery_info.dart';
import 'outline_label_card.dart';

class DeliveryInfoCard extends StatelessWidget {
  final AddressResponseModel? deliveryInformation;
  bool isSelected = false;
  DeliveryInfoCard(
      {super.key, this.deliveryInformation, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    if (deliveryInformation != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: () {
            context
                .read<DeliveryInfoActionCubit>()
                .selectDeliveryInfo(deliveryInformation!);
          },
          child: OutlineLabelCard(
            title: '',
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.edit_location),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${deliveryInformation!.country?.capitalize()} ${deliveryInformation!.city}, ${deliveryInformation!.phone}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${deliveryInformation!.address}, ",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<DeliveryInfoActionCubit>()
                                  .getCiteies(deliveryInformation?.countryId
                                          .toString() ??
                                      '');
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                builder: (BuildContext context) {
                                  return DeliveryInfoForm(
                                    deliveryInfo: deliveryInformation,
                                  );
                                },
                              );
                            },
                            child: Text(
                              AppLocale.edit.getString(context),
                              style: const TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    child: Center(
                      child: isSelected
                          ? Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(42),
                                color: Colors.black87,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          context
                              .read<DeliveryInfoFetchCubit>()
                              .deleteDeliveryAdderss(
                                  deliveryInformation!.id.toString());
                        },
                        icon: const Icon(Icons.remove_circle_outline)),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(12)),
            child: Container(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 6,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.edit_location),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 14,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 18,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
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
}
