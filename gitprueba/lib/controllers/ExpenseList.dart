import 'package:flutter/material.dart';
import 'package:gitprueba/models/reason.dart';
import 'package:gitprueba/controllers/ExpenseItem.dart';
import 'package:gitprueba/controllers/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key, required this.userId, required this.userName})
      : super(key: key);

  final int userId;
  final String userName;

  Future<List<Reason>> _fetchReasons(int userId) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/ListReasonReason/$userId'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((reason) => Reason.fromJson(reason)).toList();
    } else {
      throw Exception('Failed to load reasons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reason>>(
      future: _fetchReasons(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
            '${snapshot.error}',
            style: const TextStyle(
              color: Colors.white,
            ),
          );
        } else if (snapshot.hasData) {
          Set<int> uniqueReasonIds =
              Set<int>(); // Conjunto de IDs de razones únicas
          return Column(
            children: [
              // Aquí mostramos el ID del usuario
              Text(
                '¡Welcome $userName!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Reason reason = snapshot.data![index];
                      // Verificar si la razón ya ha sido mostrada
                      if (!uniqueReasonIds.contains(reason.id)) {
                        uniqueReasonIds
                            .add(reason.id); // Agregar ID de razón al conjunto
                        return InkWell(
                          onTap: () {
                            Global.reasonId = reason
                                .id; // Asigna el id del reason a Global.reasonId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpenseItem(
                                    userId: userId, reason: reason.reason),
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(64, 75, 96, 0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      reason.reason,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(); // Si la razón ya se mostró, retornar un SizedBox
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }
      },
    );
  }
}
