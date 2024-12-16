import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Schedule {
  final String id;
  final String userId;
  final String placeId;
  final DateTime date;
  final DateTime startingTime;
  final DateTime endingTime;

  Schedule({
    String? id,
    required this.userId,
    required this.placeId,
    required this.date,
    required this.startingTime,
    required this.endingTime,
  }) : id = id ?? const Uuid().v4();

// Convert Schedule object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'placeId': placeId,
      'date':
          DateFormat('dd/MM/yyyy').format(date), // Format date as dd/MM/yyyy
      'startingTime': DateFormat('HH:mm')
          .format(startingTime), // Format start time as HH:mm
      'endingTime':
          DateFormat('HH:mm').format(endingTime), // Format end time as HH:mm
    };
  }

  // Create Schedule object from Map<String, dynamic>
  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      userId: map['userId'],
      placeId: map['placeId'],
      date: DateTime.parse(map['date']), // Parse ISO 8601 formatted date
      startingTime: DateTime.parse(map['startingTime']),
      endingTime: DateTime.parse(map['endingTime']),
    );
  }

  @override
  String toString() {
    // Formatting date and time for display
    return 'Schedule:\n'
        'User ID: $userId\n'
        'Place ID: $placeId\n'
        'Date: ${_formatDate(date)}\n'
        'Starting Time: ${_formatTime(startingTime)}\n'
        'Ending Time: ${_formatTime(endingTime)}';
  }

  // Private helper to format DateTime to "dd/MM/yyyy"
  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  // Private helper to format DateTime to "HH:mm"
  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
