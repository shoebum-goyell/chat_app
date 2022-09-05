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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff596E79),
      appBar: AppBar(
        backgroundColor: const Color(0xffC7B198),
        title: const Text(
          "Login Screen",
          style: TextStyle(color: Color(0xff596E79)),
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
                    color: const Color(0xffC7B198)),
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
                    color: const Color(0xffC7B198)),
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
                      MaterialStateProperty.all(Color(0xffC7B198))),
                  onPressed: () {
                   logIn();
                  },
                  child: Container(
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Color(0xff596E79)),
                      )))
            ],
          ),
        ),
      ),
    );
  }
  Future logIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailId.trim(), password: password.trim());
    }
    catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Incorrect Email id or Password')));
    }
  }
}

