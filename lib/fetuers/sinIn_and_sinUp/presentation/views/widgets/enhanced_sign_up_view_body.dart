import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/widgets/custom_text_form_field.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/enhanced_auth_widget.dart';

class EnhancedSignUpViewBody extends StatefulWidget {
  const EnhancedSignUpViewBody({super.key});

  @override
  State<EnhancedSignUpViewBody> createState() => _EnhancedSignUpViewBodyState();
}

class _EnhancedSignUpViewBodyState extends State<EnhancedSignUpViewBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                CustomTextFormField(
                  title: 'Full name',
                  hintText: 'Name',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  title: 'Email',
                  hintText: 'example@example.com',
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  title: 'Password',
                  hintText: '*************',
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 48),
                EnhancedAuthWidget(
                  titleButton: 'Sign Up',
                  textOntap: 'Log in',
                  isSignUp: true,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  nameController: _nameController,
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
