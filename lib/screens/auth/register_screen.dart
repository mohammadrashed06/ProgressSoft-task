import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/register/register_cubit.dart';
import '../../blocs/auth/register/register_state.dart';
import '../../blocs/auth/splash/configuration_bloc.dart';
import '../../blocs/auth/splash/configuration_state.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register() {
    final fullName = _fullNameController.text;
    final mobileNumber = _mobileNumberController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final age = int.tryParse(_ageController.text) ?? 0;

    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      } else {
        final countryCode = context.read<ConfigurationBloc>().state is ConfigurationLoaded
            ? (context.read<ConfigurationBloc>().state as ConfigurationLoaded).config['country_code'] ?? '+1'
            : '+1';

        final fullMobileNumber = '$countryCode$mobileNumber';
        context.read<RegisterCubit>().registerUser(
          fullName: fullName,
          mobile: fullMobileNumber,
          password: password,
          age: age,
          gender: _selectedGender,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
      builder: (context, configState) {
        if (configState is ConfigurationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (configState is ConfigurationLoaded) {
          final countryCode = configState.config['country_code'] ?? '+1';
          final passwordRegex = configState.config['password_regex'] ?? '.*';

          return BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registration Successful')),
                );
                Navigator.pushReplacementNamed(context, '/login');
              } else if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is OtpSentState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(
                      verificationId: state.verificationId,
                      fullName: _fullNameController.text,
                      mobile: '$countryCode${_mobileNumberController.text}',
                      password: _passwordController.text,
                      age: int.tryParse(_ageController.text),
                      gender: _selectedGender,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is RegisterLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Register'),
                ),
                body: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _fullNameController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Fill full name";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: 'Full Name'),
                          ),
                          Row(
                            children: [
                              Text(countryCode),
                              Expanded(
                                child: TextFormField(
                                  controller: _mobileNumberController,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Fill mobile number";
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: _ageController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Fill age";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: 'Age'),
                            keyboardType: TextInputType.number,
                          ),
                          DropdownButton<String>(
                            value: _selectedGender,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedGender = newValue!;
                              });
                            },
                            items: <String>['Male', 'Female', 'Other'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Fill password";
                              }
                              if (!RegExp(passwordRegex).hasMatch(val)) {
                                return "Password does not meet the criteria";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Fill confirm password";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: 'Confirm Password'),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: context.read<RegisterCubit>().state is RegisterLoading
                                ? null
                                : _register,
                            child: context.read<RegisterCubit>().state is RegisterLoading
                                ? const CircularProgressIndicator()
                                : const Text('Register'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (configState is ConfigurationError) {
          return Center(child: Text(configState.message));
        } else {
          return const Center(child: Text('Failed to load configurations.'));
        }
      },
    );
  }
}
