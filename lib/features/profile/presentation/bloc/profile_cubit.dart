import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/profile/data/models/update_profile_request.dart';
import 'package:eshop/features/profile/data/datasources/profile_repo_impl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  final ProfileRepoImplmenter _profileRepoImplmenter = sl();

  Future<void> updateProfile(UpdateProfileRequest updateUserRequest) async {
    emit(UserUpdateProfileLoading());
    EasyLoading.showToast('loading...');
    await _profileRepoImplmenter
        .updateProfile(updateUserRequest: updateUserRequest)
        .then((value) => value.fold((failure) {
              EasyLoading.showError('Error');
              emit(UserUpdateProfileError());
            }, (data) {
              EasyLoading.showSuccess('User Updated Successfully.');
              emit(UserUpdateProfileSuccess());
            }));
  }
}
