import 'package:flutter/material.dart';
import 'package:hash_demo/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  bool _isSubmited = false;
  bool _isPasswordVisible = false;
  bool _isCPasswordVisible = false;
  bool isKeyboardVisible = false;

  Future<void> _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    await UserService.registerUser(username, password, email);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Center(child: Text('Registration successful'))),
    );

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 50.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 500,
                    ),
                    height: isKeyboardVisible ? 150 : 250,
                    width: isKeyboardVisible ? 150 : 250,
                    child: Image.asset(
                      'assets/register.png',
                      height: 250,
                      width: 350,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
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
                      if (value == null || value.isEmpty) {
                        return 'Email is required Fields!';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please Enter A Valid Email Address';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                      labelText: 'Email',
                      hintText: "Enter Email",
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
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      // Check if the password meets the criteria
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password is required Fields!';
                      } else if (_passwordController.text !=
                          _cpasswordController.text) {
                        return 'The passwords you entered do not match.\nPlease double-check and try again.';
                      }
                      return null;
                      // Return the error message
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _cpasswordController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                      labelText: 'Confirm Password',
                      hintText: "Confirm Password",
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
                              _isCPasswordVisible = !_isCPasswordVisible;
                            });
                          },
                          icon: _isCPasswordVisible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    obscureText: !_isCPasswordVisible,
                    obscuringCharacter: "*",
                  ),
                  const SizedBox(
                    height: 25,
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
                        _register();
                        setState(() {
                          _isSubmited = false;
                        });
                      }
                    },
                    child: const Text(
                      'Sign up',
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
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text("Login!"))
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
