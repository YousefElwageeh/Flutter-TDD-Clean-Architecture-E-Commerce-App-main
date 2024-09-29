import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';
import 'package:eshop/core/usecases/usecase.dart';
import 'package:eshop/features/auth/data/models/user_model.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/authentication_response_model.dart';

typedef _DataSourceChooser = Future<UserModel> Function();

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> signIn(params) async {
    return await _authenticate(() {
      return remoteDataSource.signIn(params);
    });
  }

  @override
  Future<Either<Failure, User>> signUp(params) async {
    return await _authenticate(() {
      return remoteDataSource.signUp(params);
    });
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, NoParams>> signOut() async {
    try {
      await localDataSource.clearCache();
      return Right(NoParams());
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, User>> _authenticate(
    _DataSourceChooser getDataSource,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await getDataSource();
        localDataSource.saveToken(remoteResponse.token ?? "");
        localDataSource.saveUser(remoteResponse);
        return Right(remoteResponse);
      } on Failure catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Response>> sendOTP(String email) async {
    try {
      return Right(await remoteDataSource.sendOTP(email));
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}
