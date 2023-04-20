import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_course/screen/widget/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  //key is used to identify the widget

  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loadding = false;
  RegExp regExp = RegExp(LoginPage.pattern.toString());
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  late UserCredential userCredential;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future loginAuth() async {
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // globalKey.currentState.showSnackBar(
        //   const SnackBar(
        //     content: Text('No user found for that email.'),
        //   ),
        // );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No user found for that email."),
        ));
      } else if (e.code == 'wrong-password') {
        // globalKey.currentState.showSnackBar(
        //   const SnackBar(
        //     content: Text('Wrong password provided for that user.'),
        //   ),
        // );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Wrong password provided for that user."),
        ));
        setState(() {
          loadding = false;
        });
      }
      setState(() {
        loadding = false;
      });
    }
  }

  void validation() {
    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("All Field is Empty"),
      ));
    }
    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email is Empty"),
      ));
      return;
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter vaild Email"),
      ));
      return;
    }
    if (password.text.trim().isEmpty) {
      // globalKey.currentState.showSnackBar(
      //   const SnackBar(
      //     content: Text("Password is Empty"),
      //   ),
      // );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password is Empty"),
      ));
      return;
    } else {
      setState(() {
        loadding = true;
      });
      loginAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {}),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 170),
              child: Text(
                "Login In",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                MyTextField(
                  controller: email,
                  obscureText: false,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextField(
                  controller: password,
                  obscureText: true,
                  hintText: 'Password',
                ),
              ],
            ),
            loadding
                ? const CircularProgressIndicator()
                : Container(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        validation();
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "New user?",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "Register now.",
                  style: TextStyle(color: Colors.red),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
