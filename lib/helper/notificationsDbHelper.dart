//packages
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//model
import 'package:egywander/models/usernotification.dart';

class NotificationDbHelper {
  static final NotificationDbHelper instance = NotificationDbHelper._init();
  static Database? _database;

  NotificationDbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the 'notifications' table
  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE notifications (
      id $idType,
      placename $textType,
      date $dateType,
      startingTime $dateType,
      endingTime $dateType,
      notificationsTime $dateType
    )
    ''');
  }

  // Insert a Notification into the database
  Future<int> insertNotification(UserNotification notification) async {
    final db = await database;
    return await db.insert('notifications', notification.toMap());
  }

  // Get all notifications
  Future<List<UserNotification>> getNotifications() async {
    final db = await database;
    final maps = await db.query('notifications');

    return List.generate(maps.length, (i) {
      return UserNotification.fromMap(maps[i]);
    });
  }

  // Get a single notification by ID
  Future<UserNotification?> getNotification(int id) async {
    final db = await database;
    final maps =
        await db.query('notifications', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return UserNotification.fromMap(maps.first);
    }
    return null;
  }

  // Delete a notification by ID
  Future<int> deleteNotification(int id) async {
    final db = await database;
    return await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getNotificationsForToday() async {
    final db = await database;
    String today = DateTime.now()
        .toIso8601String()
        .split("T")[0]; // Get only the date part
    return await db.query(
      'notifications',
      where: 'date >= ? AND date <= ?',
      whereArgs: [today + "T00:00:00", today + "T23:59:59"],
    );
  }

  Future<void> removeExpiredNotifications() async {
    final db = await database;
    String today = DateTime.now().toIso8601String().split("T")[0];
    await db.delete(
      'notifications',
      where: 'date < ?',
      whereArgs: [today + "T00:00:00"],
    );
  }

  Future<void> clearAllNotifications() async {
    final db = await database; // Ensure database is initialized
    await db.delete(
        'notifications'); // Replace 'notifications' with your table name
    print("All notifications have been deleted.");
  }
}
