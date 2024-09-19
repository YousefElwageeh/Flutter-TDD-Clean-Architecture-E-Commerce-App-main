import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:eshop/core/network/network_info.dart';
import 'package:eshop/data/data_sources/local/user_local_data_source.dart';
import 'package:eshop/data/models/user/user_model.dart';
import 'package:eshop/domain/entities/user/user.dart';
import 'package:flutter/material.dart';

import 'package:eshop/core/error/failures.dart';
import 'package:eshop/data/data_sources/remote/profile_data_source.dart';
import 'package:eshop/data/models/profile/update_profile_request.dart';

typedef _DataSourceChooser = Future<UserModel> Function();

class ProfileRepoImplmenter {
  ProfileRemoteDataSourceImpl profileRemoteDataSource;
  final UserLocalDataSource localDataSource;
  ProfileRepoImplmenter({
    required this.profileRemoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, UserModel>> updateProfile(
      {required UpdateProfileRequest updateUserRequest}) async {
    try {
      UserModel result = await profileRemoteDataSource.updateProfile(
          updateUserRequest: updateUserRequest);
      localDataSource.saveUser(result);

      return Right(result);
    } catch (e) {
      debugPrint(e.toString());
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, Response<dynamic>>> deleteUser() async {
    try {
      return Right(await profileRemoteDataSource.deleteUser());
    } catch (e) {
      debugPrint(e.toString());
      return Left(ServerFailure());
    }
  }
}
