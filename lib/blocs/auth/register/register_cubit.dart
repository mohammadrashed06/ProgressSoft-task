import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser({
    required String fullName,
    required String mobile,
    required String password,
    required int age,
    required String gender,
  }) async {
    emit(RegisterLoading());

    try {
      final existingUserQuery = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: mobile)
          .limit(1)
          .get();

      if (existingUserQuery.docs.isNotEmpty) {
        emit(const RegisterError('Phone number already registered.'));
        return;
      }

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: mobile,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          emit(const RegisterError('Auto-verification not supported in this demo.'));
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(RegisterError('Failed to verify phone number: ${e.message}'));
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(OtpSentState(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(RegisterError('Failed to send OTP: $e'));
    }
  }

  Future<void> verifyOtp({
    required String verificationId,
    required String otp,
    required String fullName,
    required String mobile,
    required String password,
    required int age,
    required String gender,
  }) async {
    emit(RegisterLoading());

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final hashedPassword = _hashPassword(password);

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': fullName,
          'mobile': mobile,
          'password': hashedPassword,
          'age': age,
          'gender': gender,
        });

        emit(RegisterSuccess());
      } else {
        emit(const RegisterError('User creation failed'));
      }
    } catch (e) {
      emit(RegisterError('Failed to register: $e'));
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
