class ChangePasswordModel {
  String oldPassword;
  String newPassword;
  String confirmPassword;

  ChangePasswordModel({
    this.oldPassword = '',
    this.newPassword = '',
    this.confirmPassword = '',
  });

  bool get isValid {
    return oldPassword.trim().isNotEmpty &&
        newPassword.trim().isNotEmpty &&
        confirmPassword.trim().isNotEmpty &&
        newPassword == confirmPassword;
  }

  String? get oldPasswordError {
    if (oldPassword.trim().isEmpty) {
      return 'Old password is required';
    }
    return null;
  }

  String? get newPasswordError {
    if (newPassword.trim().isEmpty) {
      return 'New password is required';
    }

    if (newPassword.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  String? get confirmPasswordError {
    if (confirmPassword.trim().isEmpty) {
      return 'Please confirm your new password';
    }

    if (confirmPassword != newPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    };
  }

  void clear() {
    oldPassword = '';
    newPassword = '';
    confirmPassword = '';
  }
}