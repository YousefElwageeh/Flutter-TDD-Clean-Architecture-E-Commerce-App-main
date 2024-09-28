part of 'delivery_info_action_cubit.dart';

@immutable
abstract class DeliveryInfoActionState {}

class DeliveryInfoActionInitial extends DeliveryInfoActionState {}

class DeliveryInfoActionLoading extends DeliveryInfoActionState {}

class DeliveryInfoAddActionSuccess extends DeliveryInfoActionState {
  final AddressResponseModel deliveryInfo;
  DeliveryInfoAddActionSuccess(this.deliveryInfo);
}

class DeliveryInfoEditActionSuccess extends DeliveryInfoActionState {
  final AddressResponseModel deliveryInfo;
  DeliveryInfoEditActionSuccess(this.deliveryInfo);
}

class DeliveryInfoSelectActionSuccess extends DeliveryInfoActionState {
  final AddressResponseModel deliveryInfo;
  DeliveryInfoSelectActionSuccess(this.deliveryInfo);
}

class DeliveryInfoActionFail extends DeliveryInfoActionState {}

class GetCitiesSuccess extends DeliveryInfoActionState {}

class ChangeSelectedValue extends DeliveryInfoActionState {}

class GetNearestBrancheLoading extends DeliveryInfoActionState {}

class GetNearestBrancheSuccess extends DeliveryInfoActionState {}

class GetNearestBrancheFail extends DeliveryInfoActionState {}
