import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/registrationScreen.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatelessWidget {
  static const id = 'LoginScreen';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});
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
                height: 35.0,
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
                'Login as a User',
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
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 14.0),
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
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
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow),
                          textStyle: MaterialStateProperty.all(
                            const TextStyle(color: Colors.white),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          )),
                      onPressed: () {
                        validate(context);
                      },
                      child: const SizedBox(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: 'Brand Bold'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => RegistrationScreen()));
                },
                child: const Text('Do not have an account? Register Here'),
              )
            ],
          ),
        ),
      ),
    );
  }

  validate(BuildContext context) {
    if (!emailController.text.contains('@')) {
      Fluttertoast.showToast(
        msg: 'Not a valid Email Address',
      );
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Password is required',
      );
    } else {
      loginNewUser(context);
    }
  }

  void loginNewUser(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(message: 'Loading..');
      },
      barrierDismissible: false,
    );

    final User? firebaseUser = (await firebaseAuth
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error: $msg');
    }))
        .user;
    if (firebaseUser != null) {
      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: 'Log In Successful!');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => const MySplashScreen(),
        ),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Error Occurred During LogIn. Try again',
      );
    }
  }
}
