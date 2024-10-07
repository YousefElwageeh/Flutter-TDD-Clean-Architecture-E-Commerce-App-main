import 'package:dio/dio.dart' as dio;
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> signIn(SignInParams params);
  Future<UserModel> signUp(SignUpParams params);

  Future<dio.Response> sendOTP(String email);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signIn(SignInParams params) async {
    var result = await DioFactory.postdata(url: EndPoints.login, data: {
      'email': params.username,
      'password': params.password,
    });
    return UserModel.fromJson(result.data["success"]);

    // final response =
    //     await client.post(Uri.parse('$baseUrl/api/login'),
    //         headers: {
    //           'Content-Type': 'application/json',
    //         },
    //         body: json.encode({
    //           'email': params.username,
    //           'password': params.password,
    //         }));
    // if (response.statusCode == 200) {
    //   return UserModel.fr(response.body);
    // } else if (response.statusCode == 400 || response.statusCode == 401) {
    //   throw CredentialFailure();
    // } else {
    //   throw ServerException();
    // }
  }

  @override
  Future<UserModel> signUp(SignUpParams params) async {
    var result = await DioFactory.postdata(
        url: EndPoints.register, data: params.toMap());
    return UserModel.fromJson(result.data["success"]);
  }

  @override
  Future<dio.Response> sendOTP(String email) async {
    final response = await DioFactory.postdata(url: EndPoints.sendOTp, data: {
      "email": email,
    });
    return response;
  }
}
