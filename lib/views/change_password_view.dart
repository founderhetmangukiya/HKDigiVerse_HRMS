import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/app_colors.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({super.key});

  final ChangePasswordController controller =
  Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
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
                  _buildBackButton(),

                  const SizedBox(height: 35),

                  _buildHeader(),

                  const SizedBox(height: 40),

                  _buildPasswordField(
                    label: 'Old Password',
                    hint: 'Enter your old password',
                    controller:
                    controller.oldPasswordController,
                    obscureText:
                    controller.obscureOldPassword,
                    onToggle:
                    controller.toggleOldPassword,
                  ),

                  const SizedBox(height: 22),

                  _buildPasswordField(
                    label: 'New Password',
                    hint: 'Enter your new password',
                    controller:
                    controller.newPasswordController,
                    obscureText:
                    controller.obscureNewPassword,
                    onToggle:
                    controller.toggleNewPassword,
                  ),

                  const SizedBox(height: 22),

                  _buildPasswordField(
                    label: 'Confirm New Password',
                    hint: 'Re-enter your new password',
                    controller:
                    controller.confirmPasswordController,
                    obscureText:
                    controller.obscureConfirmPassword,
                    onToggle:
                    controller.toggleConfirmPassword,
                  ),

                  const SizedBox(height: 14),

                  _buildPasswordHint(),

                  const SizedBox(height: 35),

                  _buildChangePasswordButton(),

                  const SizedBox(height: 30),

                  _buildSecurityMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // BACK BUTTON
  // =========================================================

  Widget _buildBackButton() {
    return IconButton(
      onPressed: () => Get.back(),

      icon: const Icon(
        Icons.arrow_back_rounded,
        size: 27,
        color: AppColors.navy,
      ),

      padding: EdgeInsets.zero,

      constraints: const BoxConstraints(),

      tooltip: 'Back',
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACCOUNT SECURITY',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
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
                text: 'Change ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  height: 1.1,
                ),
              ),

              TextSpan(
                text: 'Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Update your account password to keep your HRMS account secure.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // PASSWORD FIELD
  // =========================================================

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required RxBool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),

        const SizedBox(height: 9),

        Obx(
              () => TextField(
            controller: controller,

            obscureText: obscureText.value,

            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.navy,
            ),

            textInputAction: TextInputAction.next,

            decoration: InputDecoration(
              hintText: hint,

              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.textLight,
              ),

              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.icon,
                size: 21,
              ),

              suffixIcon: IconButton(
                onPressed: onToggle,

                icon: Icon(
                  obscureText.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.icon,
                  size: 21,
                ),
              ),

              filled: true,

              fillColor: AppColors.inputBackground,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.border,
                  width: 1,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // PASSWORD HINT
  // =========================================================

  Widget _buildPasswordHint() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 18,
          color: AppColors.primary,
        ),

        const SizedBox(width: 8),

        const Expanded(
          child: Text(
            'New password must contain at least 8 characters.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // CHANGE PASSWORD BUTTON
  // =========================================================

  Widget _buildChangePasswordButton() {
    return Obx(
          () => SizedBox(
        width: double.infinity,
        height: 62,

        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.changePassword,

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,

            disabledBackgroundColor:
            AppColors.primary.withValues(
              alpha: 0.6,
            ),

            foregroundColor: Colors.white,

            elevation: 8,

            shadowColor: AppColors.primary.withValues(
              alpha: 0.35,
            ),

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
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Text(
                'Change Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
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

  // =========================================================
  // SECURITY MESSAGE
  // =========================================================

  Widget _buildSecurityMessage() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.security_outlined,
              color: AppColors.primary,
              size: 25,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Secure Your Account',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Never share your password with anyone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}