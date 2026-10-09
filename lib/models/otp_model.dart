class OtpModel {
  String otp;
  String email;

  OtpModel({
    this.otp = '',
    this.email = '',
  });

  bool get isValid {
    return otp.length == 6;
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}