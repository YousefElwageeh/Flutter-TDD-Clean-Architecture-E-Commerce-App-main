import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SignUpUseCase implements UseCase<User, SignUpParams> {
  final UserRepository repository;
  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await repository.signUp(params);
  }
}

class SignUpParams {
  final String email;
  final String? passwordConfirmation;
  final String name;
  final String password;
  final String phone;

  const SignUpParams({
    required this.email,
    this.passwordConfirmation,
    required this.name,
    required this.password,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'password_confirmation': password});
    result.addAll({'name': name});
    result.addAll({'password': password});
    result.addAll({'phone': phone});
    result.addAll({'country': 'UAE'});

    return result;
  }

  factory SignUpParams.fromMap(Map<String, dynamic> map) {
    return SignUpParams(
      email: map['email'] ?? '',
      passwordConfirmation: map['passwordConfirmation'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpParams.fromJson(String source) =>
      SignUpParams.fromMap(json.decode(source));
}
