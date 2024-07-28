import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../blocs/auth/register/register_bloc.dart';
import '../../blocs/auth/register/register_event.dart';
import '../../blocs/auth/register/register_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Successful')),
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
              builder: (context) => OtpScreen(verificationId: state.verificationId),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _fullNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male'; // Or use a DropdownButton

  void _register() {
    final fullName = _fullNameController.text;
    final mobileNumber = _mobileNumberController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final age = int.tryParse(_ageController.text) ?? 0;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    context.read<RegisterBloc>().add(
      RegisterSubmitted(
        fullName: fullName,
        mobile: mobileNumber,
        password: password,
        age: age,
        gender: _selectedGender,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _fullNameController,
            decoration: InputDecoration(labelText: 'Full Name'),
          ),
          TextField(
            controller: _mobileNumberController,
            decoration: InputDecoration(labelText: 'Mobile Number'),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Age'),
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
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _register,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({required this.verificationId});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();

  void _verifyOtp() {
    final otp = _otpController.text;

    context.read<RegisterBloc>().add(
      OtpSubmitted(
        verificationId: widget.verificationId,
        otp: otp,
        fullName: 'mohamamd', // pass actual data here
        mobile: '+962786634648', // pass actual data here
        password: '123', // pass actual data here
        age: 0, // pass actual data here
        gender: 'male', // pass actual data here
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
