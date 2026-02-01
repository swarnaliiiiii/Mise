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
}