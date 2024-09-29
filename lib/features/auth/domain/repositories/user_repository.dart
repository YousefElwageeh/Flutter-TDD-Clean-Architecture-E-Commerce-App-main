import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../usecases/sign_in_usecase.dart';
import '../usecases/sign_up_usecase.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> signIn(SignInParams params);
  Future<Either<Failure, User>> signUp(SignUpParams params);
  Future<Either<Failure, NoParams>> signOut();
  Future<Either<Failure, User>> getCachedUser();
  Future<Either<Failure, Response>> sendOTP(String email);
}
