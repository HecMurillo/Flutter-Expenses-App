class Purchase {
  final int id;
  final int userid;
  final String buy;

  const Purchase({required this.id, required this.userid, required this.buy});

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'],
      userid: json['user_id'],
      buy: json['buy'],
    );
  }
}
