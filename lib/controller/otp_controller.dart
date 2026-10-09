import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/otp_model.dart';
import '../views/home_view.dart';

class OtpController extends GetxController {
  // =========================================================
  // API
  // =========================================================

  static const String verifyOtpUrl =
      'https://api-new-hrms.hkdigiverse.com/verify-otp';

  // =========================================================
  // OTP INPUT
  // =========================================================

  final List<TextEditingController> otpControllers =
  List.generate(
    6,
        (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes =
  List.generate(
    6,
        (_) => FocusNode(),
  );

  // =========================================================
  // MODEL
  // =========================================================

  final OtpModel otpModel = OtpModel();

  // =========================================================
  // STATE
  // =========================================================

  final RxBool isLoading = false.obs;

  final RxInt resendSeconds = 60.obs;

  final RxBool canResend = false.obs;

  Timer? _timer;

  String email = '';

  // Prevent verify API from being called multiple times
  bool _verificationStarted = false;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments is Map) {
      email = arguments['email']?.toString() ?? '';
      otpModel.email = email;
    }

    startResendTimer();
  }

  // =========================================================
  // OTP INPUT
  // =========================================================

  void onOtpChanged(
      String value,
      int index,
      ) {
    // Safety
    if (index < 0 || index >= 6) {
      return;
    }

    // Keep only one digit
    if (value.length > 1) {
      final lastDigit = value.substring(value.length - 1);

      otpControllers[index].value = TextEditingValue(
        text: lastDigit,
        selection: const TextSelection.collapsed(
          offset: 1,
        ),
      );
    }

    // Move to next box
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }

    // Move back when cleared
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    updateOtpModel();

    // Auto verify after 6 digits
    if (otpModel.otp.length == 6 &&
        !_verificationStarted &&
        !isLoading.value) {
      verifyOtp();
    }
  }

  // =========================================================
  // BACKSPACE
  // =========================================================

  void handleBackspace(
      String value,
      int index,
      ) {
    if (value.isEmpty && index > 0) {
      otpControllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
    }

    updateOtpModel();
  }

  // =========================================================
  // UPDATE MODEL
  // =========================================================

  void updateOtpModel() {
    otpModel.otp = otpControllers
        .map((controller) => controller.text.trim())
        .join();

    otpModel.email = email;
  }

  // =========================================================
  // VERIFY OTP API
  // =========================================================

  Future<void> verifyOtp() async {
    updateOtpModel();

    // Already processing
    if (isLoading.value) {
      return;
    }

    // Validate email
    if (otpModel.email.trim().isEmpty) {
      Get.snackbar(
        'Email Missing',
        'Registered email address was not found.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      return;
    }

    // Validate OTP
    if (!otpModel.isValid) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter the 6 digit OTP.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      return;
    }

    try {
      _verificationStarted = true;
      isLoading.value = true;

      final response = await http
          .post(
        Uri.parse(verifyOtpUrl),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          otpModel.toJson(),
        ),
      )
          .timeout(
        const Duration(seconds: 30),
      );

      debugPrint(
        'VERIFY OTP STATUS: ${response.statusCode}',
      );

      debugPrint(
        'VERIFY OTP RESPONSE: ${response.body}',
      );

      // =====================================================
      // SUCCESS
      // =====================================================

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        Map<String, dynamic> data = {};

        try {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            data = decoded;
          }
        } catch (_) {
          // Response is not valid JSON
        }

        final accessToken =
            data['access_token']?.toString() ?? '';

        final tokenType =
            data['token_type']?.toString() ?? 'bearer';

        debugPrint(
          'TOKEN TYPE: $tokenType',
        );

        // ===================================================
        // TOKEN RECEIVED
        // ===================================================

        if (accessToken.isEmpty) {
          Get.snackbar(
            'Verification Error',
            'OTP verified but access token was not received.',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );

          return;
        }

        // ===================================================
        // TODO:
        // Save accessToken securely for future API calls.
        //
        // Example later:
        // await storage.write(
        //   key: 'access_token',
        //   value: accessToken,
        // );
        // ===================================================

        Get.snackbar(
          'Success',
          'OTP verified successfully.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        );

        // ===================================================
        // GO TO HOME
        // ===================================================

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        Get.offAll(
              () => const HomeView(),
          transition: Transition.fadeIn,
          duration: const Duration(
            milliseconds: 400,
          ),
        );

        return;
      }

      // =====================================================
      // API ERROR
      // =====================================================

      String message =
          'Invalid or expired OTP. Please try again.';

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map) {
          message =
              decoded['message']?.toString() ??
                  decoded['detail']?.toString() ??
                  message;
        }
      } catch (_) {
        // Keep default message
      }

      Get.snackbar(
        'Verification Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      // Allow user to try again
      _verificationStarted = false;
    } on TimeoutException {
      Get.snackbar(
        'Request Timeout',
        'Server took too long to respond. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      _verificationStarted = false;
    } on http.ClientException {
      Get.snackbar(
        'Connection Error',
        'Unable to connect to the server. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      _verificationStarted = false;
    } catch (e) {
      debugPrint(
        'VERIFY OTP ERROR: $e',
      );

      Get.snackbar(
        'Something Went Wrong',
        'Unable to verify OTP. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      _verificationStarted = false;
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // RESEND OTP
  // =========================================================

  Future<void> resendOtp() async {
    if (!canResend.value) {
      return;
    }

    // =======================================================
    // IMPORTANT
    // =======================================================
    // Your provided API screenshot only confirms:
    //
    // POST /verify-otp
    //
    // It does NOT provide the resend OTP endpoint.
    //
    // So don't invent an endpoint here.
    // Add the real resend API when you provide it.
    // =======================================================

    startResendTimer();

    clearOtp();

    Get.snackbar(
      'OTP Sent',
      'A new OTP has been sent to your email.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // =========================================================
  // RESEND TIMER
  // =========================================================

  void startResendTimer() {
    _timer?.cancel();

    resendSeconds.value = 60;
    canResend.value = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (resendSeconds.value > 0) {
          resendSeconds.value--;
        } else {
          canResend.value = true;
          timer.cancel();
        }
      },
    );
  }

  // =========================================================
  // CLEAR OTP
  // =========================================================

  void clearOtp() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    _verificationStarted = false;

    updateOtpModel();

    if (focusNodes.isNotEmpty) {
      focusNodes.first.requestFocus();
    }
  }

  // =========================================================
  // CHANGE EMAIL
  // =========================================================

  void changeEmail() {
    Get.back();
  }

  // =========================================================
  // CLOSE
  // =========================================================

  @override
  void onClose() {
    _timer?.cancel();

    for (final controller in otpControllers) {
      controller.dispose();
    }

    for (final node in focusNodes) {
      node.dispose();
    }

    super.onClose();
  }
}