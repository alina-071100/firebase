import 'package:firebase_flutter_chat/pages/login_button.dart';
import 'package:firebase_flutter_chat/pages/text_field.dart';
import 'package:firebase_flutter_chat/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 219, 243),
      body: SafeArea(
        
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              // const SizedBox(height: 30),
              const Icon(
                Icons.message,
                size: 100,
                color: Color.fromARGB(137, 106, 44, 134),
              ),
              const SizedBox(height: 20),

              const Text(
                "Login Page!",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 86, 23, 97),
                ),
              ),

              const SizedBox(height: 20),

              MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false),

              const SizedBox(height: 10),

              MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true),

              const SizedBox(height: 15),

              MyButton(
                onTap: signIn,
                text: "Sign In",
              ),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?'),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 69, 14, 78),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
