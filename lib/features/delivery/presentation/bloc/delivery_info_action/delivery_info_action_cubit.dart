import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eshop/core/error/failures.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/delivery/data/models/add_address_request.dart';
import 'package:eshop/features/delivery/data/models/address_response_model.dart';
import 'package:eshop/features/delivery/data/models/cities_model.dart';
import 'package:eshop/features/delivery/data/models/countries_model.dart';
import 'package:eshop/features/delivery/data/models/nearest_branches.dart';
import 'package:eshop/features/delivery/domain/repositories/delivery_info_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/models/delivery_info_model.dart';
import '../../../domain/entities/delivery_info.dart';
import '../../../domain/usecases/add_dilivey_info_usecase.dart';
import '../../../domain/usecases/edit_delivery_info_usecase.dart';
import '../../../domain/usecases/select_delivery_info_usecase.dart';

part 'delivery_info_action_state.dart';

///Use to preform delivery information single actions without
///interruption to it's main view cubit's state[DeliveryInfoCubit]
class DeliveryInfoActionCubit extends Cubit<DeliveryInfoActionState> {
  final AddDeliveryInfoUseCase _deliveryInfoAddUsecase;
  final EditDeliveryInfoUseCase _editDeliveryInfoUseCase;
  final SelectDeliveryInfoUseCase _selectDeliveryInfoUseCase;
  final DeliveryInfoRepository repository = sl();

  DeliveryInfoActionCubit(
    this._deliveryInfoAddUsecase,
    this._editDeliveryInfoUseCase,
    this._selectDeliveryInfoUseCase,
  ) : super(DeliveryInfoActionInitial());

  void addDeliveryInfo(AddressRequestModel params) async {
    try {
      params.city = cities.city
          ?.where((element) => element.id.toString() == selectedCityid)
          .first
          .name;
      params.country = countries.country
          ?.where((element) => element.id.toString() == selectedCountryid)
          .first
          .countryName;
      emit(DeliveryInfoActionLoading());
      final result = await _deliveryInfoAddUsecase(params);
      result.fold(
        (failure) => emit(DeliveryInfoActionFail()),
        (deliveryInfo) => emit(DeliveryInfoAddActionSuccess(deliveryInfo)),
      );
    } catch (e) {
      emit(DeliveryInfoActionFail());
    }
  }

  void editDeliveryInfo(AddressRequestModel params) async {
    try {
      params.city = cities.city
          ?.where((element) => element.id.toString() == selectedCityid)
          .first
          .name;
      params.country = countries.country
          ?.where((element) => element.id.toString() == selectedCountryid)
          .first
          .countryName;
      emit(DeliveryInfoActionLoading());
      final result = await _editDeliveryInfoUseCase(params);
      result.fold((failure) => emit(DeliveryInfoActionFail()), (deliveryInfo) {
        log(deliveryInfo.address.toString());
        emit(DeliveryInfoEditActionSuccess(deliveryInfo));
      });
    } catch (e) {
      emit(DeliveryInfoActionFail());
    }
  }

  AddressResponseModel selectedDlivery = AddressResponseModel();

  void selectDeliveryInfo(AddressResponseModel params) async {
    try {
      selectedDlivery = params;
      log(selectedDlivery.toJson().toString() ?? '');
      //   getDeliveryPriceDependsOnZone(params.city ?? '');
      emit(DeliveryInfoSelectActionSuccess(params));
    } catch (e) {
      emit(DeliveryInfoActionFail());
    }
  }

  CitiesModel cities = CitiesModel();
  String selectedCityid = '';

  void getCiteies(String countryId) {
    repository
        .getCities(countryId)
        .then((value) => value.fold((failure) => null, (data) {
              cities = data;
              emit(GetCitiesSuccess());
            }));
  }

  CountriesModel countries = CountriesModel();
  String selectedCountryid = '';
  void getCountries() {
    cities = CitiesModel();
    countries = CountriesModel();
    repository
        .getCountrys()
        .then((value) => value.fold((failure) => null, (data) {
              countries = data;
              log(countries.toJson().toString());
            }));
  }

  void selectCountry(String countryId) {
    selectedCountryid = countryId;
  }

  void selectCity(String cityId) {
    selectedCityid = cityId;
  }

  Position? userLocation;
  List<NearestBrancheModel> nearestBranches = [];
  Future<void> getNearestBranche(context) async {
    emit(GetNearestBrancheLoading());
    bool isLocationPermissionGranted =
        await Permission.location.request().isGranted;
    log(isLocationPermissionGranted.toString());
    // if (!isLocationPermissionGranted) {
    //   return;
    // }
    Position position = await Geolocator.getCurrentPosition();
    userLocation = position;
    repository
        .getNearictsBranches(position.latitude, position.longitude)
        .then((value) => value.fold((failure) {
              markers.clear();

              emit(GetNearestBrancheFail());
            }, (data) async {
              markers.clear();
              nearestBranches = data;
              markers.add(Marker(
                markerId: const MarkerId('MY LOCATION'),
                position: LatLng(position.latitude, position.longitude),
                infoWindow: const InfoWindow(
                  title: 'My Location',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ));
              for (var e in data) {
                markers.add(Marker(
                    markerId: MarkerId(e.id.toString()),
                    position: LatLng(double.parse(e.latitude ?? '0.0'),
                        double.parse(e.longitude ?? '0.0')),
                    infoWindow: InfoWindow(
                      title: "${e.name} Branch",
                    )));
              }
              controller!.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(position.latitude, position.longitude), 14));
              log(markers.toString());
              emit(GetNearestBrancheSuccess());
            }));
  }

  Set<Marker> markers = {};
  GoogleMapController? controller;

  onMapCreated(GoogleMapController googleMapController) {
    controller = googleMapController;
  }

  gotoPoint(double latitude, double longitude) {
    controller!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 14));
  }

  NearestBrancheModel selectedBranch = NearestBrancheModel();
  cahngeSelectedCalue(NearestBrancheModel Branch) {
    selectedBranch = Branch;
    emit(ChangeSelectedValue());
  }

  String deliveryPrice = '';
  void getDeliveryPriceDependsOnZone(String cityId) {
    //   emit(DeliveryInfoActionLoading());

    repository
        .getDeliveryPriceDependsOnZone(cityId)
        .then((value) => value.fold((failure) {}, (data) {
              deliveryPrice = data.data?.shipmentPrice?.value.toString() ?? "";
            }));
  }
}
