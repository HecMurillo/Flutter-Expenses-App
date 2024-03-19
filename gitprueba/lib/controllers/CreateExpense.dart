import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gitprueba/components/reasons_button.dart';
import 'package:gitprueba/components/textfield.dart';
import 'package:gitprueba/controllers/global.dart';
import 'package:gitprueba/components/selectdate.dart';

class CreateExpense extends StatefulWidget {
  CreateExpense({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  final purchaseController = TextEditingController();
  final expenseController = TextEditingController();
  final dateController = TextEditingController();

  Future<int?> _createPurchase() async {
    if (purchaseController.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/Purchases/Create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "buy": purchaseController.text,
          "user_id": widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        // Compra creada exitosamente
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['data']['id'] as int;
      }
    }
    return null;
  }

  Future<int?> _createDate() async {
    if (dateController.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/Dates/Create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "date": dateController.text,
          "user_id": widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        // Fecha creada exitosamente
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['data']['id'] as int;
      } else {}
    }
    return null;
  }

  Future<void> _register(BuildContext context) async {
    final int? userId = widget.userId;

    if (userId == null ||
        purchaseController.text.isEmpty ||
        expenseController.text.isEmpty ||
        dateController.text.isEmpty) {
      // Muestra un mensaje si falta algún campo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, llena todos los campos.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verifica que expenseController solo contenga números
    if (!RegExp(r'^[0-9]+$').hasMatch(expenseController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solo se permiten números en expense.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int? purchaseId = await _createPurchase();
    final int? dateId = await _createDate();

    if (purchaseId == null || dateId == null) {
      // No continúes si falta purchaseId o dateId
      return;
    }

    final Map<String, dynamic> userData = {
      'expense': expenseController.text.trim(),
      'user_id': userId,
      'purchase_id': purchaseId,
      'date_id': dateId,
      'reason_id': Global.reasonId,
    };

    final String jsonData = jsonEncode(userData);

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/Expenses/Create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense creado'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Error al crear el gasto. Por favor, intenta de nuevo.'),
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
                // Text(
                //   'Reason ID: ${Global.reasonId}',
                //   style: const TextStyle(
                //     color: Colors.white,
                //     fontSize: 18,
                //   ),
                // ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: expenseController,
                  hintText: 'Expense',
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MySelectDate(
                  controller: dateController,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: purchaseController,
                  hintText: 'Buy',
                  obscureText: false,
                ),
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
