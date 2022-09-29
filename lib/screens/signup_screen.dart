import 'package:chat_app/resources/colors.dart';
import 'package:chat_app/models/user_obj.dart';
import 'package:chat_app/resources/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool isValidEmail = false;
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
                border: Border.all(color: kColorLight)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome!", style: kFontStyleHeadingMedium),
                const SizedBox(
                  height: 30,
                ),
                EmailInputField(),
                PasswordInputField(),
                UsernameInputField(),
                !isLoading
                    ? SignupButton()
                    : const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: kThemeColor,
                          strokeWidth: 2,
                        )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: kColorLight)),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(color: kThemeColor),
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Couldn't create a new user",
              style: TextStyle(color: kColorDark)),
          backgroundColor: kThemeColor,
        ));
        setState(() {
          isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          !isPass
              ? "Password must be longer than 6 letters"
              : !isValidEmail
                  ? "Enter a valid Email id"
                  : "Username cannot be empty",
          style: TextStyle(color: kColorDark),
        ),
        backgroundColor: kThemeColor,
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  void enableButton() {
    print(isValidEmail);
    if (!isValidEmail || !isPass || username.trim().isEmpty) {
      isEnabled = false;
    } else {
      isEnabled = true;
    }
  }

  Widget EmailInputField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.black),
          color: kColorTextField),
      child: TextField(
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration.collapsed(
            hintText: "Email id",
            hintStyle: TextStyle(color: kColorHintText),
          ),
          onChanged: (text) {
            setState(() {
              emailId = text;
              isValidEmail = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(emailId);
              enableButton();
            });
          }),
    );
  }

  Widget PasswordInputField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.black),
          color: kColorTextField),
      child: TextField(
          obscureText: true,
          decoration: const InputDecoration.collapsed(
              hintText: "Password",
              hintStyle: TextStyle(color: kColorHintText)),
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
    );
  }

  Widget UsernameInputField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.black),
          color: kColorTextField),
      child: TextField(
          autocorrect: false,
          decoration: const InputDecoration.collapsed(
              hintText: "Username",
              hintStyle: TextStyle(color: kColorHintText)),
          onChanged: (text) {
            setState(() {
              username = text;
              enableButton();
            });
          }),
    );
  }

  Widget SignupButton() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kColorTextField)),
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
        )));
  }
}
