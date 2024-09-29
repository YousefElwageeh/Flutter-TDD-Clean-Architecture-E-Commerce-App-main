import 'package:equatable/equatable.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';

import '../../../delivery/domain/entities/delivery_info.dart';
import 'order_item.dart';

class OrderDetails extends Equatable {
  final String id;
  final List<OrderItem> orderItems;
  final AddressResponseModel deliveryInfo;
  final num discount;

  const OrderDetails({
    required this.id,
    required this.orderItems,
    required this.deliveryInfo,
    required this.discount,
  });

  @override
  List<Object> get props => [
        id,
      ];
}
