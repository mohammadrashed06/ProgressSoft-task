import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/otp/otp_bloc.dart';
import '../../blocs/auth/otp/otp_event.dart';
import '../../blocs/auth/otp/otp_state.dart';


class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpBloc(firebaseAuth: FirebaseAuth.instance),
      child: Scaffold(
        appBar: AppBar(title: const Text('Verify OTP')),
        body: BlocListener<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state is OtpSuccess) {
              Navigator.pop(context, true); // Return to previous screen with success
            } else if (state is OtpFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _otpController,
                  decoration: const InputDecoration(labelText: 'OTP'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<OtpBloc>().add(VerifyOtp(otp: _otpController.text));
                  },
                  child: const Text('Verify'),
                ),
                BlocBuilder<OtpBloc, OtpState>(
                  builder: (context, state) {
                    if (state is OtpLoading) {
                      return const CircularProgressIndicator();
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
