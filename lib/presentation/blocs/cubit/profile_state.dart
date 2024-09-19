part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

class UserUpdateProfileLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

class UserUpdateProfileSuccess extends ProfileState {
  @override
  List<Object> get props => [];
}

class UserUpdateProfileError extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileImagePicked extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileImageLoading extends ProfileState {
  @override
  List<Object> get props => [];
}
