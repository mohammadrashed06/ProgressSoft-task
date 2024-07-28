import 'package:equatable/equatable.dart';

abstract class ConfigurationState extends Equatable {
  const ConfigurationState();

  @override
  List<Object> get props => [];
}

class ConfigurationInitial extends ConfigurationState {}

class ConfigurationLoading extends ConfigurationState {}

class ConfigurationLoaded extends ConfigurationState {
  final Map<String, dynamic> config;

  const ConfigurationLoaded(this.config);

  @override
  List<Object> get props => [config];
}

class ConfigurationError extends ConfigurationState {
  final String message;

  const ConfigurationError(this.message);

  @override
  List<Object> get props => [message];
}
