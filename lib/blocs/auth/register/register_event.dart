import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  final String fullName;
  final String mobile;
  final String password;
  final int age;
  final String gender;

  const RegisterSubmitted({
    required this.fullName,
    required this.mobile,
    required this.password,
    required this.age,
    required this.gender,
  });

  @override
  List<Object> get props => [fullName, mobile, password, age, gender];
}

class OtpSubmitted extends RegisterEvent {
  final String verificationId;
  final String otp;
  final String fullName;
  final String mobile;
  final String password;
  final int age;
  final String gender;

  const OtpSubmitted({
    required this.verificationId,
    required this.otp,
    required this.fullName,
    required this.mobile,
    required this.password,
    required this.age,
    required this.gender,
  });

  @override
  List<Object> get props => [verificationId, otp, fullName, mobile, password, age, gender];
}
