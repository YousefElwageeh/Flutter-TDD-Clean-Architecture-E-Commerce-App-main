import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/core/api/constant&endPoints.dart';
import 'package:eshop/core/api/dio_factory.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/profile/data/models/update_profile_request.dart';
import 'package:eshop/features/profile/data/datasources/profile_repo_impl.dart';
import 'package:eshop/features/auth/domain/repositories/user_repository.dart';
import 'package:eshop/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:eshop/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../../auth/domain/usecases/get_cached_user_usecase.dart';
import '../../../../auth/domain/usecases/sign_in_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCachedUserUseCase _getCachedUserUseCase;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final UserRepository repository = sl();

  UserBloc(
    this._signInUseCase,
    this._getCachedUserUseCase,
    this._signOutUseCase,
    this._signUpUseCase,
  ) : super(UserInitial()) {
    on<SignInUser>(_onSignIn);
    on<SignUpUser>(_onSignUp);
    on<CheckUser>(_onCheckUser);
    on<SignOutUser>(_onSignOut);
  }

  void _onSignIn(SignInUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final result = await _signInUseCase(event.params);
      result.fold(
        (failure) => emit(UserLoggedFail(failure)),
        (user) {
          sl<FlutterSecureStorage>()
              .write(key: Constants.tokenKey, value: user.token);
          Constants.token = user.token;
          DioFactory.getDio();
          emit(UserLogged(user));
        },
      );
    } catch (e) {
      emit(UserLoggedFail(ExceptionFailure()));
    }
  }

  void _onCheckUser(CheckUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final result = await _getCachedUserUseCase(NoParams());
      result.fold((failure) => emit(UserLoggedFail(failure)), (user) {
        // sl<FlutterSecureStorage>()
        //     .write(key: Constants.tokenKey, value: user.token);
        // Constants.token = user.token;
        // DioFactory.getDio();
        emit(UserLogged(user));
      });
    } catch (e) {
      emit(UserLoggedFail(ExceptionFailure()));
    }
  }

  FutureOr<void> _onSignUp(SignUpUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      final result = await _signUpUseCase(event.params);
      result.fold(
        (failure) => emit(UserLoggedFail(failure)),
        (user) {
          sl<FlutterSecureStorage>()
              .write(key: Constants.tokenKey, value: user.token);
          Constants.token = user.token;
          DioFactory.getDio();
          emit(UserLogged(user));
        },
      );
    } catch (e) {
      emit(UserLoggedFail(ExceptionFailure()));
    }
  }

  void _onSignOut(SignOutUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      await _signOutUseCase(NoParams());
      sl<FlutterSecureStorage>().delete(
        key: Constants.tokenKey,
      );
      DioFactory.getDio();

      emit(UserLoggedOut());
    } catch (e) {
      emit(UserLoggedFail(ExceptionFailure()));
    }
  }

  resetPassword(String emailForgotPasswordController) {
    repository
        .sendOTP(emailForgotPasswordController)
        .then((value) => value.fold((error) {}, (data) {
              if (data.data["status"] == "true") {
                EasyLoading.showSuccess(
                  data.data["message"],
                );
              } else {
                EasyLoading.showError(
                  data.data["message"],
                );
              }
            }));
  }
}
