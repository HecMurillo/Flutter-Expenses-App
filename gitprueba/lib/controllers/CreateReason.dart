import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gitprueba/components/reasons_button.dart';
import 'package:gitprueba/components/textfield.dart';

class CreateReason extends StatelessWidget {
  CreateReason({Key? key, required this.userId}) : super(key: key);

  final int userId;

  final reasoncontroller = TextEditingController();

  Future<void> _register(BuildContext context) async {
    final String reason = reasoncontroller.text.trim();

    // Crear un mapa con los datos del usuario
    final Map<String, dynamic> userData = {
      'reason': reason,
      'user_id': userId,
    };

    // Convertir el mapa a JSON
    final String jsonData = jsonEncode(userData);

    // Enviar los datos a la API
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/Reasons/Create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reason creado.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Error al crear el motivo. Por favor, intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        title: const Text(
          "S P E N D L A B",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        //centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const SizedBox(height: 50),
                const SizedBox(height: 25),
                MyTextField(
                  controller: reasoncontroller,
                  hintText: 'Reason',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 25),
                ReasonsButton(
                  onTap: () {
                    _register(context);
                  },
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 4),
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
