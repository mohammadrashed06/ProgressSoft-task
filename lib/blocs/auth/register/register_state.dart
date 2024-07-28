import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class OtpSentState extends RegisterState {
  final String verificationId;

  const OtpSentState({required this.verificationId});

  @override
  List<Object> get props => [verificationId];
}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError(this.message);

  @override
  List<Object> get props => [message];
}
