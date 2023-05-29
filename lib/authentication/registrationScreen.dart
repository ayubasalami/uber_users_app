import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/loginScreen.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class RegistrationScreen extends StatelessWidget {
  static const id = 'RegistrationScreen';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 25.0,
              ),
              const Image(
                image: AssetImage('images/logo.png'),
                width: 350.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              const SizedBox(
                height: 1.0,
              ),
              const Text(
                'Register as a User',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontFamily: 'Brand Bold'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.yellow),
                      onPressed: () {
                        validate(context);
                      },
                      child: const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18,
                                fontFamily: 'Brand Bold'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
                child: const Text('Already have an account? Login Here'),
              )
            ],
          ),
        ),
      ),
    );
  }

  final auth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(message: 'Loading..');
      },
      barrierDismissible: false,
    );

    final User? firebaseUser = (await firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error: $msg');
    }))
        .user;
    if (firebaseUser != null) {
      Map<String, dynamic> userDataMap = {
        'id': firebaseUser.uid,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
      };
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child('users');
      driversRef.child(firebaseUser.uid).set(userDataMap);
      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: 'Account Creation Successful!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => MySplashScreen(),
        ),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Account not created.. Try again',
      );
    }
  }

  validate(BuildContext context) {
    if (nameController.text.length < 3) {
      Fluttertoast.showToast(
        msg: 'Name must be at least 3 characters',
      );
    } else if (!emailController.text.contains('@')) {
      Fluttertoast.showToast(
        msg: 'Not a valid Email Address',
      );
    } else if (phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Add a phone number');
    } else if (passwordController.text.length < 6) {
      Fluttertoast.showToast(
        msg: 'Password must be at least 6 characters',
      );
    } else {
      registerNewUser(context);
    }
  }
}
