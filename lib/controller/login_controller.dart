import 'dart:async';
import 'dart:convert';

import 'package:demo_project/views/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../models/login_model.dart';

class LoginController extends GetxController {
  // ============================================================
  // API
  // ============================================================

  static const String loginApi =
      'https://api-new-hrms.hkdigiverse.com/login';

  // ============================================================
  // Controllers
  // ============================================================

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ============================================================
  // State
  // ============================================================

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  final LoginModel loginModel = LoginModel();

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    emailController.addListener(_updateModel);
    passwordController.addListener(_updateModel);
  }

  void _updateModel() {
    loginModel.email = emailController.text.trim();
    loginModel.password = passwordController.text;
  }

  // ============================================================
  // Password Visibility
  // ============================================================

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // ============================================================
  // LOGIN API
  // ============================================================

  Future<void> login() async {
    _updateModel();

    // ------------------------------------------------------------
    // Validation
    // ------------------------------------------------------------

    if (loginModel.emailError != null) {
      Get.snackbar(
        'Invalid Email',
        loginModel.emailError!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (loginModel.passwordError != null) {
      Get.snackbar(
        'Invalid Password',
        loginModel.passwordError!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Prevent duplicate API requests
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      // ----------------------------------------------------------
      // API Request
      // ----------------------------------------------------------

      final Uri url = Uri.parse(loginApi);

      final response = await http
          .post(
        url,
        headers: const {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          loginModel.toJson(),
        ),
      )
          .timeout(
        const Duration(seconds: 30),
      );

      // ----------------------------------------------------------
      // Decode Response
      // ----------------------------------------------------------

      Map<String, dynamic> responseData = {};

      if (response.body.isNotEmpty) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded is Map<String, dynamic>) {
            responseData = decoded;
          }
        } catch (_) {
          // Response was not valid JSON.
        }
      }

      // ----------------------------------------------------------
      // SUCCESS
      // ----------------------------------------------------------

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final String message =
            responseData['message']?.toString() ??
                'OTP sent to your email. Please verify.';

        final String apiEmail =
            responseData['email']?.toString().trim() ??
                loginModel.email;

        if (apiEmail.isEmpty) {
          throw Exception(
            'Email was not returned by the server.',
          );
        }

        // --------------------------------------------------------
        // Go to OTP Page
        // --------------------------------------------------------

        Get.to(
              () => OtpPage(),
          arguments: {
            'email': apiEmail,
          },
          transition: Transition.rightToLeft,
          duration: const Duration(
            milliseconds: 400,
          ),
        );

        Get.snackbar(
          'OTP Sent',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );

        return;
      }

      // ----------------------------------------------------------
      // API ERROR
      // ----------------------------------------------------------

      String errorMessage =
          responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              'Unable to login. Please check your credentials.';

      if (errorMessage.trim().isEmpty) {
        errorMessage =
        'Unable to login. Please try again.';
      }

      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }

    // ------------------------------------------------------------
    // Timeout
    // ------------------------------------------------------------

    on TimeoutException {
      Get.snackbar(
        'Connection Timeout',
        'Server took too long to respond. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade900,
        margin: const EdgeInsets.all(16),
      );
    }

    // ------------------------------------------------------------
    // Network Error
    // ------------------------------------------------------------

    on http.ClientException catch (e) {
      debugPrint('Login ClientException: $e');

      Get.snackbar(
        'Connection Error',
        'Unable to connect to the server. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    }

    // ------------------------------------------------------------
    // Other Error
    // ------------------------------------------------------------

    catch (e) {
      debugPrint('Login API Error: $e');

      Get.snackbar(
        'Login Failed',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(16),
      );
    }

    finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // Forgot Password
  // ============================================================

  void forgotPassword() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Please contact HR Department for forgot password.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Contact HR
  // ============================================================

  Future<void> contactHR() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'hr@hkdigiverse.com',
      queryParameters: {
        'subject': 'HRMS Account Access',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar(
        'Unable to Open Mail',
        'Please email hr@hkdigiverse.com manually.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}