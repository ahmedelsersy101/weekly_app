import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_form_field.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_on_tap.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/enhanced_auth_widget.dart';

class EnhancedLogInViewBody extends StatefulWidget {
  const EnhancedLogInViewBody({super.key});

  @override
  State<EnhancedLogInViewBody> createState() => _EnhancedLogInViewBodyState();
}

class _EnhancedLogInViewBodyState extends State<EnhancedLogInViewBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 24),
              CustomTextFormField(
                title: 'Email or Mobile Number',
                hintText: 'example@example.com',
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                title: 'Password',
                hintText: '   *************',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                widthFactor: 3.7,
                child: CustomTextOnTap(onTap: () {}),
              ),
              const SizedBox(height: 48),
              EnhancedAuthWidget(
                titleButton: 'Log In',
                textOntap: 'Sign Up',
                isSignUp: false,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
