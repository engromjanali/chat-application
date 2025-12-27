class EFriend {
  final String userId;
  final String? name;
  final String? lastMessage;
  final DateTime? time;
  final int unreadMCount;
  final String? pImage;

  const EFriend({
    required this.userId,
    this.name,
    this.lastMessage,
    this.time,
    this.unreadMCount = 0,
    this.pImage,
  });
}
