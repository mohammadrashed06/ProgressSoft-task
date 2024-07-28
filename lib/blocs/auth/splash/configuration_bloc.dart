import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'configuration_event.dart';
import 'configuration_state.dart';

// Bloc
class ConfigurationBloc extends Bloc<ConfigurationEvent, ConfigurationState> {
  static final ConfigurationBloc _singleton = ConfigurationBloc._internal();

  factory ConfigurationBloc() {
    return _singleton;
  }

  ConfigurationBloc._internal() : super(ConfigurationInitial()) {
    on<LoadConfiguration>(_onLoadConfiguration);
  }

  void _onLoadConfiguration(LoadConfiguration event, Emitter<ConfigurationState> emit) async {
    emit(ConfigurationLoading());
    try {
      CollectionReference config = FirebaseFirestore.instance.collection('configrations');
      DocumentSnapshot snapshot = await config.doc('iiczNyEQ0xWvYokpx1Wx').get();
      log("snap${snapshot.data().toString()}");

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        emit(ConfigurationLoaded(data));
      } else {
        emit(const ConfigurationError("No configuration found"));
      }
    } catch (e) {
      emit(ConfigurationError("Failed to load configuration: $e"));
    }
  }
}




