import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String passwordHash;

  @HiveField(2)
  final String email;

  User({
    required this.username,
    required this.passwordHash,
    required this.email,
  });
}
