import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mychat/screens/home_screen.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimateText = false;
  bool _isAnimateLoginButton =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        _isAnimateText=true;
      }
      );
      Future.delayed(const Duration(milliseconds: 800),(){
        setState(() {
          _isAnimateLoginButton=true;
        });
      });
    }

    );
  }

  _handleGoogleButtonClick(){
    _signInWithGoogle().then((user){
      Navigator.pushReplacement(
          context, MaterialPageRoute(
          builder: (_)=>HomeScreen()
      )
      );
    });
  }




  Future<UserCredential?> _signInWithGoogle() async {

    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken,
          accessToken: googleAuth?.accessToken
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }catch(e){
          print('\n_signInWithGoogle:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      
      body:Stack(
        children: [
          // App logo
          Positioned(
            top: mq.height*.15,
            width: mq.width*.5,
            left: mq.width*.25,
            child: Image.asset('images/chat.png')
          ),
          
          // welcome greet
           AnimatedOpacity(
              opacity: _isAnimateText?1:0.1,
              duration: const Duration(milliseconds: 1500),
              child: Center(
                  child: Text(
                    'Welcome back, You have been missed!!',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary
                    ),
                  )
              )
          ),

          // Login with google button
          Positioned(
              bottom: mq.height*.15,
              width: mq.width*.7,
              left: mq.width*.15,
              height: mq.height*.07,
              child: AnimatedOpacity(
                opacity: _isAnimateLoginButton?1:0,
                duration: const Duration(milliseconds: 1500),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary
                  ),
                    onPressed: (){
                      _handleGoogleButtonClick();
                    },
                    icon:Image.asset('images/google.png',height: mq.height*0.05,),
                    label: const Text(
                      'Login with Google',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),
                    )
                ),
              )
          )

        ],
      ) ,


    );
  }
}


