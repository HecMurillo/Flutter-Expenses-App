import 'package:flutter/material.dart';
import 'package:gitprueba/models/expense.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecentPage extends StatefulWidget {
  const RecentPage({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  late String searchQuery = '';
  late Future<List<Expense>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = _fetchExpenses(widget.userId);
  }

  Future<List<Expense>> _fetchExpenses(int userId) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/recent-expenses/$userId'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((expense) => Expense.fromJson(expense)).toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<void> _onSearch(String query) async {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        _expensesFuture = _fetchExpenses(widget.userId);
      } else {
        _expensesFuture = _fetchExpensesWithSearch(widget.userId, query);
      }
    });
  }

  Future<List<Expense>> _fetchExpensesWithSearch(
      int userId, String searchTerm) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/SearchExpenses/$userId/$searchTerm'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((expense) => Expense.fromJson(expense)).toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            onChanged: (value) => _onSearch(value),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.0)),
                focusedBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(202, 189, 189, 189)),
                ),
                fillColor: const Color.fromRGBO(87, 101, 129, 0.6),
                filled: true,
                hintText: "Buscar",
                hintStyle:
                    const TextStyle(color: Color.fromARGB(183, 255, 255, 255))),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(15),
        ),
        Expanded(
          child: FutureBuilder<List<Expense>>(
            future: _expensesFuture,
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
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No se encontraron coincidencias!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Expense expense = snapshot.data![index];
                    return Container(
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(64, 75, 96, 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date: ${expense.date.date}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Buy: ${expense.purchase.buy}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Reason: ${expense.reason.reason}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Expense: ${expense.expense}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
