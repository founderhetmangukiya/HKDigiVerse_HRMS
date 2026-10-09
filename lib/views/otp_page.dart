import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../components/app_colors.dart';
import '../controller/otp_controller.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBackButton(),

                  const SizedBox(height: 35),

                  _buildHeader(),

                  const SizedBox(height: 45),

                  _buildOtpFields(),

                  const SizedBox(height: 35),

                  _buildVerifyButton(),

                  const SizedBox(height: 25),

                  _buildResendSection(),

                  const SizedBox(height: 35),

                  _buildDivider(),

                  const SizedBox(height: 25),

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
      onPressed: controller.changeEmail,
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
          'VERIFY YOUR ACCOUNT',
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
                text: 'Enter ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: 'OTP',
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
          'We have sent a 6 digit verification code to your registered email address.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 10),

        // IMPORTANT:
        // Do NOT use Obx here because controller.email
        // is a normal String, not an Rx variable.
        Row(
          children: [
            const Icon(
              Icons.mail_outline_rounded,
              size: 19,
              color: AppColors.primary,
            ),

            const SizedBox(width: 8),

            Flexible(
              child: Text(
                controller.email.isEmpty
                    ? 'Registered Email'
                    : controller.email,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // OTP FIELDS
  // =========================================================

  Widget _buildOtpFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;

        final availableWidth = constraints.maxWidth - (spacing * 5);

        final boxWidth = (availableWidth / 6).clamp(38.0, 58.0);

        final boxHeight = (boxWidth * 1.12).clamp(46.0, 64.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            return Padding(
              padding: EdgeInsets.only(right: index == 5 ? 0 : spacing),
              child: _buildOtpBox(index, boxWidth, boxHeight),
            );
          }),
        );
      },
    );
  }

  Widget _buildOtpBox(int index, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],

        autofocus: index == 0,

        keyboardType: TextInputType.number,

        textAlign: TextAlign.center,

        maxLength: 1,

        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: (width * 0.43).clamp(17.0, 24.0),
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),

        inputFormatters: [FilteringTextInputFormatter.digitsOnly],

        onChanged: (value) {
          controller.onOtpChanged(value, index);
        },

        decoration: InputDecoration(
          counterText: '',

          filled: true,

          fillColor: AppColors.inputBackground,

          contentPadding: EdgeInsets.zero,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.28),
            borderSide: const BorderSide(color: AppColors.border, width: 1),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.28),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // VERIFY BUTTON
  // =========================================================

  Widget _buildVerifyButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 62,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.verifyOtp,

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,

            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),

            foregroundColor: Colors.white,

            elevation: 8,

            shadowColor: AppColors.primary.withValues(alpha: 0.35),

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
                      'Verify OTP',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(width: 12),

                    Icon(Icons.arrow_forward_rounded, size: 24),
                  ],
                ),
        ),
      ),
    );
  }

  // =========================================================
  // RESEND OTP
  // =========================================================

  Widget _buildResendSection() {
    return Center(
      child: Obx(() {
        if (controller.canResend.value) {
          return TextButton(
            onPressed: controller.resendOtp,
            child: const Text(
              'Resend OTP',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          );
        }

        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Didn\'t receive the code? Resend in ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              TextSpan(
                text: '${controller.resendSeconds.value}s',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // =========================================================
  // DIVIDER
  // =========================================================

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.border,
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
            'Secure Login',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Never share your OTP with anyone.',
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
