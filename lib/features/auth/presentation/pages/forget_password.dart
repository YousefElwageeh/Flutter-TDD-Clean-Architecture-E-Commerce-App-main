import 'package:eshop/config/locale/tranlslations.dart';
import 'package:eshop/features/profile/presentation/bloc/user/user_bloc.dart';
import 'package:eshop/config/util/widgets/input_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  TextEditingController emailForgotPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 20),
          Form(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                InputTextFormField(
                  controller: emailForgotPasswordController,
                  textInputAction: TextInputAction.next,
                  hint: AppLocale.emailHint.getString(context),
                  validation: (String? val) {
                    if (val == null || val.isEmpty) {
                      return AppLocale.fieldCannotBeEmpty.getString(context);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      context
                          .read<UserBloc>()
                          .resetPassword(emailForgotPasswordController.text);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Text(
                      AppLocale.resetPassword.getString(context),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
