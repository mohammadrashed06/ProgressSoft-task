import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
  }

  Future<void> _onRegisterSubmitted(
      RegisterSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());


    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: "AD8T5IsN1efgcvHpVT6-4HBNwAnFUvFftMIxDRgdkW6ZRJMbsFLEtDylE7s8qNCKHfMlGLlwLG31aMR2s-GhS7vroA-kekoh8EDHTRWpV3CnYLNQ3vZJickndkwuJXzzxkEnZ5BlhRdVc4hIGBiMQiEXRxZz9G637Q",
        smsCode: "000000",
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Add user details to Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': event.fullName,
          'mobile': event.mobile,
          'age': event.age,
          'gender': event.gender,
        });

        if (!emit.isDone) {
          emit(RegisterSuccess());
        }
      } else {
        if (!emit.isDone) {
          emit(RegisterError('User creation failed'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(RegisterError('Failed to register: $e'));
      }
    }
  }

  Future<void> _onOtpSubmitted(
      OtpSubmitted event,
      Emitter<RegisterState> emit,
      ) async {
    emit(RegisterLoading());

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: "AD8T5IsN1efgcvHpVT6-4HBNwAnFUvFftMIxDRgdkW6ZRJMbsFLEtDylE7s8qNCKHfMlGLlwLG31aMR2s-GhS7vroA-kekoh8EDHTRWpV3CnYLNQ3vZJickndkwuJXzzxkEnZ5BlhRdVc4hIGBiMQiEXRxZz9G637Q",
        smsCode: "000000",
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Add user details to Firestore
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': event.fullName,
          'mobile': event.mobile,
          'age': event.age,
          'gender': event.gender,
        });

        if (!emit.isDone) {
          emit(RegisterSuccess());
        }
      } else {
        if (!emit.isDone) {
          emit(RegisterError('User creation failed'));
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(RegisterError('Failed to register: $e'));
      }
    }
  }
}
