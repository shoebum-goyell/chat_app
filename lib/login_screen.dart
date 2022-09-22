import 'package:chat_app/colors.dart';
import 'package:chat_app/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailId = "";
  var password = "";
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kColorDark,
        title: const Text(
          "Login Screen",
          style: TextStyle(color: kColorAppBarFont),
        ),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1, color: Colors.black),
                    color: kColorTextField),
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Email id",
                      hintStyle: TextStyle(color: Color(0xff596E79)),
                    ),
                    onChanged: (text) {
                      setState(() {
                        if(text.isNotEmpty){
                          isEnabled = true;
                        }
                        else{
                          isEnabled = false;
                        }
                        emailId = text;
                      });
                    }),
              ),
              Container(
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
                        hintStyle: TextStyle(color: Color(0xff596E79))),
                    onChanged: (text) {
                      setState(() {
                        password = text;
                      });
                    }),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(kColorDark)),
                  onPressed: () {
                   logIn();
                  },
                  child: Container(
                      child: const Text(
                        "Login",
                        style: TextStyle(color: kColorAppBarFont),
                      ))),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(color: kColorDark)),
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
                            style: TextStyle(color: Color(0xffC7B198)),
                          )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future logIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailId.trim(), password: password.trim());
      print("logged in");
    }
    catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Incorrect Email id or Password')));
    }
  }
}

