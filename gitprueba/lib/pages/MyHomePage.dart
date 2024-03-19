import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gitprueba/controllers/CreateReason.dart';
import 'package:gitprueba/pages/RecentPage.dart';
import 'package:http/http.dart' as http;
import 'package:gitprueba/models/expense.dart';
import 'package:gitprueba/controllers/ExpenseList.dart';
import 'package:gitprueba/pages/ProfilePage.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

Future<List<Expense>> fetchExpense() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/Expenses'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((expense) => Expense.fromJson(expense)).toList();
  } else {
    throw Exception('Failed to load Expense');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.userEmail})
      : super(key: key);

  final int userId;
  final String userName;
  final String userEmail;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;
  late Future<List<Expense>> futureExpense;

  @override
  void initState() {
    super.initState();
    futureExpense = fetchExpense();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
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
      body: Center(
        child: _getBody(),
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        labels: const ["Recent", "Home", "Profile"],
        icons: const [
          Icons.dashboard,
          Icons.home,
          Icons.people_alt,
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.white,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: const Color.fromRGBO(75, 87, 110, 0.776),
        tabIconSelectedColor: Colors.white,
        tabBarColor: const Color.fromRGBO(58, 66, 86, 1.0),
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController.index = value;
          });
        },
      ),
    );
  }

  Widget _getBody() {
    switch (_motionTabBarController.index) {
      case 0:
        return RecentPage(userId: widget.userId);
      case 1:
        return Stack(
          children: [
            ExpenseList(userId: widget.userId, userName: widget.userName),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateReason(
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
        );
      case 2:
        return ProfilePage(
            userEmail: widget.userEmail,
            userName: widget.userName,
            userId: widget.userId);
      default:
        return Container();
    }
  }
}
