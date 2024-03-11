import 'package:afrikalyrics_mobile/auth/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth_controller.dart';
import '../signin_enum.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: authController.emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
            TextField(
              controller: authController.passwordController,
              decoration: InputDecoration(hintText: "Password"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      authController.handleSignIn(SignInType.EMAIL_PASSWORD);
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.primaries[0],
                    ),
                    onPressed: () {
                      authController.handleSignIn(SignInType.GOOGLE);
                    },
                    child: Text(
                      "SignIn with Google",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => RegisterScreen());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No account ? Register Here!"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
