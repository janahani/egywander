class Schedule {
  final String userId;
  final String placeName;
  final DateTime date;         
  final DateTime startingTime; 
  final DateTime endingTime;  

  Schedule({
    required this.userId,
    required this.placeName,
    required this.date,
    required this.startingTime,
    required this.endingTime,
  });

  // Convert Schedule object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'placeName': placeName,
      'date': date.toIso8601String(), // ISO 8601 format for standard storage
      'startingTime': startingTime.toIso8601String(),
      'endingTime': endingTime.toIso8601String(),
    };
  }

  // Create Schedule object from Map<String, dynamic>
  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      userId: map['userId'],
      placeName: map['placeName'],
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
           'Place Name: $placeName\n'
           'Date: ${_formatDate(date)}\n'
           'Starting Time: ${_formatTime(startingTime)}\n'
           'Ending Time: ${_formatTime(endingTime)}';
  }

  // Private helper to format DateTime to "dd/MM/yyyy"
  String _formatDate(DateTime dt) => '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  // Private helper to format DateTime to "HH:mm"
  String _formatTime(DateTime dt) => '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
