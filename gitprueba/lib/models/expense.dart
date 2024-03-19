import 'package:gitprueba/models/User.dart';
import 'package:gitprueba/models/date.dart';
import 'package:gitprueba/models/purchase.dart';
import 'package:gitprueba/models/reason.dart';

class Expense {
  final int id;
  final String expense;
  final User user;
  final Purchase purchase;
  final Date date;
  final Reason reason;

  const Expense(
      {required this.id,
      required this.expense,
      required this.user,
      required this.purchase,
      required this.date,
      required this.reason});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      expense: json['expense'],
      user: User.fromJson(json['user']),
      purchase: Purchase.fromJson(json['purchase']),
      date: Date.fromJson(json['date']),
      reason: Reason.fromJson(json['reason']),
    );
  }
}
