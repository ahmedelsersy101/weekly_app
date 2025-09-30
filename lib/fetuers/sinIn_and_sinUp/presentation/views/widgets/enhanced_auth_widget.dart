import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/constants/app_color.dart';
import 'package:weekly_dash_board/core/constants/app_images.dart';
import 'package:weekly_dash_board/core/utils/app_style.dart';
import 'package:weekly_dash_board/core/widgets/custom_button.dart';
import 'package:weekly_dash_board/core/widgets/custom_button_model.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_on_tap.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/custom_icon_log_in.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/sign_up_view.dart';
import 'package:weekly_dash_board/core/services/supabase_auth_service.dart';
import 'package:weekly_dash_board/core/utils/app_localizations.dart';

class EnhancedAuthWidget extends StatefulWidget {
  const EnhancedAuthWidget({
    super.key,
    this.titleButton,
    this.textOntap,
    this.isSignUp = false,
    this.emailController,
    this.passwordController,
    this.nameController,
  });
  
  final String? titleButton, textOntap;
  final bool isSignUp;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? nameController;

  @override
  State<EnhancedAuthWidget> createState() => _EnhancedAuthWidgetState();
}

class _EnhancedAuthWidgetState extends State<EnhancedAuthWidget> {
  bool _isLoading = false;

  Future<void> _handleAuthentication() async {
    if (widget.emailController == null || widget.passwordController == null) {
      _showSnackBar('Please fill in all required fields');
      return;
    }

    final email = widget.emailController!.text.trim();
    final password = widget.passwordController!.text.trim();
    final name = widget.nameController?.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all required fields');
      return;
    }

    if (widget.isSignUp && (name == null || name.isEmpty)) {
      _showSnackBar('Please enter your full name');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Perform actual Supabase authentication
      if (widget.isSignUp) {
        final response = await SupabaseAuthService.signUp(
          email: email,
          password: password,
          fullName: name,
        );
        
        if (response.user == null) {
          throw Exception('Sign up failed. Please try again.');
        }
      } else {
        final response = await SupabaseAuthService.signIn(
          email: email,
          password: password,
        );
        
        if (response.user == null) {
          throw Exception('Sign in failed. Please try again.');
        }
      }

      if (mounted) {
        _showSnackBar(
          widget.isSignUp 
            ? AppLocalizations.of(context).tr('auth.signUpSuccess')
            : AppLocalizations.of(context).tr('auth.signInSuccess'),
          isSuccess: true,
        );
        
        // Navigate back to settings or previous screen
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = SupabaseAuthService.getErrorMessage(e);
        _showSnackBar('Authentication failed: $errorMessage');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess 
          ? Colors.green 
          : Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CustomButton(
            title: widget.titleButton ?? 'Log In',
            customButtonModel: CustomButtonModel(
              text: widget.titleButton ?? 'Log In',
              buttonColor: AppColors.primary,
              textColor: AppColors.textOnPrimary,
              onPressed: _isLoading ? null : _handleAuthentication,
            ),
          ),
          if (_isLoading) ...[
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
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
                "Don't have an account?",
                style: AppStyles.styleRegular12(context),
              ),
              CustomTextOnTap(
                title: widget.textOntap,
                onTap: () {
                  if (widget.textOntap == 'Log in') {
                    Navigator.of(context).pop();
                  } else if (widget.textOntap == 'Sign Up') {
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
