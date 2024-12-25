import 'package:eshop/config/helpers/validators.dart';
import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../core/constant/images.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../profile/presentation/bloc/user/user_bloc.dart';
import '../../../../config/util/widgets/input_form_button.dart';
import '../../../../config/util/widgets/input_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController phoneNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is UserLoading) {
          EasyLoading.show(status: AppLocale.loading.getString(context));
        } else if (state is UserLogged) {
          context.read<CartBloc>().add(const GetCart());
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.home,
            ModalRoute.withName(''),
          );
        } else if (state is UserSignUpFail) {
          EasyLoading.showError(
            state.failure.errorMessage?.response?.data['error']
                    .toString()
                    .replaceAll('{', '')
                    .replaceAll('}', '') ??
                '',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    SizedBox(
                      height: 80,
                      child: Image.asset(kAppLogo),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocale.pleaseUseEmailToCreateAccount
                          .getString(context),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    InputTextFormField(
                      controller: firstNameController,
                      hint: AppLocale.firstName.getString(context),
                      textInputAction: TextInputAction.next,
                      validation: (val) => val == null || val.isEmpty
                          ? 'This field can\'t be empty'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    InputTextFormField(
                      controller: emailController,
                      hint: AppLocale.email.getString(context),
                      textInputAction: TextInputAction.next,
                      validation: (val) => val == null || val.isEmpty
                          ? 'This field can\'t be empty'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    InputTextFormField(
                      controller: phoneNameController,
                      hint: AppLocale.phoneNumber.getString(context),
                      textInputAction: TextInputAction.next,
                      validation: (val) => val == null || val.isEmpty
                          ? 'This field can\'t be empty'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    InputTextFormField(
                      controller: passwordController,
                      hint: AppLocale.password.getString(context),
                      isSecureField: true,
                      textInputAction: TextInputAction.next,
                      validation: Valdiator.validatePassword,
                    ),
                    const SizedBox(height: 12),
                    InputTextFormField(
                      controller: confirmPasswordController,
                      hint: AppLocale.confirmPassword.getString(context),
                      isSecureField: true,
                      textInputAction: TextInputAction.go,
                      validation: (val) {
                        return passwordController.text !=
                                confirmPasswordController.text
                            ? AppLocale.passwordsDoNotMatch.getString(context)
                            : null;
                      },
                      onFieldSubmitted: (_) {
                        if (_formKey.currentState!.validate()) {
                          context.read<UserBloc>().add(
                                SignUpUser(
                                  SignUpParams(
                                    name: firstNameController.text,
                                    phone: phoneNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                ),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                    InputFormButton(
                      color: ColorsManger.primaryColor,
                      onClick: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<UserBloc>().add(
                                SignUpUser(
                                  SignUpParams(
                                    name: firstNameController.text,
                                    phone: phoneNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ),
                                ),
                              );
                        }
                      },
                      titleText: AppLocale.signUp.getString(context),
                    ),
                    // const SizedBox(height: 10),
                    // InputFormButton(
                    //   color: Colors.black87,
                    //   onClick: () => Navigator.of(context).pop(),
                    //   titleText: AppLocale.back.getString(context),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
