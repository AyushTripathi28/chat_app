import 'package:chat_app/components/my_buttons.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function() onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  //login function
  void login(BuildContext context) {
    print("Email: ${_emailController.text}");
    print("Password: ${_passwordController.text}");
    final authService = AuthService();

    try {
      setState(() {
        _isLoading = true;
      });
      authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //welcome back message
              const Spacer(
                flex: 5,
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text("Login",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        "Please login to continue",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    //email
                    MyTextField(
                      hintText: "Email",
                      obscureText: false,
                      controller: _emailController,
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 10),

                    //pw textfield
                    MyTextField(
                      hintText: "Password",
                      obscureText: true,
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                    ),

                    const SizedBox(height: 25),
                    //login btn

                    MyButton(
                      text: "Login",
                      onTap: () => login(context),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
              const Spacer(
                flex: 4,
              ),
              //register row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
