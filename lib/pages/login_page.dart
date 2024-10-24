import 'package:flutter/material.dart';
import 'package:hash_demo/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isSubmited = false;
  bool isKeyboardVisible = false;

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Log username and password for debugging purposes
    print("Logging in with username: $username and password: $password");

    // Check login success
    bool isSuccess = await UserService.loginUser(username, password);

    // Print whether login was successful
    print("Login successful: $isSuccess");

    if (isSuccess) {
      // Save username and password before redirection
      await saveData();

      // Print statement before navigating
      print("Redirecting to home page");

      // Redirect to home page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text('Invalid username or password'),
          ),
        ),
      );
    }
  }

  // Save data to SharedPreferences
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", _usernameController.text);
    await prefs.setString("password", _passwordController.text);

    // Print that data is saved
    print("Data saved to SharedPreferences");
  }

  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    height: isKeyboardVisible ? 250 : 400,
                    width: isKeyboardVisible ? 250 : 400,
                    child: Image.asset(
                      'assets/login.png',
                      height: 250,
                      width: 350,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username is Required Fields";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                      labelText: 'Username',
                      hintText: "Enter Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      // Check if the password meets the criteria
                      if (value == null || value.isEmpty) {
                        return 'Password is required Fields!';
                      } else if (value.length < 8 || value.length > 12) {
                        return 'Password must be between 8 and 12 \ncharacters!';
                      } else if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])')
                          .hasMatch(value)) {
                        return 'Password must contain at least one uppercase \nletter, one numeric character, and one \nspecial character!';
                      } else {
                        return null; // Clear the error if validation passes
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                      labelText: 'Password',
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 13.0),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: _isPasswordVisible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    obscuringCharacter: "*",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      splashFactory: InkRipple.splashFactory,
                      overlayColor: Colors.black,
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          _isSubmited = true;
                        });
                        _login();
                        setState(() {
                          _isSubmited = false;
                        });
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text("New User?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/register');
                          },
                          child: const Text("Register Here!"))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
