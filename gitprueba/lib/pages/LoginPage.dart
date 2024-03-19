import 'package:flutter/material.dart';
import 'package:gitprueba/components/login_button.dart';
import 'package:gitprueba/controllers/AuthService.dart';
import 'package:gitprueba/components/textfield.dart';
import 'package:gitprueba/pages/RegisterPage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Image.asset(
                  'assets/images/logo2.png',
                  width: 400,
                  height: 100,
                ),

                const SizedBox(height: 50),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // paddin end
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                LoginButton(
                  onTap: () {
                    AuthService.login(
                        context, emailController.text, passwordController.text);
                  },
                ),

                const SizedBox(height: 50),

                // or continue with
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                ),

                const SizedBox(height: 50),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Color.fromARGB(255, 4, 116, 252),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
