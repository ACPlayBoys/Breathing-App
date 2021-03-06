// ignore_for_file: prefer_const_constructors, unnecessary_new, dead_code_on_catch_subtype

import 'dart:convert';

import 'package:breathing_app/models/userdetails.dart';
import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OTPScreen extends StatefulWidget {
  EmailAuth emailAuth;

  OTPScreen(PageController pageController, this.emailAuth, {Key? key})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var selectedValue;

  var _first = false;

  final String path = "asset/images/signup/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              Image.asset(
                path + "logo3.png",
                fit: BoxFit.cover,
              ).expand(),
            ],
          ).pOnly(top: 64),
          "Enter OTP"
              .text
              .fontFamily("Poppins")
              .bold
              .size(25)
              .fontWeight(FontWeight.w700)
              .center
              .make()
              .centered()
              .pOnly(bottom: 32),
          buildPinPut(context).px4(),
          AnimatedCrossFade(
            duration: const Duration(seconds: 1),
            firstChild: const Icon(
              Icons.done,
              size: 50,
            ),
            secondChild: Container(),
            crossFadeState:
                _first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ).py16()
        ]),
      ),
    );
  }

  Widget buildPinPut(BuildContext context) {
    double radius = 60;
    final defaultPinTheme = PinTheme(
      width: radius,
      height: radius,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(35, 0, 0, 0)),
        borderRadius: BorderRadius.circular(100),
      ),
    );
    return Pinput(
      length: 6,
      defaultPinTheme: defaultPinTheme,
      onCompleted: (pin) async {
        bool shit =
            widget.emailAuth.validateOtp(recipientMail: email, userOtp: pin);
        print(email);

        if (shit) {
          try {
            final credential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: email,
            );
            CollectionReference users =
                FirebaseFirestore.instance.collection('Users');
            users.doc(credential.user!.uid);
            users.doc(credential.user!.uid).set(userDetails);
            _first = true;
            setState(() {});
            await Future.delayed(Duration(seconds: 2));
            await Navigator.of(context).push(Routes.createLoginRoute());
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              showToast(context, 'The password provided is too weak.');
              print('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              showToast(context,
                  'The account already exists for that email. Please Login');
              print('The account already exists for that email.');
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              showToast(context, 'No user found for that email.');
              print('No user found for that email.');
            } else if (e.code == 'wrong-password') {
              showToast(context, 'Wrong password provided for that user.');
              // ignore: avoid_print
              print('Wrong password provided for that user.');
            }
          }
        } else
          showToast(context, "Wrong Otp");
      },
    );
  }
}
