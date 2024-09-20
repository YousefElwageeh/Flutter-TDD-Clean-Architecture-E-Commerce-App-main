import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  String errorMessage = 'something went Wrong';
  Failure({
    this.errorMessage = 'something went Wrong',
  });
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}

class ExceptionFailure extends Failure {}

class CredentialFailure extends Failure {}

class AuthenticationFailure extends Failure {}
