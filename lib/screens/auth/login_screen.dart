import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/login/login_bloc.dart';
import '../../blocs/auth/login/login_event.dart';
import '../../blocs/auth/login/login_state.dart';
import '../../blocs/auth/splash/configuration_bloc.dart';
import '../../blocs/auth/splash/configuration_state.dart';


class LoginScreen extends StatelessWidget {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is OtpSent) {
            _showOtpDialog(context, state.verificationId);
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return BlocBuilder<ConfigurationBloc, ConfigurationState>(
            builder: (context, configState) {
              if (configState is ConfigurationLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (configState is ConfigurationLoaded) {
                final passwordRegex = configState.config['passwordRegex'] ?? '';
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _mobileController,
                        decoration: const InputDecoration(labelText: 'Mobile Number'),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          final mobile = _mobileController.text.trim();
                          final password = _passwordController.text.trim();
                          if(mobile.isEmpty || password.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fill data')),
                            );
                          }else
                          if (!_validatePassword(password, passwordRegex)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Invalid password format')),
                            );
                            return;
                          }else{
                            context.read<LoginBloc>().add(LoginSubmitted(
                              mobile: mobile,
                              password: password,
                            ));
                          }

                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('Failed to load configuration'));
              }
            },
          );
        },
      ),
    );
  }

  bool _validatePassword(String password, String regex) {
    final regExp = RegExp(regex);
    return regExp.hasMatch(password);
  }

  void _showOtpDialog(BuildContext context, String verificationId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: TextField(
            controller: _otpController,
            decoration: const InputDecoration(labelText: 'OTP'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final otp = _otpController.text.trim();
                context.read<LoginBloc>().add(OtpVerified(
                  verificationId: verificationId,
                  smsCode: otp,
                ));
                Navigator.of(context).pop();
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }
}
