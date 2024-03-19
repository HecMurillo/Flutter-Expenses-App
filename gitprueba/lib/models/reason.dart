class Reason {
  final int id;
  final int userid;
  final String reason;

  const Reason({required this.id, required this.userid, required this.reason});

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      id: json['id'],
      userid: json['user_id'],
      reason: json['reason'],
    );
  }
}
