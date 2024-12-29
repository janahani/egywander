import 'package:uuid/uuid.dart';

class TableInfo {
  final String id;
  int tableNumber;
  int seatCount;

  TableInfo({
    String? id,
    required this.tableNumber,
    required this.seatCount,
  }) : id = id ?? const Uuid().v4();
}
