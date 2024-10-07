import 'package:dio/dio.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/features/delivery/data/models/add_address_request.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';
import 'package:eshop/features/delivery/data/models/cities_model.dart';
import 'package:eshop/features/delivery/data/models/countries_model.dart';
import 'package:eshop/features/delivery/data/models/nearest_branches.dart';
import 'package:eshop/features/delivery/data/models/shipmet_price_model.dart';
import 'package:http/http.dart' as http;

abstract class DeliveryInfoRemoteDataSource {
  Future<List<AddressResponseModel>> getDeliveryInfo();
  Future<AddressResponseModel> addDeliveryInfo(
      AddressRequestModel addressRequestModel);
  Future<AddressResponseModel> editDeliveryInfo(
      AddressRequestModel addressRequestModel, String adderssID);

  Future<CitiesModel> getCities(String countryId);
  Future<CountriesModel> getCountrys();
  Future<List<NearestBrancheModel>> getNearictsBranches(
      double lat, double long);
  Future<Response> deleteDeliveryAdderss(String deliveryID);

  Future<ShipmentPriceModel> getDeliveryPriceDependsOnZone(String cityId);
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

  @override
  Future<CitiesModel> getCities(String countryId) async {
    final result = await DioFactory.getdata(
      url: '${EndPoints.city}/$countryId',
    );
    return CitiesModel.fromJson(result.data);
  }

  @override
  Future<CountriesModel> getCountrys() async {
    final result = await DioFactory.getdata(
      url: EndPoints.countries,
    );
    return CountriesModel.fromJson(result.data);
  }

  @override
  Future<List<NearestBrancheModel>> getNearictsBranches(
      double lat, double long) async {
    final result =
        await DioFactory.getdata(url: EndPoints.nearestBranches, quary: {
      "latitude": lat,
      "longitude": long,
    });
    return List<NearestBrancheModel>.from(
        result.data!.map((x) => NearestBrancheModel.fromJson(x)));
  }

  @override
  Future<ShipmentPriceModel> getDeliveryPriceDependsOnZone(
      String cityId) async {
    final result = await DioFactory.getdata(
      url: EndPoints.shippingprice + cityId,
    );
    return ShipmentPriceModel.fromJson(result.data);
  }

  @override
  Future<Response> deleteDeliveryAdderss(String deliveryID) async {
    final result = await DioFactory.delteData(
      url: '${EndPoints.addresses}/$deliveryID',
    );
    return result;
  }
}
