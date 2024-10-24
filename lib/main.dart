import 'package:flutter/material.dart';
import 'package:hash_demo/pages/home_page.dart';
import 'package:hash_demo/pages/login_page.dart';
import 'package:hash_demo/pages/register_page.dart';
import 'package:hash_demo/user.g.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;

  void func() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    func();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            );
          } else {
            return snapshot.data!;
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }

  Future<Widget> _getInitialPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if user data is available
    if (prefs.getString("username") != null) {
      return const HomePage(); // Redirect to HomePage if user is logged in
    } else {
      return const LoginPage(); // Redirect to LoginPage if user is not logged in
    }
  }
}
