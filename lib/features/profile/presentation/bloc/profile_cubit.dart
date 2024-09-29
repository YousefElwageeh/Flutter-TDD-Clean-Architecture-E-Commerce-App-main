import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eshop/core/services/services_locator.dart';
import 'package:eshop/features/profile/data/models/update_profile_request.dart';
import 'package:eshop/features/profile/data/datasources/profile_repo_impl.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  final ProfileRepoImplmenter _profileRepoImplmenter = sl();

  Future<void> updateProfile(UpdateProfileRequest updateUserRequest) async {
    emit(UserUpdateProfileLoading());

    await _profileRepoImplmenter
        .updateProfile(updateUserRequest: updateUserRequest)
        .then((value) => value.fold((failure) => emit(UserUpdateProfileError()),
            (data) => emit(UserUpdateProfileSuccess())));
  }

  XFile? pickedImage;

  Future<void> pickAnImage({required ImageSource source}) async {
    emit(ProfileImageLoading());
    final ImagePicker picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 40,
    );

    if (file != null) {
      pickedImage = file;

      emit(ProfileImagePicked());
    }
  }
}
