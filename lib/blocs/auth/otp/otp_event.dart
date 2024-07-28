abstract class OtpEvent {}

class SendOtp extends OtpEvent {
  final String mobile;

  SendOtp({required this.mobile});
}

class VerifyOtp extends OtpEvent {
  final String otp;

  VerifyOtp({required this.otp});
}
