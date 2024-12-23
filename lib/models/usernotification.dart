class UserNotification {
  final int? id;
  final String placename;
  final DateTime date;
  final DateTime startingTime;
  final DateTime endingTime;
  final DateTime notificationsTime;

  UserNotification({
    this.id,
    required this.placename,
    required this.date,
    required this.startingTime,
    required this.endingTime,
    required this.notificationsTime,
  });

  // Convert a Notification object into a map to store in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placename': placename,
      'date': date.toIso8601String(),
      'startingTime': startingTime.toIso8601String(),
      'endingTime': endingTime.toIso8601String(),
      'notificationsTime': notificationsTime.toIso8601String(),
    };
  }

  factory UserNotification.fromMap(Map<String, dynamic> map) {
    return UserNotification(
      id: map['id'],
      placename: map['placename'],
      date: DateTime.parse(map['date']),
      startingTime: DateTime.parse(map['startingTime']),
      endingTime: DateTime.parse(map['endingTime']),
      notificationsTime: DateTime.parse(map['notificationsTime']),
    );
  }
}
