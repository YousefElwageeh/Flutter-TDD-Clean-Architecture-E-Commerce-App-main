import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/data/models/adderss/add_address_request.dart';
import 'package:eshop/data/models/adderss/address_response_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../models/user/delivery_info_model.dart';

abstract class DeliveryInfoRemoteDataSource {
  Future<List<AddressResponseModel>> getDeliveryInfo();
  Future<AddressResponseModel> addDeliveryInfo(
      AddressRequestModel addressRequestModel);
  Future<AddressResponseModel> editDeliveryInfo(
      AddressRequestModel addressRequestModel, String adderssID);
}

class DeliveryInfoRemoteDataSourceImpl implements DeliveryInfoRemoteDataSource {
  final http.Client client;
  DeliveryInfoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<AddressResponseModel>> getDeliveryInfo() async {
    final result = await DioFactory.getdata(url: EndPoints.addresses);
    return List<AddressResponseModel>.from(
        result.data["addresses"]!.map((x) => AddressResponseModel.fromJson(x)));
  }

  @override
  Future<AddressResponseModel> addDeliveryInfo(
      AddressRequestModel addressRequestModel) async {
    final result = await DioFactory.postdata(
        url: EndPoints.addresses, data: addressRequestModel.toJson());
    return AddressResponseModel.fromJson(result.data["address"]);
  }

  @override
  Future<AddressResponseModel> editDeliveryInfo(
      AddressRequestModel addressRequestModel, String adderssID) async {
    final result = await DioFactory.putdata(
        url: '${EndPoints.addresses}/$adderssID',
        data: addressRequestModel.toJson());
    return AddressResponseModel.fromJson(result.data["address"]);
  }
}
