import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/app_colors.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController controller =
  Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  const SizedBox(height: 42),

                  _buildEmailField(),

                  const SizedBox(height: 24),

                  _buildPasswordField(),

                  const SizedBox(height: 30),

                  _buildLoginButton(),

                  const SizedBox(height: 34),

                  _buildForgotPassword(),

                  const SizedBox(height: 42),

                  _buildDivider(),

                  const SizedBox(height: 30),

                  _buildContactSection(),

                  SizedBox(
                    height: size.height > 700 ? 0 : 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WELCOME TO',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 8),

        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'HK DigiVerse ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: 'HRMS',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Login to manage your work, attendance, and more.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // EMAIL
  // ----------------------------------------------------------

  Widget _buildEmailField() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: TextField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.mail_outline_rounded,
            color: AppColors.icon,
            size: 23,
          ),
          hintText: 'Email Address',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: AppColors.textLight,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 8,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // PASSWORD
  // ----------------------------------------------------------

  Widget _buildPasswordField() {
    return Obx(
          () => Container(
        height: 58,
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: TextField(
          controller: controller.passwordController,
          obscureText: controller.obscurePassword.value,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => controller.login(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,

            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: AppColors.icon,
              size: 23,
            ),

            hintText: 'Password',
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.textLight,
            ),

            contentPadding: const EdgeInsets.symmetric(
              vertical: 18,
              horizontal: 8,
            ),

            suffixIcon: IconButton(
              onPressed: controller.togglePasswordVisibility,
              icon: Icon(
                controller.obscurePassword.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: 21,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // LOGIN BUTTON
  // ----------------------------------------------------------

  Widget _buildLoginButton() {
    return Obx(
          () => SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          onPressed:
          controller.isLoading.value
              ? null
              : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor:
            AppColors.primary.withValues(alpha: 0.6),
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor:
            AppColors.primary.withValues(alpha: 0.35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_rounded,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // FORGOT PASSWORD
  // ----------------------------------------------------------

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: controller.forgotPassword,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // DIVIDER
  // ----------------------------------------------------------

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.border,
    );
  }

  // ----------------------------------------------------------
  // CONTACT
  // ----------------------------------------------------------

  Widget _buildContactSection() {
    return Center(
      child: Column(
        children: [
          const Text(
            'If you want account access so contact',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: controller.contactHR,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.mail_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),

                  const SizedBox(width: 9),

                  const Text(
                    'hr@hkdigiverse.com',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}