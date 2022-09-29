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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorDark,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: kColorDark,
      //   title: const Text(
      //     "Login",
      //     style: TextStyle(color: kColorAppBarFont),
      //   ),
      //   centerTitle: true,
      // ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: 400,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: kColorAppBarFont)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("ChatApp!", style: GoogleFonts.lexendDeca(textStyle: TextStyle(color: kBackgroundColor, fontSize: 60))),
                SizedBox(height: 30,),
                Container(
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
                !isLoading? ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(kColorTextField)),
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
                        ))) : SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: kBackgroundColor, strokeWidth: 2,)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: TextStyle(color: kColorAppBarFont)),
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
  Future logIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailId.trim(), password: password.trim());
      print("logged in");
      setState(() {
        isLoading = false;
      });
    }
    catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Incorrect Email Id or Password', style: TextStyle(color: kColorDark),), backgroundColor: kBackgroundColor,));
      setState(() {
        isLoading = false;
      });
    }
  }
}

