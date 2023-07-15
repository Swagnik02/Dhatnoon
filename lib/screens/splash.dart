import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:components/screens/login.dart';
import 'package:components/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/splash2.jpeg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        ElasticInUp(
          delay: const Duration(seconds: 2),
          duration: const Duration(seconds: 3),
          animate: true,
          child: Align(
            alignment: const Alignment(0.0, 0.9),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              alignment: const Alignment(0.0, 0.0),
              width: 350,
              height: 250,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      fixedSize: const Size(300, 60),
                      elevation: 20,
                      shadowColor: Colors.white30,
                      primary: Colors.blue,
                    ),
                    onPressed: () => Get.to(const LogIn(),
                        transition: Transition.downToUp,
                        duration: const Duration(milliseconds: 400)),
                    child: const Text("Log In",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.white,
                    indent: 70,
                    endIndent: 70,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      elevation: 20,
                      shadowColor: Colors.white30,
                      fixedSize: const Size(300, 60),
                      primary: Colors.blue,
                    ),
                    onPressed: () => Get.to(const SignUp(),
                        transition: Transition.downToUp,
                        duration: Duration(milliseconds: 400)),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) // Align
      ]),
    );
  }
}