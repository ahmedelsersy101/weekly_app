import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/utils/app_style.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_form_field.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_on_tap.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/icons_login_buttons_and_text_ontap_signup.dart';

class LogInViewBody extends StatelessWidget {
  const LogInViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome', style: AppStyles.styleSemiBold24(context)),
              const SizedBox(height: 24),
              CustomTextFormField(
                title: 'Email or Mobile Number',
                hintText: 'example@example.com',
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                title: 'Password',
                hintText: '   *************',
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                widthFactor: 3.7,
                child: CustomTextOnTap(onTap: () {}),
              ),
              const SizedBox(height: 48),
              const IconsLoginAndSignupButtonsAndTextOntapLoginAndSignup(
                textOntap: 'Sign Up',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
