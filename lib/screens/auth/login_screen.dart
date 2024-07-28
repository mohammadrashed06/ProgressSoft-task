import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../blocs/auth/login/login_cubit.dart';
import '../../blocs/auth/login/login_state.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, '/main');
        }
        else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserNotFound) {
          _showUserNotFoundDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const LoginForm();
          },
        ),
      ),
    );
  }

  void _showUserNotFoundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Not Found'),
          content: const Text('The entered mobile number is not registered. Would you like to register?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
          ],
        );
      },
    );
  }
}

class LoginForm extends StatefulWidget {

  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _login() {
    final mobile = _mobileController.text;
    final password = _passwordController.text;

    if(_formKey.currentState!.validate()){
      context.read<LoginCubit>().loginUser(
        mobile: mobile,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              SvgPicture.asset('assets/images/proggressSoft_logo.svg',width: 200,height: 100,),
              const SizedBox(height: 50,),
              TextFormField(
                controller: _mobileController,
                validator: (val){
                  if(val!.isEmpty){
                    return "Fill mobile number";
                  }
                },
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _passwordController,
                validator: (val){
                  if(val!.isEmpty){
                    return "Fill password";
                  }
                },
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, '/register');
              }, child: const Text("Register",style: TextStyle(decoration: TextDecoration.underline),)),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
