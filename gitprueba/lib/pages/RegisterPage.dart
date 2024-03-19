import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gitprueba/components/register_button.dart';
import 'package:gitprueba/components/textfield.dart';
import 'package:gitprueba/pages/LoginPage.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      // Si las contraseñas no coinciden, muestra un SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Crear un mapa con los datos del usuario
    final Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'password': password,
    };

    // Convertir el mapa a JSON
    final String jsonData = jsonEncode(userData);

    // Enviar los datos a la API
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/Users/Create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 200) {
      // Si el registro es exitoso, muestra un SnackBar y navega a LoginPage
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario creado correctamente.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      // Si hay algún error en la API, muestra un SnackBar con el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error en el registro. Por favor, intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
                Image.asset(
                  'assets/images/logo2.png',
                  width: 400,
                  height: 100,
                ),
                const SizedBox(height: 50),
                const SizedBox(height: 25),
                MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                RegisterButton(
                  onTap: () {
                    _register(context);
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ya tienes una cuenta?',
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
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Iniciar Sesión',
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
