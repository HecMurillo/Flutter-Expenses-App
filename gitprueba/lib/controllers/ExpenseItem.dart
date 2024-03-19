import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gitprueba/controllers/CreateExpense.dart';
import 'package:gitprueba/controllers/BuyUpdate.dart';
import 'package:gitprueba/controllers/ExpenseUpdate.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({Key? key, required this.userId, required this.reason})
      : super(key: key);

  final int userId;
  final String reason;

  @override
  State<ExpenseItem> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  late Future<Map<String, dynamic>> futureExpense;

  @override
  void initState() {
    super.initState();
    futureExpense = fetchExpense();
  }

  Future<Map<String, dynamic>> fetchExpense() async {
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/api/ListReasonUser/${widget.userId}/${widget.reason}'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Expense');
    }
  }

  void _updateExpense() {
    setState(() {
      futureExpense = fetchExpense();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        title: Text('${widget.reason} Detail',
            style: const TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: futureExpense,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white)));
              } else {
                final data = snapshot.data!;
                final totalExpenses = data.remove('total_expenses');
                final expenses = data.values.toList();

                return Container(
                  color: const Color.fromRGBO(58, 66, 86, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: expenses.isEmpty
                              ? const Center(
                                  child: Text(
                                    '¡Todavía no has agregado algun gasto!',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              : Card(
                                  color: const Color.fromRGBO(58, 66, 86, 1.0),
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(
                                          label: Text('Buy',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn(
                                          label: Text('Expense',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                    rows: expenses.map<DataRow>((expense) {
                                      final expenseId = expense[
                                          'id']; // Obtiene el id de expense
                                      final purchase = expense['purchase']
                                          as Map<String, dynamic>;

                                      if (expenseId == null ||
                                          purchase['id'] == null) {
                                        throw Exception(
                                            'Missing id in expense or purchase');
                                      }

                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BuyUpdate(
                                                      Id: expenseId, // Usa el id de expense
                                                      buy: purchase['buy']
                                                          .toString(),
                                                      onUpdated: () {
                                                        _updateExpense();
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                purchase['buy'].toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExpenseUpdate(
                                                      Id: expenseId, // Usa el id de expense
                                                      expense:
                                                          expense['expense']
                                                              .toString(),
                                                      onUpdated: () {
                                                        _updateExpense();
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                expense['expense'].toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total ${widget.reason} : $totalExpenses',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateExpense(
                          userId: widget.userId), // Pasa userId aquí
                    ),
                  );

                  if (result != null && result) {
                    // Actualiza la página de inicio
                    setState(() {
                      futureExpense = fetchExpense();
                    });
                  }
                },
                backgroundColor: const Color.fromRGBO(64, 75, 96, 0.9),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
