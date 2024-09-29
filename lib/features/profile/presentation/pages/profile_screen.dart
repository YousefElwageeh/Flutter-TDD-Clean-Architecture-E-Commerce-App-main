import 'package:eshop/core/constant/images.dart';
import 'package:eshop/features/profile/data/models/update_profile_request.dart';
import 'package:eshop/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:eshop/features/profile/presentation/bloc/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../../config/util/widgets/input_form_button.dart';
import '../../../../config/util/widgets/input_text_form_field.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController email = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.user.name ?? '';
    phoneController.text = widget.user.phone ?? '';
    email.text = widget.user.email ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Hero(
                      tag: "C001",
                      child: CircleAvatar(
                        radius: 75.0,
                        backgroundColor: Colors.grey.shade200,
                        child: Image.asset(kUserAvatar),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     selectSourceImageBottomSheet(context);
                    //     //   GO.toNamed(AppPageRoute.updateProfile);
                    //   },
                    //   child: Container(
                    //       width: 25,
                    //       height: 25,
                    //       decoration: const BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Colors.blue,
                    //       ),
                    //       child: const Icon(Icons.edit,
                    //           size: 17, color: Colors.black)),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              InputTextFormField(
                controller: firstNameController,
                hint: 'First Name',
              ),
              const SizedBox(
                height: 12,
              ),
              InputTextFormField(
                controller: email,
                hint: 'Email Address',
              ),
              const SizedBox(
                height: 12,
              ),
              InputTextFormField(
                controller: phoneController,
                hint: 'phone',
              ),
              const SizedBox(
                height: 12,
              ),

              // InputTextFormField(
              //   controller: firstNameController,
              //   hint: 'Contact Number',
              // ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return InputFormButton(
                onClick: () {
                  context
                      .read<ProfileCubit>()
                      .updateProfile(UpdateProfileRequest(
                        name: firstNameController.text,
                        email: email.text,
                        phone: phoneController.text,
                      ))
                      .then((v) {
                    context.read<UserBloc>().add(CheckUser());
                  });
                },
                titleText: "Update",
                color: Colors.black87,
              );
            },
          ),
        )),
      ),
    );
  }
}

selectSourceImageBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
        height: 100,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () async {
                            const permission = Permission.camera;
                            if (await permission.isDenied) {
                              await permission.request();
                            }

                            context
                                .read<ProfileCubit>()
                                .pickAnImage(source: ImageSource.camera);
                            // Navigator.pop(context);
                          },
                          icon: const Icon(Icons.camera)),
                      const Text('Camera')
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            context
                                .read<ProfileCubit>()
                                .pickAnImage(source: ImageSource.gallery);

                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.image)),
                      const Text('Gallery')
                    ],
                  ),
                ],
              );
            },
          ),
        )),
  );
}
