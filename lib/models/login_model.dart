class LoginModel {
  String email;
  String password;

  LoginModel({
    this.email = '',
    this.password = '',
  });

  bool get isValid {
    return email.trim().isNotEmpty &&
        password.trim().isNotEmpty;
  }

  String? get emailError {
    if (email.trim().isEmpty) {
      return 'Email is required';
    }

    if (!email.contains('@')) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? get passwordError {
    if (password.trim().isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}