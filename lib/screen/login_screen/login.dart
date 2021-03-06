// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:breathing_app/util/constants.dart';
import 'package:breathing_app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  var selectedValue;

  String curemail = "";

  String cnfemail = "";

  Login({Key? key}) : super(key: key);
  final String path = "asset/images/signup/";

  @override
  Widget build(BuildContext context) {
    var y = MediaQuery.of(context).size.height;
    var x = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  "Login"
                      .text
                      .fontFamily("Poppins")
                      .bold
                      .size(25)
                      .fontWeight(FontWeight.w700)
                      .center
                      .make()
                      .centered()
                      .pOnly(top: y / 16, bottom: y / 32),
                  Row(
                    children: [
                      Image.asset(
                        path + "logo2.png",
                        height: y / 4,
                        fit: BoxFit.contain,
                      ).expand(),
                    ],
                  ).pOnly(bottom: y / 16),
                  Container(
                    height: y / 16,
                    child: TextField(
                      onChanged: (value) {
                        curemail = value.toLowerCase().trim();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 20),
                        label: "Enter Your Email Address".text.make().px8(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(y / 20)),
                      ),
                    ),
                  ).pOnly(bottom: y / 32, left: x / 16, right: x / 16),
                  Container(
                    height: y / 16,
                    child: TextField(
                      onChanged: (value) {
                        cnfemail = value.toLowerCase().trim();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 20),
                        label: "Confirm Your Email Address".text.make().px8(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(y / 20)),
                      ),
                    ),
                  ).pOnly(left: x / 16, right: x / 16),
                ],
              ).pOnly(bottom: y / 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: x / 2,
                    height: y / 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        "Send OTP"
                            .text
                            .fontFamily("Poppins")
                            .normal
                            .size(25)
                            .fontWeight(FontWeight.w500)
                            .center
                            .color(Colors.white)
                            .make(),
                      ],
                    ).px12(),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 38, 101, 228), width: 1),
                        gradient: RadialGradient(
                            radius: 4,
                            colors: [Color(0xff2C6AE4), Color(0xffC4C4C4)]),
                        borderRadius: BorderRadius.circular(50)),
                  ).onInkTap(() async {
                    if (cnfemail != curemail) {
                      showToast(context, "Email not mathing");
                      return;
                    }
                    if (!curemail.isValidEmail()) {
                      showToast(context, "Email invalid");
                      return;
                    }

                    var email = this.curemail;
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: email);
                      Navigator.of(context).push(
                          Routes.createLoginOtpScreen(email.toLowerCase()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        showToast(context, 'No user found for that email.');
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        showToast(
                            context, 'Wrong password provided for that user.');
                        print('Wrong password provided for that user.');
                      }
                    }
                  }),
                ],
              ),
              Row(children: <Widget>[
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                      child: Divider(
                        color: Color.fromARGB(55, 0, 0, 0),
                        thickness: 1,
                      )),
                ),
                Text("OR"),
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                      child: Divider(
                        color: Color.fromARGB(55, 0, 0, 0),
                        thickness: 1,
                      )),
                ),
              ]).pOnly(top: y / 64, bottom: y / 128),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Login Using".text.lg.bold.makeCentered(),
                ],
              ).pOnly(bottom: y / 128),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(path + "apple.png").px8(),
                  Image.asset(path + "google.png").p8(),
                  Image.asset(path + "fb.png").px8(),
                  Image.asset(path + "twitter.png").px8(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  "Not a Member"
                      .text
                      .size(15)
                      .fontWeight(FontWeight.w300)
                      .make()
                      .pOnly(right: 8),
                  "Sign Up Here"
                      .text
                      .size(15)
                      .fontWeight(FontWeight.w400)
                      .underline
                      .make()
                      .onInkTap(() {
                    Navigator.of(context).push(Routes.createSignUpRoute());
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
