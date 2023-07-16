import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/screens/signup.dart';
import 'package:components/utils/listWheelScrollView.dart';
import 'package:components/utils/tabBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:components/main.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'ResetScreen.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _emailIsValid = true;
  var _passwordIsValid = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  googleLogin() async {
    print("GoogleLogin method called");
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return;
      }
      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      var finalResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("Result $result ");
      print(result.displayName);
      print(result.email);
      print(result.photoUrl);
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
    () async {
      Get.to(const SignUp());
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff270745),
            Color(0xff250543),
            Color(0xff170036),
            Color(0xff120032),
            Color(0xff120032),
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Container(
            margin: const EdgeInsets.fromLTRB(20, 40, 20, 40),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logon.png',
                          width: 200,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      " \n Welcome Back \n",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 320,
                      // height: 85,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: Stack(
                          children: [
                            const ListTile(
                              minVerticalPadding: 20,
                              trailing: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Icon(Icons.email_outlined)),
                            ),
                            TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText: _emailIsValid
                                      ? null
                                      : 'Enter valid email',
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 13,
                                  ),
                                  hintText: "E-mail",
                                  fillColor: Colors.transparent,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 44),
                                ),
                                keyboardType: TextInputType.emailAddress),
                            _emailIsValid
                                ? const SizedBox(height: 10)
                                : const SizedBox(height: 95),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      width: 320,
                      // height: 80,
                      child: Card(
                        elevation: 10,
                        borderOnForeground: false,
                        shape: RoundedRectangleBorder(
                          side:
                              const BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.white,
                        child: Stack(
                          children: [
                            const ListTile(
                              minVerticalPadding: 20,
                              trailing: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Icon(Icons.password_outlined),
                              ),
                            ),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorText: _passwordIsValid
                                    ? null
                                    : 'Password must be atleast 6 characters',
                                filled: true,
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 13,
                                ),
                                hintText: "Password",
                                fillColor: Colors.transparent,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 44),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            _passwordIsValid
                                ? const SizedBox(height: 10)
                                : const SizedBox(height: 95),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => signIn(),
                      child: Card(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.white70,
                            ),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xffcf366d),
                                Color(0xffaf44ae),
                                Color(0xff904fe5)
                              ],
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(135, 20, 135, 20),
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => Get.to(const SignUp(),
                          transition: Transition.downToUp),
                      child: Card(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Colors.white70,
                              ),
                              // gradient: const LinearGradient(
                              //   colors: [
                              //     Color(0xffcf366d),
                              //     Color(0xffaf44ae),
                              //     Color(0xff904fe5)
                              //   ],
                              // ),
                              color: Colors.transparent),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                            child: Text(
                              "New User? Create an account instead!",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () => Get.to(const ResetScreen()),
                      child: const Text(
                        "Forgot your Password?",
                        style: TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 255, 65, 118)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 320,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              child: InkWell(
                                onTap: () => googleLogin(),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    // child: Text(
                                    //   "G",
                                    //   style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 18),
                                    // ),
                                    child: Image.asset(
                                      'assets/google-logo.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //   width: 120,
                            //   child: Card(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     color: Colors.blue.shade900,
                            //     child: Padding(
                            //       padding:
                            //       const EdgeInsets.fromLTRB(50, 18, 40, 18),
                            //       child: Text(
                            //         "f",
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 18),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          )

          // Stack(
          //   children: [

          //     FadeInUp(
          //       delay: Duration(milliseconds: 1100),
          //       child: Align(
          //         alignment: Alignment(0.42, 0.12),
          //          Text(
          //           "Forgot your Password?",
          //           style: TextStyle(
          //               fontSize: 13, color: Color.fromARGB(255, 255, 65, 118)),
          //         ),
          //       ),
          //     ),
          //     FadeInUp(
          //       duration: Duration(milliseconds: 500),
          //       delay: Duration(milliseconds: 1000),
          //       child: Align(
          //         alignment: Alignment(0.0, 0.28),
          //         child: InkWell(
          //           onTap: () => signIn(),
          //           child: Card(
          //             color: Colors.transparent,
          //             child: Container(
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.all(Radius.circular(10)),
          //                 border: Border.all(
          //                   color: Colors.white70,
          //                 ),
          //                 gradient: LinearGradient(
          //                   colors: [
          //                     Color(0xffcf366d),
          //                     Color(0xffaf44ae),
          //                     Color(0xff904fe5)
          //                   ],
          //                 ),
          //               ),
          //               child: Padding(
          //                 padding: const EdgeInsets.fromLTRB(135, 20, 135, 20),
          //                 child: Text(
          //                   "Log In",
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 12,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     FadeInUp(
          //       delay: Duration(milliseconds: 1100),
          //       child: Align(
          //         alignment: Alignment(0.0, 0.38),
          //         child: Text(
          //           "Or continue with",
          //           style: TextStyle(fontSize: 13, color: Colors.white),
          //         ),
          //       ),
          //     ),
          //     FadeInUp(
          //       delay: Duration(milliseconds: 1150),
          //       child: Align(
          //         alignment: Alignment(-0.73, 0.55),
          //         child: Card(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           color: Colors.blue,
          //           child: Padding(
          //             padding: const EdgeInsets.fromLTRB(60, 18, 60, 18),
          //             child: Text(
          //               "G",
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 18,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     FadeInUp(
          //       delay: Duration(milliseconds: 1200),
          //       child: Align(
          //         alignment: Alignment(0.7, 0.55),
          //         child: Card(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           color: Colors.blue.shade900,
          //           child: Padding(
          //             padding: const EdgeInsets.fromLTRB(60, 18, 60, 18),
          //             child: Text(
          //               "f",
          //               style: TextStyle(
          //                   color: Colors.white,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 18),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     FadeInUp(
          //       delay: Duration(milliseconds: 1200),
          //       child: Align(
          //         alignment: Alignment(0.0, 0.67),
          //         child: Text(
          //           "Don't have an account? Sign up",
          //           style: TextStyle(fontSize: 13, color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }

  Future signIn() async {
    if (_emailController.text.trim().isEmpty ||
        !_emailController.text.contains('@')) {
      setState(() {
        _emailIsValid = false;
      });
    } else {
      _emailIsValid = true;
    }

    if (_passwordController.text.trim().length < 6 ||
        _passwordController.text.isEmpty) {
      setState(() {
        _passwordIsValid = false;
      });
    } else {
      setState(() {
        _passwordIsValid = true;
      });
    }

    if (_emailIsValid && _passwordIsValid) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim())
            .then((userCredential) {
          print(userCredential.user?.displayName);
          Get.to(MyHomePage());
        });
      } on FirebaseAuthException catch (e) {
        print(e.toString());
      }
    }
  }

  Future<Future<UserCredential>> signInFacebook() async {
    final LoginResult loginResult =
        await FacebookAuth.instance.login(permissions: ['email']);
    if (loginResult == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
    }
    final OAuthCredential oauthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance
        .signInWithCredential(OAuthCredential as AuthCredential);
  }
}
