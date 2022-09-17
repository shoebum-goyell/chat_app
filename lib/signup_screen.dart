import 'package:chat_app/login_screen.dart';
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
  bool isPass = false;
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff596E79),
      appBar: AppBar(
        backgroundColor: const Color(0xffC7B198),
        title: const Text(
          "SignUp Screen",
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
                        emailId = text;
                        enableButton();
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
                        if(password.length < 6){
                          isPass = false;
                        }
                        else{
                          isPass = true;
                        }
                        enableButton();
                      });
                    }),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0xffC7B198))),
                  onPressed: () {
                    signUp();
                  },
                  child: Container(
                      child: const Text(
                        "Create",
                        style: TextStyle(color: Color(0xff596E79)),
                      ))),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Colors.white)),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Log in",
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
  Future signUp() async{
    if(isEnabled){
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailId.trim(), password: password.trim());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("You've signed up")));
      }
      catch(e){
        print(e.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Couldn't create a new user")));
      }
    }
    else{
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: !isPass? Text("Password must be longer than 6 letters") : Text("Email id cannot be empty")));
    }
  }

  void enableButton(){
    if(!isPass || emailId.isEmpty){
      isEnabled = false;
    }
    else{
      isEnabled = true;
    }
  }
}

