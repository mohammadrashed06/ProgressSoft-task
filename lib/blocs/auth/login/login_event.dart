import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String mobile;
  final String password;

  const LoginSubmitted({required this.mobile, required this.password});

  @override
  List<Object> get props => [mobile, password];
}

class OtpVerified extends LoginEvent {
  final String verificationId;
  final String smsCode;

  const OtpVerified({required this.verificationId, required this.smsCode});

  @override
  List<Object> get props => [verificationId, smsCode];
}
