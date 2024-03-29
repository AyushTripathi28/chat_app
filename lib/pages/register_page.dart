import 'package:chat_app/components/my_buttons.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //tap to go to login page
  final void Function() onTap;
  RegisterPage({super.key, required this.onTap});

  //register function
  void register(BuildContext context) {
    print("Email: ${_emailController.text}");
    print("Password: ${_passwordController.text}");
    final auth = AuthService();
    //check if password and confirm password are the same
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        auth.signUpWithEmailAndPassword(_nameController.text,
            _emailController.text, _passwordController.text);
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
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Password does not match"),
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
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            child: Text("Register",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 35.0),
                            child: Text(
                              "Let's create a account for you",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          MyTextField(
                            hintText: "Name",
                            obscureText: false,
                            controller: _nameController,
                            icon: Icons.person_outline,
                          ),

                          const SizedBox(height: 10),
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

                          const SizedBox(height: 10),

                          //confirm pw textfield
                          MyTextField(
                            hintText: "Confirm Password",
                            obscureText: true,
                            controller: _confirmPasswordController,
                            icon: Icons.lock_outline,
                          ),

                          const SizedBox(height: 25),
                          //login btn

                          MyButton(
                            text: "Register",
                            onTap: () => register(context),
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
                          "Already have a account? ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Text(
                            "Login Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
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
          ),
        ),
      ),
    );
  }
}
