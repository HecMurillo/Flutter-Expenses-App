import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gitprueba/pages/MyHomePage.dart';

class AuthService {
  static Future<void> login(
      BuildContext context, String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/Auth');

    try {
      if (email.isEmpty || password.isEmpty) {
        throw 'Por favor, rellene todos los campos.';
      }

      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final userProfile = responseData['profile'];
        final userId = userProfile['id'];
        final userName = userProfile['name'];
        final userEmail = userProfile['email'];
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                  userId: userId, userName: userName, userEmail: userEmail)),
          (route) => false, // Remove all routes from stack
        );
      } else {
        final errorMessage = responseData['response'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
