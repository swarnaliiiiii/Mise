class FriendDebt {
  final String name;
  final String date;
  final double amount;
  final bool isOwedToMe; // true = green (+), false = red (-)
  final String imageUrl;

  FriendDebt({
    required this.name,
    required this.date,
    required this.amount,
    required this.isOwedToMe,
    required this.imageUrl,
  });

  factory FriendDebt.fromJson(Map<String, dynamic> json) {
    return FriendDebt(
      name: json['name'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      isOwedToMe: json['isOwedToMe'] as bool,
      imageUrl: json['imageUrl'] as String,
    );
  }
}