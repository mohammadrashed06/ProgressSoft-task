import 'package:equatable/equatable.dart';

// Abstract base class for all login states
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

// Initial state of the login
class LoginInitial extends LoginState {}

// State when the login process is in progress
class LoginLoading extends LoginState {}

// State when login is successful
class LoginSuccess extends LoginState {}

// State when there's an error in login
class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}

// State when OTP is sent
class OtpSent extends LoginState {
  final String verificationId;

  const OtpSent({required this.verificationId});

  @override
  List<Object> get props => [verificationId];
}
