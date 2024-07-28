import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<OtpVerified>(_onOtpVerified);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: event.mobile,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final userCredential = await _firebaseAuth.signInWithCredential(credential);
            if (userCredential.user != null) {
              // Save credentials for auto-login (e.g., using shared preferences or secure storage)
              emit(LoginSuccess());
            } else {
              emit(LoginError('Failed to authenticate.'));
            }
          } catch (e) {
            emit(LoginError('Failed to login: ${e.toString()}'));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(LoginError('Verification failed: ${e.message}'));
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Save the verification ID and notify the UI
          emit(OtpSent(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle the auto-retrieval timeout
        },
      );
    } catch (e) {
      emit(LoginError('Failed to initiate phone number verification: ${e.toString()}'));
    }
  }

  Future<void> _onOtpVerified(OtpVerified event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      // Create a credential using the verification ID and OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
      );

      // Sign in with the credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        // Save credentials for auto-login (e.g., using shared preferences or secure storage)
        emit(LoginSuccess());
      } else {
        emit(const LoginError('Failed to authenticate.'));
      }
    } catch (e) {
      emit(LoginError('Failed to verify OTP: ${e.toString()}'));
    }
  }
}
