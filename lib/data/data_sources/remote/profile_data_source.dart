import 'package:dio/dio.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/data/models/profile/update_profile_request.dart';
import 'package:eshop/data/models/user/user_model.dart';
import 'package:eshop/domain/entities/user/user.dart';

class ProfileRemoteDataSourceImpl {
  Future<UserModel> updateProfile(
      {required UpdateProfileRequest updateUserRequest}) async {
    var result = await DioFactory.postdata(
      url: EndPoints.editprofile,
      data: await updateUserRequest.toMap(),
    );
    return UserModel.fromJson(result.data["user"]);
  }

  @override
  Future<Response> deleteUser() async {
    var result = await DioFactory.delteData(
      url: EndPoints.deleteprofile,
    );
    return result;
  }
}
