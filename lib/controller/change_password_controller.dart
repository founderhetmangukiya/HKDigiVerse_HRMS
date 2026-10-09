import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/change_password_model.dart';
import '../views/home_view.dart';

class ChangePasswordController extends GetxController {
  // =========================================================
  // TEXT CONTROLLERS
  // =========================================================

  final TextEditingController oldPasswordController =
  TextEditingController();

  final TextEditingController newPasswordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  // =========================================================
  // MODEL
  // =========================================================

  final ChangePasswordModel changePasswordModel =
  ChangePasswordModel();

  // =========================================================
  // REACTIVE VARIABLES
  // =========================================================

  final RxBool isLoading = false.obs;

  final RxBool obscureOldPassword = true.obs;

  final RxBool obscureNewPassword = true.obs;

  final RxBool obscureConfirmPassword = true.obs;

  // =========================================================
  // UPDATE MODEL
  // =========================================================

  void updateModel() {
    changePasswordModel.oldPassword =
        oldPasswordController.text.trim();

    changePasswordModel.newPassword =
        newPasswordController.text.trim();

    changePasswordModel.confirmPassword =
        confirmPasswordController.text.trim();
  }

  // =========================================================
  // PASSWORD VISIBILITY
  // =========================================================

  void toggleOldPassword() {
    obscureOldPassword.value = !obscureOldPassword.value;
  }

  void toggleNewPassword() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPassword() {
    obscureConfirmPassword.value =
    !obscureConfirmPassword.value;
  }

  // =========================================================
  // CHANGE PASSWORD
  // =========================================================

  Future<void> changePassword() async {
    FocusManager.instance.primaryFocus?.unfocus();

    updateModel();

    // -------------------------------------------------------
    // VALIDATION
    // -------------------------------------------------------

    if (changePasswordModel.oldPasswordError != null) {
      _showError(
        'Old Password',
        changePasswordModel.oldPasswordError!,
      );
      return;
    }

    if (changePasswordModel.newPasswordError != null) {
      _showError(
        'New Password',
        changePasswordModel.newPasswordError!,
      );
      return;
    }

    if (changePasswordModel.confirmPasswordError != null) {
      _showError(
        'Confirm Password',
        changePasswordModel.confirmPasswordError!,
      );
      return;
    }

    // -------------------------------------------------------
    // PREVENT MULTIPLE API CALLS
    // -------------------------------------------------------

    if (isLoading.value) return;

    isLoading.value = true;

    try {
      // =====================================================
      // FUTURE API CALL
      // =====================================================
      //
      // final response = await apiService.changePassword(
      //   changePasswordModel.toJson(),
      // );
      //
      // if (!response.success) {
      //   throw Exception(response.message);
      // }
      //
      // =====================================================

      // Temporary API simulation
      await Future.delayed(
        const Duration(seconds: 2),
      );

      // -----------------------------------------------------
      // SUCCESS TOASTER
      // -----------------------------------------------------

      _showSuccess(
        'Password Changed',
        'Your password has been changed successfully.',
      );

      // -----------------------------------------------------
      // CLEAR PASSWORD DATA
      // -----------------------------------------------------

      clearFields();

      // -----------------------------------------------------
      // CLOSE ALL PREVIOUS PAGES
      // AND GO TO HOME
      // -----------------------------------------------------

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      Get.offAll(
            () => const HomeView(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 350),
      );
    } catch (e) {
      // -----------------------------------------------------
      // API ERROR
      // -----------------------------------------------------

      _showError(
        'Change Password Failed',
        e.toString() == 'Exception'
            ? 'Something went wrong. Please try again.'
            : 'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }
  // =========================================================
  // CLEAR FIELDS
  // =========================================================

  void clearFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();

    changePasswordModel.clear();
  }

  // =========================================================
  // SUCCESS TOASTER
  // =========================================================

  void _showSuccess(
      String title,
      String message,
      ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      backgroundColor: const Color(0xFF061B41),
      colorText: Colors.white,
      icon: const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.white,
      ),
      borderRadius: 14,
      isDismissible: true,
    );
  }

  // =========================================================
  // ERROR TOASTER
  // =========================================================

  void _showError(
      String title,
      String message,
      ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
      borderRadius: 14,
      isDismissible: true,
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}