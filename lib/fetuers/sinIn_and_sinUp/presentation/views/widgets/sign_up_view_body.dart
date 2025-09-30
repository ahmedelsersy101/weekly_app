import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_form_field.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/icons_login_buttons_and_text_ontap_signup.dart';

class SignUpViewBody extends StatelessWidget {
  const SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 34),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(title: 'Full name', hintText: 'Name'),
                const SizedBox(height: 16),
                CustomTextFormField(
                  title: 'Email',
                  hintText: 'example@example.com',
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  title: 'Password',
                  hintText: '*************',
                ),
                const SizedBox(height: 48),
                const IconsLoginAndSignupButtonsAndTextOntapLoginAndSignup(
                  titleButton: 'Sign Up',
                  textOntap: 'Log in',
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
