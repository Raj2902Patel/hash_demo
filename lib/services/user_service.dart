import 'package:hash_demo/models/user.dart';
import 'package:hash_demo/utils/encryption.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserService {
  static Future<void> registerUser(
      String username, String password, String email) async {
    var box = await Hive.openBox('users');
    String passwordHash = hashPassword(password);
    User newUser =
        User(username: username, passwordHash: passwordHash, email: email);
    await box.put(username, newUser);
  }

  static Future<bool> loginUser(String username, String password) async {
    var box = await Hive.openBox('users');
    User? user = box.get(username);

    if (user != null) {
      String passwordHash = hashPassword(password);
      if (user.passwordHash == passwordHash) {
        return true;
      }
    }
    return false;
  }

  static Future<List<User>> getAllUsers() async {
    var box = await Hive.openBox('users');
    return box.values.cast<User>().toList();
  }
}
