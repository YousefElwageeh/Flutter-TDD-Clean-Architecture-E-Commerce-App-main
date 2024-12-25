import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/config/theme/colors.dart';
import 'package:eshop/features/home/presentation/bloc/navbar_cubit.dart';
import 'package:eshop/features/order/presentation/bloc/order_fetch/order_fetch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';

import '../../../../core/constant/images.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../delivery/presentation/bloc/delivery_info_fetch/delivery_info_fetch_cubit.dart';
import '../../../profile/presentation/bloc/user/user_bloc.dart';
import '../../../../config/util/widgets/input_form_button.dart';
import '../../../../config/util/widgets/input_text_form_field.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is UserLoading) {
          EasyLoading.show(
              status: AppLocale.loading
                  .getString(context)); // Add loading status here
        } else if (state is UserLogged) {
          context.read<CartBloc>().add(const GetCart());
          context.read<DeliveryInfoFetchCubit>().fetchDeliveryInfo();
          context.read<OrderFetchCubit>().getOrders();
          context.read<NavbarCubit>().update(0);
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.home,
            ModalRoute.withName(''),
          );
        } else if (state is UserLoggedFail) {
          if (state.failure.errorMessage?.response?.statusCode == 401) {
            EasyLoading.showError(AppLocale.errorIncorrectCredentials
                .getString(context)); // Update error message
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
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
                    AppLocale.titleSignIn
                        .getString(context), // Replace with localization
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  InputTextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    hint: AppLocale.hintEmail
                        .getString(context), // Replace with localization
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return AppLocale.errorEmptyField
                            .getString(context); // Update error message
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  InputTextFormField(
                    controller: passwordController,
                    textInputAction: TextInputAction.go,
                    hint: AppLocale.hintPassword
                        .getString(context), // Replace with localization
                    isSecureField: true,
                    validation: (String? val) {
                      if (val == null || val.isEmpty) {
                        return AppLocale.errorEmptyField
                            .getString(context); // Update error message
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      if (_formKey.currentState!.validate()) {
                        context.read<UserBloc>().add(SignInUser(SignInParams(
                              username: emailController.text,
                              password: passwordController.text,
                            )));
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.forgetPassword);
                      },
                      child: Text(
                        AppLocale.textForgotPassword
                            .getString(context), // Replace with localization
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InputFormButton(
                    color: ColorsManger.primaryColor,
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<UserBloc>().add(SignInUser(SignInParams(
                              username: emailController.text,
                              password: passwordController.text,
                            )));
                      }
                    },
                    titleText: AppLocale.buttonSignIn
                        .getString(context), // Replace with localization
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocale.textNoAccount
                              .getString(context), // Replace with localization
                          style: const TextStyle(fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouter.signUp);
                          },
                          child: Text(
                            AppLocale.textRegister.getString(
                                context), // Replace with localization
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorsManger.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
