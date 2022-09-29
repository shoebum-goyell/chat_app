import 'package:chat_app/colors.dart';
import 'package:chat_app/login_screen.dart';
import 'package:chat_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var emailId = "";
  var password = "";
  var username = "";
  bool isPass = false;
  bool isEnabled = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorDark,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            height: 550,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: kColorAppBarFont)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome!",
                    style: GoogleFonts.lexendDeca(
                        textStyle:
                            TextStyle(color: kBackgroundColor, fontSize: 60))),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1, color: Colors.black),
                      color: kColorTextField),
                  child: TextField(
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration.collapsed(
                        hintText: "Email id",
                        hintStyle: TextStyle(color: Color(0xff596E79)),
                      ),
                      onChanged: (text) {
                        setState(() {
                          emailId = text;
                          enableButton();
                        });
                      }),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1, color: Colors.black),
                      color: kColorTextField),
                  child: TextField(
                      obscureText: true,
                      decoration: const InputDecoration.collapsed(
                          hintText: "Password",
                          hintStyle: TextStyle(color: Color(0xff596E79))),
                      onChanged: (text) {
                        setState(() {
                          password = text;
                          if (password.length < 6) {
                            isPass = false;
                          } else {
                            isPass = true;
                          }
                          enableButton();
                        });
                      }),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(width: 1, color: Colors.black),
                      color: kColorTextField),
                  child: TextField(
                      autocorrect: false,
                      decoration: const InputDecoration.collapsed(
                          hintText: "Username",
                          hintStyle: TextStyle(color: Color(0xff596E79))),
                      onChanged: (text) {
                        setState(() {
                          username = text;
                          enableButton();
                        });
                      }),
                ),
                !isLoading
                    ? ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kColorTextField)),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          signUp();
                        },
                        child: Container(
                            child: const Text(
                          "Create",
                          style: TextStyle(color: kColorDark),
                        )))
                    : SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: kBackgroundColor,
                          strokeWidth: 2,
                        )),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(color: kColorAppBarFont)),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(color: kBackgroundColor),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    if (isEnabled) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailId.trim(), password: password.trim());
        final chatsDocu = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid);
        final user = UserObj(
            uid: FirebaseAuth.instance.currentUser!.uid, username: username);
        final json = user.toJson();
        await chatsDocu.set(json);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("You've signed up")));
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Couldn't create a new user", style: TextStyle(color: kColorDark)), backgroundColor: kBackgroundColor,));
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: !isPass
              ? Text(
                  "Password must be longer than 6 letters",
                  style: TextStyle(color: kColorDark),
                )
              : emailId.trim().isEmpty
                  ? Text(
                      "Email id cannot be empty",
                      style: TextStyle(color: kColorDark),
                    )
                  : Text(
                      "Username cannot be empty",
                      style: TextStyle(color: kColorDark),
                    ), backgroundColor: kBackgroundColor,));
      setState(() {
        isLoading = false;
      });
    }
  }

  void enableButton() {
    if (!isPass || emailId.trim().isEmpty || username.trim().isEmpty) {
      isEnabled = false;
    } else {
      isEnabled = true;
    }
  }
}
