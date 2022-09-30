import 'package:chat_app/resources/colors.dart';
import 'package:chat_app/resources/styles.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailId = "";
  var password = "";
  bool isEnabled = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorDark,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: 550,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: kColorLight)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ChatApp!", style: kFontStyleHeadingMedium),
                const SizedBox(
                  height: 30,
                ),
                EmailField(),
                PasswordField(),
                !isLoading
                    ? LoginButton()
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
                    const Text("Don't have an account? ",
                        style: TextStyle(color: kColorLight)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
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

  Future logIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailId.trim(), password: password.trim());
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Incorrect Email Id or Password',
          style: TextStyle(color: kColorDark),
        ),
        backgroundColor: kThemeColor,
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget EmailField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(width: 1, color: Colors.black),
          color: kColorTextField),
      child: TextField(
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration.collapsed(
            hintText: "Email id",
            hintStyle: TextStyle(color: kColorHintText),
          ),
          onChanged: (text) {
            setState(() {
              if (text.isNotEmpty) {
                isEnabled = true;
              } else {
                isEnabled = false;
              }
              emailId = text;
            });
          }),
    );
  }

  Widget PasswordField() {
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
            });
          }),
    );
  }

  Widget LoginButton() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kColorTextField)),
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          logIn();
        },
        child: Container(
            child: const Text(
          "Login",
          style: TextStyle(color: kColorDark),
        )));
  }
}
