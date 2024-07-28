import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final FirebaseAuth _firebaseAuth;

  OtpBloc({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth,
        super(OtpInitial()) {
    on<SendOtp>(_onSendOtp);
    on<VerifyOtp>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(SendOtp event, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    try {
      // Send OTP using Firebase
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: event.mobile,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Handle automatic OTP verification and sign-in
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(OtpFailure(error: e.message ?? 'OTP sending failed'));
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store the verificationId and resendToken for later use
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
      emit(OtpInitial());
    } catch (e) {
      emit(OtpFailure(error: e.toString()));
    }
  }


  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<OtpState> emit) async {
    emit(OtpLoading());
    try {
      // Simulate OTP verification (replace with actual OTP verification logic)
      if (event.otp == "123456") {
        emit(OtpSuccess());
      } else {
        emit(OtpFailure(error: "Invalid OTP"));
      }
    } catch (e) {
      emit(OtpFailure(error: e.toString()));
    }
  }
}
