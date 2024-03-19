class Date {
  final int id;
  final int userid;
  final String date;

  const Date({required this.id, required this.userid, required this.date});

  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      id: json['id'],
      userid: json['user_id'],
      date: json['date'],
    );
  }
}
