import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/register/register_cubit.dart';
import '../../blocs/auth/register/register_state.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String? fullName;
  final String? mobile;
  final String? password;
  final int? age;
  final String? gender;

  const OtpScreen({
    required this.verificationId,
    this.fullName,
    this.mobile,
    this.password,
    this.age,
    this.gender,
    super.key,
  });

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  void _verifyOtp() {
    final otp = _otpController.text;

    context.read<RegisterCubit>().verifyOtp(
      verificationId: widget.verificationId,
      otp: otp,
      fullName: widget.fullName ?? "",
      mobile: widget.mobile ?? "",
      password: widget.password ?? "",
      age: widget.age ?? 0,
      gender: widget.gender ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            // Show a loading indicator and disable the button
          } else if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Verified Successfully')),
            );
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'OTP'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is RegisterLoading
                        ? null
                        : _verifyOtp,
                    child: state is RegisterLoading
                        ? const CircularProgressIndicator()
                        : const Text('Verify'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}