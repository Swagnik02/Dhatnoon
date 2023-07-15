import 'dart:ui';

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
import 'login.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late final GoogleSignIn _googleSignIn = GoogleSignIn();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
            child: SingleChildScrollView(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: 10,),
                  const Text(
                    " \n\n\n\n Forgot Password ? \n\n",
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    alignment: Alignment.center,
                    width: 320,
                    height: 85,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white70, width: 1),
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
                                filled: true,
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 13,
                                ),
                                hintText: "E-mail  ",
                                fillColor: Colors.transparent,
                                isDense: true,
                                contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 44),
                              ),
                              keyboardType: TextInputType.emailAddress),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: ()=> {
                      auth.sendPasswordResetEmail(email : _emailController.text),
                      Navigator.of(context).pop()

                  },
                    child: Card(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                       // margin:  EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: const Padding(

                          padding: EdgeInsets.fromLTRB(105, 22, 105, 22),
                          child: Text(
                            "Send Request",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])
               )
              ),
      ),
    );
  }
}



