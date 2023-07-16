import 'package:animate_do/animate_do.dart';
import 'package:auth_handler/auth_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/main.dart';
import 'package:components/screens/login.dart';
import 'package:components/utils/tabBar.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_otp/email_otp.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  var _emainIsValid = true;
  var _passwordIsvalid = true;
  var _usernameIsValid = true;
  var _phoneIsValid = true;

  // email-verification-controller
  final TextEditingController _otpcontroller = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthHandler authHandler = AuthHandler();

  @override
  void initState() {
    authHandler.config(
      senderEmail: "noreply@dhatnoon-backend.firebaseapp.com",
      senderName: "Dhatnoon Service ",
      otpLength: 6,
    );
    super.initState();
  }

  // bool verify() {
  //   return emailAuth.validateOtp(
  //       recipientMail: _emailController.value.text,
  //       userOtp: _otpcontroller.text);
  //
  // }

  // void sendOtp() async {
  //
  //   // bool result = await emailAuth.sendOtp(
  //   //     recipientMail: _emailController.value.text, otpLength: 5);
  //   // if (result) {
  //   //   setState(() {
  //   //     submitValid = true;
  //   //   });
  //   // }
  // }

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logon.png',
                            width: 200,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Create Account",
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
                        height: 80,
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Stack(children: [
                            const ListTile(
                              // minVerticalPadding: 20,
                              trailing: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Icon(Icons.person_outline),
                              ),
                            ),
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorText: _usernameIsValid
                                    ? null
                                    : 'Enter valid username',
                                filled: true,
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 13,
                                ),
                                hintText: "User Name",
                                fillColor: Colors.transparent,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 44),
                              ),
                              keyboardType: TextInputType.name,
                            ),
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 320,
                        height: 80,
                        child: Card(
                          elevation: 10,
                          borderOnForeground: false,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Stack(
                            children: [
                              const ListTile(
                                minVerticalPadding: 20,
                                trailing: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Icon(Icons.phone_android),
                                ),
                              ),
                              TextField(
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText: _phoneIsValid
                                      ? null
                                      : 'Enter valid phone number',
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 13,
                                  ),
                                  hintText: "Phone",
                                  fillColor: Colors.transparent,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 44),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 320,
                        height: 80,
                        child: Card(
                          elevation: 10,
                          borderOnForeground: false,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.white,
                          child: Stack(
                            children: [
                              const ListTile(
                                minVerticalPadding: 20,
                                trailing: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Icon(Icons.email_outlined),
                                ),
                              ),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText: _emainIsValid
                                      ? null
                                      : 'Enter valid email',
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 13,
                                  ),
                                  hintText: "E-Mail",
                                  fillColor: Colors.transparent,
                                  isDense: true,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 44),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 320,
                        height: 80,
                        child: Card(
                          elevation: 10,
                          borderOnForeground: false,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
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
                                  )),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText: _passwordIsvalid
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 320,
                        height: 80,
                        child: InkWell(
                          onTap: () {
                            if (_emailController.text.trim().isEmpty ||
                                !_emailController.text.contains('@')) {
                              setState(() {
                                _emainIsValid = false;
                              });
                            } else {
                              setState(() {
                                _emainIsValid = true;
                              });
                            }

                            if (_passwordController.text.trim().length < 6 ||
                                _passwordController.text.isEmpty) {
                              setState(() {
                                _passwordIsvalid = false;
                              });
                            } else {
                              setState(() {
                                _passwordIsvalid = true;
                              });
                            }

                            if (_phoneController.text.trim().length > 10 ||
                                _phoneController.text.isEmpty) {
                              setState(() {
                                _phoneIsValid = false;
                              });
                            } else {
                              setState(() {
                                _phoneIsValid = true;
                              });
                            }

                            if (_usernameController.text.isEmpty) {
                              setState(() {
                                _usernameIsValid = false;
                              });
                            } else {
                              setState(() {
                                _usernameIsValid = true;
                              });
                            }

                            if (_emainIsValid &&
                                _passwordIsvalid &&
                                _phoneIsValid &&
                                _usernameIsValid) {
                              authHandler.sendOtp(_emailController.text);
                              Get.defaultDialog(
                                title: "OTP Verification",
                                content: Column(
                                  children: [
                                    Text(
                                        "Please enter OTP sent to ${_emailController.text.trim()}"),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 320,
                                      height: 80,
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.white70, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Colors.white,
                                        child: Stack(children: [
                                          const ListTile(
                                            trailing: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0),
                                              child: Icon(Icons.lock),
                                            ),
                                          ),
                                          TextField(
                                            controller: _otpcontroller,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 13,
                                              ),
                                              hintText: "Enter OTP",
                                              fillColor: Colors.transparent,
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 0, 44),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ]),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        authHandler
                                            .verifyOtp(_otpcontroller.text);
                                        Get.defaultDialog(
                                            title: "OTP Verified ✔",
                                            middleText:
                                                "please wait... redirecting to HomePage");
                                        signUp();
                                        // if () {
                                        //   Get.defaultDialog(
                                        //       title: "OTP Verified ✔",
                                        //       middleText:
                                        //       "please wait... redirecting to HomePage");
                                        //   signUp();
                                        // } else {
                                        //   Get.defaultDialog(
                                        //       title: "OTP Verification failed",
                                        //       middleText: "please try again...");
                                        // }
                                      },
                                      child: Card(
                                        color: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
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
                                            padding: EdgeInsets.fromLTRB(
                                                125, 20, 125, 20),
                                            child: Text(
                                              "Verify",
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
                                  ],
                                ),
                              );
                            }
                          },
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
                                padding: EdgeInsets.fromLTRB(125, 20, 125, 20),
                                child: Text(
                                  "Sign Up",
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
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => Get.to(const LogIn(),
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
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffcf366d),
                                  Color(0xffaf44ae),
                                  Color(0xff904fe5)
                                ],
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(65, 20, 65, 20),
                              child: Text(
                                "Already a user? Login Instead!",
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
                      const Text(
                        "Or continue with",
                        style: TextStyle(fontSize: 13, color: Colors.white),
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
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Image.asset(
                                      'assets/google-logo.png',
                                      width: 25,
                                      height: 25,
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
                    ]),
              )),
            )));
  }

  Future signUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final uniqueUserId = credential.user!.uid;
      print(uniqueUserId);

      final CollectionReference userInfoCollection =
          FirebaseFirestore.instance.collection('userInfo');
      DateTime now = DateTime.now();
      await userInfoCollection.doc(uniqueUserId).set({
        'username': _usernameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'userID': _usernameController.text
                .trim()
                .toLowerCase()
                .replaceAll(RegExp(' +'), '_') +
            now.day.toString() +
            now.hour.toString() +
            now.minute.toString() +
            now.second.toString() +
            now.millisecond.toString(),
        'useremail': _emailController.text.trim(),
      });
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }

    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }
}
