import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({
    required String mobile,
    required String password,
  }) async {
    emit(LoginLoading());
    final configSnapshot = await _firestore.collection('configurations').doc('iiczNyEQ0xWvYokpx1Wx').get();
    final configData = configSnapshot.data();
    final passwordIncorrectMessage = configData?['password_incorrect_message'];
    try {
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('mobile', isEqualTo: mobile)
          .limit(1)
          .get();

      if (result.docs.isNotEmpty) {
        final userDoc = result.docs.first;
        final storedHashedPassword = userDoc['password'];
        final hashedPassword = _hashPassword(password);

        if (hashedPassword == storedHashedPassword) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userMobile', mobile);
          emit(LoginSuccess());
        } else {
          emit(LoginError(passwordIncorrectMessage));
        }
      } else {
        emit(UserNotFound());
      }
    } catch (e) {
      emit(LoginError('Failed to login: $e'));
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
