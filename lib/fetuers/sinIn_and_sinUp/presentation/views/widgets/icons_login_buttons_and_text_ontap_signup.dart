import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/constants/app_color.dart';
import 'package:weekly_dash_board/core/constants/app_images.dart';
import 'package:weekly_dash_board/core/utils/app_style.dart';
import 'package:weekly_dash_board/core/widgets/custom_button.dart';
import 'package:weekly_dash_board/core/widgets/custom_button_model.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_on_tap.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/custom_icon_log_in.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/sign_up_view.dart';

class IconsLoginAndSignupButtonsAndTextOntapLoginAndSignup
    extends StatelessWidget {
  const IconsLoginAndSignupButtonsAndTextOntapLoginAndSignup({
    super.key,
    this.titleButton,
    this.textOntap,
  });
  final String? titleButton, textOntap;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CustomButton(
            title: titleButton ?? 'Log In',
            customButtonModel: CustomButtonModel(
              text: titleButton ?? 'Log In',
              buttonColor: AppColors.primary,
              textColor: AppColors.textOnPrimary,
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 16),
          Text('or sign up with', style: AppStyles.styleRegular12(context)),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              CustomIconLogIn(image: Assets.imagesGoogleIcon),
              CustomIconLogIn(image: Assets.imagesFacebookIcon),
              CustomIconLogIn(image: Assets.imagesFingerprintIcon),
            ],
          ),
          const SizedBox(height: 38),
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don’t have an account?',
                style: AppStyles.styleRegular12(context),
              ),
              CustomTextOnTap(
                title: textOntap,
                onTap: () {
                  if (textOntap == 'Log in') {
                    Navigator.of(context).pop();
                  } else if (textOntap == 'Sign Up') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUpView(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
